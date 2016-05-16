class AddGatewayCustomerProfileIdToPayu < ActiveRecord::Migration
  def change
    add_column :spree_payus, :gateway_customer_profile_id, :string
  end
end
