require 'csv'

class ImportPromotionsWorker
  include Sidekiq::Worker

  def perform(file_path)
    data = parse_file(file_path)

    data.each_with_index do |row, line|
      row << reporter.id
      row << line

      Spree::ImportPromotion.delay.create(translate(row))
    end
  end

  def reporter
    @reporter ||= Spree::ImportPromotionInfo.create
  end

  def parse_file(file_path)
    csv = CSV.parse(open(file_path).read.force_encoding('iso8859-1').encode('utf-8'))
    csv.shift
    csv
  end

  def translate(row)
    Hash[keys.zip row]
  end

  def keys
    [
      :name,
      :starts_at,
      :expires_at,
      :code,
      :amount,
      :usage_limit,
      :description,
      :is_gift_card,
      :activation_expires_at,
      :reporter_id,
      :line
    ]
  end
end
