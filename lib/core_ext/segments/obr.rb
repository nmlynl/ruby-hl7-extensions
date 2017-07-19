module Extensions
  module HL7
    module Segments
      module OBR

        def self.included base
          base.send :include, InstanceMethods
          base.extend ClassMethods
        end
        
        module InstanceMethods
          def ordering_provider_hash
            to_hash["orderingProvider"]
          end
          
          def ordering_provider_name
            "#{@hash["orderingProvider"]["lastName"]}, #{@hash["orderingProvider"]["firstName"]}#{@hash["orderingProvider"]["middleInitOrName"].blank? ? "" : " #{@hash["orderingProvider"]["middleInitOrName"]}"}"
          end
  
          def obx_list
            # a = @hash["OBX"]["array"].collect {|obr| ::HL7::Message::Segment.from_hash("OBX", obr)}
            # a.to_enum(:each)
            @hash["OBX"]["segment_array"].to_enum(:each)
          end
  
          def to_hash
            return @hash if @hash
            
            @hash = super.to_hash
            
            universalServiceId = self.universal_service_id.split("^") rescue Array.new(10) {|i|""}
            collectionVolume = self.collection_volume.split("^") rescue Array.new(10) {|i|""}
            orderingProvider = self.ordering_provider.split("^") rescue Array.new(20) {|i|""}
            quantityTiming = self.quantity_timing.split("^") rescue Array.new(10) {|i|""}
            resultCopiesTo = self.result_copies_to.split("^") rescue Array.new(10) {|i|""}
            parent = self.parent.split("^") rescue Array.new(10) {|i|""}
    
            @hash.merge!({"setId" => self.set_id,
                         "placerOrderNumber" => self.placer_order_number,
                         "fillerOrderNumber" => self.filler_order_number,
                         "universalServiceId" => {"id" => universalServiceId[0],
                                                  "text" => universalServiceId[1],
                                                  "coddingSystem" => universalServiceId[2],
                                                  "alternateId" => universalServiceId[3],
                                                  "alternateText" => universalServiceId[4]},
                         "priority" => self.priority,
                         "requestedDateTime" => self.requested_date,
                         "observationDateTime" => self.observation_date,
                         "observationEndDate" => self.observation_end_date,
                         "collectionVolume" => {"quantity" => collectionVolume[0], "units" => collectionVolume[1]},
                         "collectorIdentifier" => self.collector_identifier,
                         "specimenActionCode" => self.specimen_action_code,
                         "dangerCode" => self.danger_code,
                         "relevantClinicalInfo" => self.relevant_clinical_info,
                         "specimenReceivedDateTime" => self.specimen_received_date,
                         "specimenSource" => self.specimen_source,
                         "orderingProvider" => 
                              {
                                "id" => orderingProvider[0],
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
                                "providerType" => "OP"
                              },
                          "orderCallBackNumber" => self.order_callback_phone_number,
                          "placerField1" => self.placer_field_1,
                          "placerField2" => self.placer_field_2,
                          "fillerField1" => self.filler_field_1,
                          "fillerField2" => self.filler_field_2,
                          "rptStatusChangeDate" => self.results_status_change_date,
                          "chargeToPractice" => self.charge_to_practice,
                          "diagnosticServiceSectId" => self.diagnostic_serv_sect_id,
                          "resultStatus" => self.result_status,
                          "linkedResults" => self.parent_result,
                          "quantityTiming" => {
                              "quantity" => quantityTiming[0],
                              "interval" => quantityTiming[1],
                              "duration" => quantityTiming[2],
                              "startDateTime" => quantityTiming[3],
                              "endDateTime" => quantityTiming[4],
                              "priority" => quantityTiming[5]
                            },
                            "resultCopiesTo" => [
                              {
                                "id" => resultCopiesTo[0],
                                "lastName" => resultCopiesTo[1],
                                "firstName" => resultCopiesTo[2],
                                "middleInitOrName" => resultCopiesTo[3]
                              }
                            ],
                            "parent" => {
                              "placerOrderNumber" => parent[0],
                              "fillerOrderNumber" => parent[1]
                            },
                            "transportationMode" => self.transport_mode,
                            "reasonForStudy" => self.reason_for_study,
                            "principalResultInterpreter" => self.principal_result_interpreter,
                            "assistantResultInterpreter" => self.assistant_result_interpreter,
                            "technician" => self.technician,
                            "transcriptionist" => self.transcriptionist,
                            "scheduledDate" => self.scheduled_date,
                            "number_of_sample_containers" => self.number_of_sample_containers,
                            "transport_logistics_of_sample" => self.transport_logistics_of_sample,
                            "collectors_comment" => self.collectors_comment,
                            "transport_arrangement_responsibility" => self.transport_arrangement_responsibility,
                            "transport_arranged" => self.transport_arranged,
                            "escort_required" => self.escort_required,
                            "planned_patient_transport_comment" => self.planned_patient_transport_comment,
                            "procedure_code" => self.procedure_code,
                            "procedure_code_modifier" => self.procedure_code_modifier,
                            "placer_supplemental_service_info" => self.placer_supplemental_service_info,
                            "filler_supplemental_service_info" => self.filler_supplemental_service_info,
                            "medically_necessary_dup_procedure_reason" => self.medically_necessary_dup_procedure_reason,
                            "result_handling" => self.result_handling,
                            "parent_universal_service_identifier" => self.parent_universal_service_identifier})
                            
            @hash
          end
        end
        
        module ClassMethods
        end
        
      end
    end
  end
end
