module MyShipping
	module Fedex
		module request
			class Rate < Base
				private
			    # Add information for shipments
			    def add_requested_shipment(xml)
			        xml.RequestedShipment {
			    	    xml.ShipTimestamp @shipping_options[:ship_timestamp] ||= Time.now.in_time_zone(LABEL_TIMEZONE).iso8601(2)
			        	xml.DropoffType @shipping_options[:drop_off_type] ||= "REGULAR_PICKUP"
			            xml.ServiceType service_type if service_type
			            xml.PackagingType @shipping_options[:packaging_type] ||= "YOUR_PACKAGING"
			            add_shipper(xml)
			            add_recipient(xml)
			          	add_shipping_charges_payment(xml)
			          	add_customs_clearance(xml) if @customs_clearance_detail
			          	xml.RateRequestTypes "LIST"
			          	add_packages(xml)
			        }
			    end
			end
		end
	end
end