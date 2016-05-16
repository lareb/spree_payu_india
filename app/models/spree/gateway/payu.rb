require 'net/http'
require 'net/https'
require 'uri'

module Spree
  class Gateway::Payu < Gateway
    preference :key, :string, default: 'gtKFFx'
    preference :salt, :string, default: 'eCwWELxi'

    def payment_profiles_supported?
      false
    end

    def provider_class
      Gateway::Payu
    end

    def cancel(*)
    end

    def source_required?
      true
    end

    def credit(*)
      self
    end

    def success?
      true
    end

    def authorization
      self
    end

    def method_type
      'payu'
    end

    def self.payu
      find_by(type: 'Spree::Gateway::Payu', active: true, environment: Rails.env)
    end

    def purchase(money, source, options = {})
      source.capture
    end

    def auto_capture?
      true
    end
  end
end