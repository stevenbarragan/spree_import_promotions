class CreateSpreeImportPromotionData < ActiveRecord::Migration
  def change
    create_table :spree_import_promotion_data do |t|
      t.integer :promotion_id
      t.integer :import_promotion_info_id
      t.text    :import_errors
      t.string  :type
    end
  end
end
