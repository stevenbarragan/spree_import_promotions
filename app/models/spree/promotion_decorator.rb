Spree::Promotion.class_eval do
  has_one :import_promotion_new, dependent: :destroy
  has_one :import_promotion_error, dependent: :destroy
  has_one :import_promotion_updated, dependent: :destroy
  has_one :import_promotion_data, dependent: :destroy

  attr_accessible :is_gift_card, :activation_expires_at
end
