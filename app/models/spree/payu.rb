module Spree
  class Payu < ActiveRecord::Base
    has_one :payment, as: :source
    belongs_to :order

    def capture
      payment.update_attribute(:state, 'pending') if payment.checkout?
      self
    end

    def void
      payment.update_attribute(:state, 'pending') if payment.checkout?
      self
    end

    def success?
      true
    end

    def authorization
      nil
    end
  end
end
