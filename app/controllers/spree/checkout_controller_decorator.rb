module Spree
  CheckoutController.class_eval do
    skip_before_action :verify_authenticity_token, only: :notify

    before_filter :redirect_to_payu_if_needed, only: [:update]

    private

    def redirect_to_payu_if_needed
      load_order_with_lock
      return unless (params[:state] == "payment")
      return unless params[:order][:payments_attributes]
      pm_id = params[:order][:payments_attributes].first[:payment_method_id]

      payment_method = Spree::PaymentMethod.find(pm_id)
      session[:payment_method_id] = payment_method.id
      return unless payment_method && payment_method.kind_of?(Spree::Gateway::Payu)
      render nothing: true and return if request.xhr?
      redirect_to(checkout_state_path(order.state)) and return
    end
  end
end
