class PayuOrder
  include Rails.application.routes.url_helpers

  def self.params(order, payu_callback_url)
    products = order.line_items.map do |li|
      {
        name: li.product.name,
        value: "#{li.price.to_i} per unit",
        description: "#{li.quantity} units"
      }
    end

    payu = Spree::Gateway::Payu.payu
    {
      salt: payu.preferred_salt,
      key: payu.preferred_key,
      txnid: order.number,
      amount: order.total.to_f,
      productinfo: {
        paymentParts: products
        },
      firstname: order.bill_address.try(:firstname),
      lastname: order.bill_address.try(:lastname),
      address1: order.bill_address.try(:address1),
      address2: order.bill_address.try(:address2),
      city: order.bill_address.try(:city),
      state: order.bill_address.try(:state_text),
      country: order.bill_address.try(:country).try(:iso),
      zipcode: order.bill_address.try(:zipcode),
      email: order.email,
      phone: order.bill_address.try(:phone),
      shipping_firstname: order.shipping_address.try(:firstname),
      shipping_lastname: order.shipping_address.try(:lastname),
      shipping_address1: order.shipping_address.try(:address1),
      shipping_address2: order.shipping_address.try(:address2),
      shipping_city: order.shipping_address.try(:city),
      shipping_state: order.shipping_address.try(:state_text),
      shipping_country: order.shipping_address.try(:country).try(:iso),
      shipping_zipcode: order.shipping_address.try(:zipcode),
      shipping_phone: order.shipping_address.try(:phone),
      surl: payu_callback_url,
      furl: payu_callback_url,
      curl: payu_callback_url,
      mode: :test
    }
  end
end
