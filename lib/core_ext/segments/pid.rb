module Extensions
  module HL7
    module Segments
      module PID

        def self.included base
          base.send :include, InstanceMethods
          base.extend ClassMethods
        end
        
        module InstanceMethods
          def mrn 
            to_hash["internalId"]["id"]
          end
          
          def gender
            to_hash["sex"]
          end
          
          def to_hash
            return @hash if @hash
            
            patient_name = self.patient_name.split("^") rescue Array.new(10) {|i| "" }
            address = self.address.split("^") rescue Array.new(10) {|i| "" }
            patientAccountNumber = self.account_number.split("^") rescue Array.new(10) {|i| "" }
            internalId = self.patient_id_list.split("^") rescue Array.new(10) {|i| "" }

            @hash = super.to_hash

            @hash["internalId"] = {"id" => internalId[0], "check_digit" => internalId[1], "check_digit_scheme" => internalId[2],
                                   "assigning_authority" => internalId[3], "type" => internalId[4], "assigning_facility" => internalId[5]}

            @hash["patientName"] = {"lastName" => patient_name[0], "firstName" => patient_name[1], "middleInitOrName"=> patient_name[2]}

            @hash["address"] = {"streetAddress"=>address[0], "otherDesignation"=>address[1], "city"=>address[2], "state"=>address[3], "postalCode"=>address[4], "country"=>address[5], "addressType"=>address[6]}

            @hash["phoneNumbers"] = {"home"=>self.phone_home, "business"=>self.phone_business}

            @hash["patientAccountNumber"] = {"id"=>patientAccountNumber[0], "checkDigit"=>patientAccountNumber[1], "codeIdCheck"=>patientAccountNumber[2], "assigningAuth"=>patientAccountNumber[3], "idTypeCode"=>patientAccountNumber[4], "assigningFacility"=>patientAccountNumber[5]}

            @hash
          end
        end
        
        module ClassMethods
        end
        
      end
    end
  end
end