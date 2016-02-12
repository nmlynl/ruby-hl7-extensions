module Extensions
  module HL7
    module Segments
      module ORC

        def self.included base
          base.send :include, InstanceMethods
          base.extend ClassMethods
        end

        module InstanceMethods
          def ordering_provider_hash
            to_hash["orderingProvider"]
          end
          
          def obr_list
            a = to_hash["OBR"]["array"].collect {|obr| ::HL7::Message::Segment.from_hash("OBR", obr)}
            a.to_enum(:each)            
          end
          
          def to_hash
            return @hash if @hash
            
            placer_order_number = self.placer_order_number.split("^") rescue Array.new(10) {|i|""}
            filler_order_number = self.filler_order_number.split("^") rescue Array.new(10) {|i|""}
            placer_group_number = self.placer_group_number.split("^") rescue Array.new(10) {|i|""}
            quantity_timing = self.quantity_timing.split("^") rescue Array.new(15) {|i|""}
            parent = self.parent..split("^") rescue Array.new(20) {|i|""}
            orderingProvider = self.ordering_provider.split("^") rescue Array.new(20) {|i|""}
            
            @hash = {"orderControl" => self.order_control,
                      "placerOrderNumber" => {"entityIdentifier" => placer_order_number[0],
                                              "namespaceID" => placer_order_number[1],
                                              "universalID" => placer_order_number[2],
                                              "universalIDType" => placer_order_number[3]},
                      "fillerOrderNumber" => {"entityIdentifier" => filler_order_number[0],
                                              "namespaceID" => filler_order_number[1],
                                              "universalID" => filler_order_number[2],
                                              "universalIDType" => filler_order_number[3]},
                      "placerGroupNumber" => {"entityIdentifier" => placer_group_number[0],
                                                "namespaceID" => placer_group_number[1],
                                                "universalID" => placer_group_number[2],
                                                "universalIDType" => placer_group_number[3]},
                      "orderStatus" => self.order_status,
                      "responseFlag" => self.response_flag,
                      "quantityTiming" => {"quantity" => quantity_timing[0], "interval" => quantity_timing[1], "duration" => quantity_timing[2],
                                            "startDateTime" => quantity_timing[3], "endDateTime" => quantity_timing[4], "priority" => quantity_timing[5],
                                            "condition" => quantity_timing[6], "text" => quantity_timing[7], "conjunction" => quantity_timing[8], "orderSequencing" => quantity_timing[9]},
                      "parent" => self.parent,
                      "dateTimeOfTransaction" => self.date_time_of_transaction,
                      "enteredBy" => self.entered_by,
                      "verifiedBy" => self.verified_by,
                      "orderingProvider" => {"id" => orderingProvider[0],
                                             "lastName" => orderingProvider[1],
                                             "firstName" => orderingProvider[2],
                                             "middleInitOrName" => orderingProvider[3],
                                             "suffix" => orderingProvider[4],
                                             "prefix" => orderingProvider[5],
                                             "degree" => orderingProvider[6],
                                             "sourceTable" => orderingProvider[7],
                                             "assigningAuthority" => orderingProvider[8],
                                             "nameTypeCode" => orderingProvider[9],
                                             "identifierCheckDigit" => orderingProvider[10],
                                             "checkDigitScheme" => orderingProvider[11],
                                             "idTypeCode" => orderingProvider[12],
                                             "isTypeCode" => orderingProvider[13],
                                             "assigningFacility" => orderingProvider[14],
                                             "providerType" => "OP"},
                      "enterersLocation" => self.enterers_location,
                      "callBackPhoneNumber" => self.call_back_phone_number,
                      "orderEffectiveDateTime" => self.order_effective_date_time,
                      "orderControlCodeReason" => self.order_control_code_reason,
                      "enteringOrganization" => self.entering_organization,
                      "enteringDevice" => self.entering_device,
                      "actionBy" => self.action_by,
                      "advancedBeneficiaryNoticeCode" => self.advanced_beneficiary_notice_code,
                      "orderingFacilityName" => self.ordering_facility_name,
                      "orderingFacilityAddress" => self.ordering_facility_address,
                      "orderingFacilityPhoneNumber" => self.ordering_facility_phone_number,
                      "orderingProviderAddress" => self.ordering_provider_address,
                      "orderStatusModifier" => self.order_status_modifier,
                      "advancedBeneficiaryNoticeOverrideReason" => self.advanced_beneficiary_notice_override_reason,
                      "fillersExpectedAvailabilityDateTime" => self.fillers_expected_availability_date_time,
                      "confidentialityCode" => self.confidentiality_code,
                      "orderType" => self.order_type,
                      "entererAuthorizationMode" => self.enterer_authorization_mode,
                      "parentUniversalServiceIdentifier" => self.parent_universal_service_identifier}
          end
        end
        
        module ClassMethods
          
        end
        
      end
    end
  end
end