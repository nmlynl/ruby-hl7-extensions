module Extensions
  module HL7
    module Segments
      module OBX

        def self.included base
          base.send :include, InstanceMethods
          base.extend ClassMethods
        end

        module InstanceMethods
          def test_name
            @hash["identifier"]["text"]
          end

          def to_hash
            identifier = self.observation_id.split("^") rescue Array.new(10) {|i|""}
            producer = self.producer_id.split("^") rescue Array.new(10) {|i|""}
            responsibleObserver = self.responsible_observer rescue Array.new(10) {|i|""}
            @hash = {"setId" => self.set_id,
                    "valueType" => self.value_type,
                    "identifier" => {
                      "id" => identifier[0],
                      "text" => identifier[1],
                      "codingSystem" => identifier[2],
                      "alternateId" => identifier[3],
                      "alternateText" => identifier[4],
                      "alternateCodingSystem" => identifier[5]
                    },
                    "subId" => self.observation_sub_id,
                    "observationValue" => self.observation_value,
                    "units" => self.units,
                    "referenceRange" => self.references_range,
                    "abnormalFlags" => self.abnormal_flags,
                    "probability" => self.probability,
                    "natureOfAbnormal" => self.nature_of_abnormal_test,
                    "observeResultStatus" => self.observation_result_status,
                    "effectiveDateLastNormalValue" => self.effective_date_of_reference_range,
                    "definedAccessChecks" => self.user_defined_access_checks,
                    "observationDate" => self.observation_date,
                    "producerId" => {
                      "identifier" => producer[0],
                      "text" => producer[1]
                    },
                    "responsibleObserver" => {
                      "id" => responsibleObserver[0],
                      "lastName" => responsibleObserver[1],
                      "firstName" => responsibleObserver[2]
                    },
                    "method" => self.observation_method}
          end
        end
        
        module ClassMethods
          
        end
        
      end
    end
  end
end