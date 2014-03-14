class Spree::ImportPromotionInfo < ActiveRecord::Base
  has_many :import_promotion_errors
  has_many :import_promotion_updated
  has_many :import_promotion_new
  has_many :import_promotion_datas

  def report(import_promotion)
    @import_promotion = import_promotion
    @promotion = import_promotion.promotion

    data = { promotion: @promotion, import_errors: get_errors }

    case true
    when has_errors?
      import_promotion_errors.create(data)
    when promotion_updated?
      import_promotion_updated.create(data)
    else
      import_promotion_new.create(data)
    end
  end

  def to_presenter
    ImportPromotionPresenter.new(self)
  end

  private

  def get_errors
    "Linea: #{ @import_promotion.line }, #{ @import_promotion.errors.full_messages.join(', ') }" if has_errors?
  end

  def has_errors?
    !@import_promotion.errors.empty?
  end

  def promotion_updated?
    @promotion.created_at != @promotion.updated_at
  end
end

