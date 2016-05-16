module Spree
  class PayuController < Spree::StoreController
    skip_before_action :verify_authenticity_token, only: :notify

    def notify
      notification = PayuIndia::Notification.new(request.query_string, options = { key: payment_method.preferred_key,
                    salt: payment_method.preferred_salt,
                    params: params
                  })

      # notification.invoice is order id/order id which you have submited from payment direction page.
      order = Order.find_by_number(notification.invoice)

      if notification.acknowledge
        if notification.complete?
          order.payments.create!({
            source: Spree::Payu.create!(
              transaction_id: notification.transaction_id,
              options: params,
              order_id: order.id,
              gateway_customer_profile_id: notification.transaction_id
            ),
            response_code: notification.transaction_id,
            amount: order.total,
            payment_method: payment_method
          })
          order.next
          if order.completed?
            @current_order = nil
            flash.notice = Spree.t(:order_processed_successfully)
            flash['order_completed'] = true
            redirect_to order_path(order)
          else
            redirect_to checkout_state_path(order.state)
          end
        else
          redirect_to checkout_state_path(order.state)
        end
      end
    end

    def payment_method
      @payment_method ||= Spree::PaymentMethod.find(session[:payment_method_id])
    end
  end
end