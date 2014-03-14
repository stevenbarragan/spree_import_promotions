class CreateImportPromotionInfos < ActiveRecord::Migration
  def change
    create_table :spree_import_promotion_infos do |t|
      t.timestamps
    end
  end
end
