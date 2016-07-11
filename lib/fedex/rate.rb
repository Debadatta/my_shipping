module MyShipping
	module Fedex
		class rate
			attr_accessor :commit, :service_type, :transit_time, :rate_type, :rate_zone, :total_billing_weight, :total_freight_discounts, :total_net_charge, :total_taxes, :total_net_freight, :total_surcharges, :total_base_charge
		    def initialize(options = {})
		      super
		      @commit = (options[:commit]||{})
		    end
		end
	end
end
