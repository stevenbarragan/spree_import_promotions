module Spree::Admin::ImportPromotionsHelper
  def to_links(import_promotion_data)
    import_promotion_data.map{ |i| link_to i.promotion.code , edit_admin_promotion_path(i.promotion )}.join(', ')
  end
end
