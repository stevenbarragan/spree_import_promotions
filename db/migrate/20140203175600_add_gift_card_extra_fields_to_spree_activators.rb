class AddGiftCardExtraFieldsToSpreeActivators < ActiveRecord::Migration
  def up
    add_column :spree_activators, :is_gift_card, :boolean, default: false
    add_column :spree_activators, :activated,    :boolean, default: false
    add_column :spree_activators, :activation_expires_at,  :datetime
  end

  def down
    remove_column :spree_activators, :is_gift_card
    remove_column :spree_activators, :activated
    remove_column :spree_activators, :activation_expires_at
  end
end
