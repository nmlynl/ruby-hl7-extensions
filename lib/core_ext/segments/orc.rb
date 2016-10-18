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
          
          def order_control_text
            OrderControl.t(self.order_control) rescue nil
          end
          
          def ordering_provider_name
            "#{to_hash["orderingProvider"]["lastName"]}, #{@hash["orderingProvider"]["firstName"]}#{@hash["orderingProvider"]["middleInitOrName"].blank? ? "" : " #{@hash["orderingProvider"]["middleInitOrName"]}"}"
          end
          
          def obr_list
            # a = to_hash["OBR"]["array"].collect {|obr| ::HL7::Message::Segment.from_hash("OBR", obr)}
            # a.to_enum(:each)            
            to_hash["OBR"]["segment_array"].to_enum(:each)
          end
          
          def to_hash
            return @hash if @hash
            
            @hash = super.to_hash
            
            placer_order_number = self.placer_order_number.split("^") rescue Array.new(10) {|i|""}
            filler_order_number = self.filler_order_number.split("^") rescue Array.new(10) {|i|""}
            placer_group_number = self.placer_group_number.split("^") rescue Array.new(10) {|i|""}
            quantity_timing = self.quantity_timing.split("^") rescue Array.new(15) {|i|""}
            parent = self.parent..split("^") rescue Array.new(20) {|i|""}
            orderingProvider = self.ordering_provider.split("^") rescue Array.new(20) {|i|""}
            
            @hash.merge!({"orderControl" => self.order_control,
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
                          "parentUniversalServiceIdentifier" => self.parent_universal_service_identifier})
                          
            @hash              
          end
        end
        
        module ClassMethods
        end
        
        class OrderControl < EnumerateIt::Base
          associate_values(NW: ['NW', 'New Order'],
                           OK: ['OK', 'Order/service accepted & OK'],
                           UA: ['UA', 'Unable to accept order/service'],
                           CA: ['CA', 'Canceled Order'],
                           OC: ['OC', 'Canceled Order'],
                           CR: ['CR', 'Canceled Order'],
                           UC: ['UC', 'Unable to cancel'],
                           DC: ['DC', 'Discontinue order/service request'],
                           OD: ['OD', 'Order/service discontinued'],
                           DR: ['DR', 'Discontinued as requested'],
                           UD: ['UD', 'Unable to discontinue'],
                           HD: ['HD', 'Hold order request'],
                           OH: ['OH', 'Order/service held'],
                           UH: ['UH', 'Unable to put on hold'],
                           HR: ['HR', 'On hold as requested'],
                           RL: ['RL', 'Release previous hold'],
                           OE: ['OE', 'Order/service released'],
                           OR: ['OR', 'Released as requested'],
                           UR: ['UR', 'Unable to release'],
                           RP: ['RP', 'Order/service replace request'],
                           RU: ['RU', 'Replaced unsolicited'],
                           RO: ['RO', 'Replacement order'],
                           RQ: ['RQ', 'Replaced as requested'],
                           UM: ['UM', 'Unable to replace'],
                           PA: ['PA', 'Parent order/service'],
                           CH: ['CH', 'Child order/service'],
                           XO: ['XO', 'Change Order'],
                           XX: ['XX', 'Change Order'],
                           UX: ['UX', 'Unable to change'],
                           XR: ['XR', 'Changed as requested'],
                           DE: ['DE', 'Data errors'],
                           RE: ['RE', 'Observations/Performed Service to follow'],
                           RR: ['RR', 'Request received'],
                           SR: ['SR', 'Response to send order/service status request'],
                           SS: ['SS', 'Send order/service status request'],
                           SC: ['SC', 'Status changed'],
                           SN: ['SN', 'Send order/service number'],
                           NA: ['NA', 'Number assigned'],
                           CN: ['CN', 'Combined result'],
                           RF: ['RF', 'Refill order/service request'],
                           AF: ['AF', 'Order/service refill request approval'],
                           DF: ['DF', 'Order/service refill request denied'],
                           FU: ['FU', 'Order/service refilled, unsolicited'],
                           OF: ['OF', 'Order/service refilled as requested'],
                           UF: ['UF', 'Unable to refill'],
                           LI: ['LI', 'Link order/service to patient care problem or goal'],
                           UN: ['UN', 'Unlink order/service from patient care problem or goal'],
                           OP: ['OP', 'Notification of order for outside dispense'],
                           PY: ['PY', 'Notification of replacement order for outside dispense'])
                           
        end
      end
    end
  end
end