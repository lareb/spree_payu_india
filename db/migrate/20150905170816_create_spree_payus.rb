class CreateSpreePayus < ActiveRecord::Migration
  def change
    create_table :spree_payus do |t|
      t.string :transaction_id
      t.integer :order_id
      t.json :options, default: {}
      t.timestamps
    end
  end
end
