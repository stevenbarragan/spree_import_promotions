class Spree::ImportPromotionData < ActiveRecord::Base
  attr_accessible :promotion, :import_errors

  belongs_to :promotion
  belongs_to :import_promotion_info
end
