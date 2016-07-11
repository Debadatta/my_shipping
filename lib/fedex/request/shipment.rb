module MyShipping
	module Fedex
		module shipment
			class Shipment < Base
				super
				private
			    # Add information for shipments
			    def add_requested_shipment(xml)
			        xml.RequestedShipment{
			          xml.ShipTimestamp @shipping_options[:ship_timestamp] ||= Time.now.in_time_zone(LABEL_TIMEZONE).iso8601(2)
			          xml.DropoffType @shipping_options[:drop_off_type] ||= "REGULAR_PICKUP"
			          xml.ServiceType service_type
			          xml.PackagingType @shipping_options[:packaging_type] ||= "YOUR_PACKAGING"
			          add_total_weight(xml) if @mps.has_key? :total_weight
			          add_shipper(xml)
			          add_recipient(xml)
			          add_shipping_charges_payment(xml)
			          add_special_services(xml) if @shipping_options[:return_reason] || @shipping_options[:cod] || @shipping_options[:email_notification]
			          add_customs_clearance(xml) if @customs_clearance_detail
			          add_custom_components(xml)
			          xml.RateRequestTypes "LIST"
			          add_packages(xml)
			        }
			    end

			    def add_special_services(xml)
			        xml.SpecialServicesRequested {
			          	if @shipping_options[:return_reason]
			            	xml.SpecialServiceTypes "RETURN_SHIPMENT"
			            	xml.ReturnShipmentDetail {
			              		xml.ReturnType "PRINT_RETURN_LABEL"
			              		xml.Rma {
			                		xml.Reason "#{@shipping_options[:return_reason]}"
			              		}
			            	}
			          	end
			          	if @shipping_options[:cod]
			            	xml.SpecialServiceTypes "COD"
			            	xml.CodDetail {
			              		xml.CodCollectionAmount {
			                		xml.Currency @shipping_options[:cod][:currency].upcase if @shipping_options[:cod][:currency]
			                		xml.Amount @shipping_options[:cod][:amount] if @shipping_options[:cod][:amount]
			              		}
			              		xml.CollectionType @shipping_options[:cod][:collection_type] if @shipping_options[:cod][:collection_type]
			            	}
			          	end			          
			          	if @shipping_options[:email_notification]
				          	xml.SpecialServiceTypes "EMAIL_NOTIFICATION"
				          	xml.EMailNotificationDetail {
					          	xml.PersonalMessage ''
					          	@shipping_options[:email_notification][:recipients].each_with_index do |email, i|
						          	type =  i > 0 ? "OTHER" : "RECIPIENT"
						          	xml.Recipients {
							          	xml.EMailNotificationRecipientType  type
							          	xml.EMailAddress  email
							          	xml.NotificationEventsRequested 'ON_SHIPMENT'
							          	xml.NotificationEventsRequested 'ON_TENDER'
							          	xml.NotificationEventsRequested 'ON_EXCEPTION'
							          	xml.NotificationEventsRequested 'ON_DELIVERY'
							          	xml.Format  "HTML"
							          	xml.Localization  {
								          	xml.LanguageCode "en"
							          	}
						          	}
					          	end
				          	}
			          	end
			        }
			    end
			end
		end
	end
end
