class Spree::Admin::ImportPromotionsController < Spree::Admin::BaseController
  def new
    @import_promotion_infos = Spree::ImportPromotionInfo
                              .order('created_at DESC')
                              .limit(10)
                              .map(&:to_presenter)

    @working =  Sidekiq::Status::working? session[:promotion_worker]
  end

  def create
    file = params[:file]

    if !file || !valid_csv_extension?(file) || !valid_encoding?(file)
      flash_message = { error: 'Formato de archivo invalido, intenta de nuevo' }

    else
      file.rewind
      temp_file_path = Rails.root.join('tmp', 'import_products.temp')

      temp_file = File.open(temp_file_path, 'wb')
      temp_file.write file.read
      temp_file.close

      session[:promotion_worker] = ImportPromotionsWorker.perform_async(upload_s3(temp_file_path))

      flash_message = { notice: 'Tu importacion esta siendo procesada' }
    end

    redirect_to new_admin_import_promotions_path, flash: flash_message
  end

  private

  def upload_s3(temp_file_path)
    if Rails.env.development?
      temp_file_path.to_s
    else
      s3 = AWS::S3.new(
        access_key_id: Spree::Config[:s3_access_key],
        secret_access_key: Spree::Config[:s3_secret]
      )

      bucket = s3.buckets[Spree::Config[:s3_bucket]]
      bucket = s3.buckets.create Spree::Config[:s3_bucket] unless bucket.exists?

      object = bucket.objects.create("import_promotions/promotions_#{Time.now.to_i}.csv", data: File.open(temp_file_path), acl: :public_read)
      object.public_url.to_s
    end
  end

  def valid_csv_extension?(file)
    file.original_filename[-3..-1].downcase == 'csv'
  end

  def valid_encoding?(file)
    file.read.force_encoding('iso8859-1').encode('utf-8').valid_encoding?
  end
end
