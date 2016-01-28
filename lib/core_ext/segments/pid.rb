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
          
          def to_hash
            return @hash if @hash
            
            patient_name = self.patient_name.split("^") rescue Array.new(10) {|i| "" }
            address = self.address.split("^") rescue Array.new(10) {|i| "" }
            patientAccountNumber = self.account_number.split("^") rescue Array.new(10) {|i| "" }
            internalId = self.patient_id_list.split("^") rescue Array.new(10) {|i| "" }

            @hash = {"setId" => self.set_id,
                     "externalId" => self.patient_id, 
                     "internalId" => {"id" => internalId[0], "check_digit" => internalId[1], "check_digit_scheme" => internalId[2], 
                                      "assigning_authority" => internalId[3], "type" => internalId[4], "assigning_facility" => internalId[5]}, 
                     "alternateId" => self.alt_patient_id, 
                     "patientName" => {"lastName" => patient_name[0], "firstName" => patient_name[1], "middleInitOrName"=> patient_name[2]}, 
                     "mothersMaidenName" => self.mother_maiden_name, 
                     "dateTimeBirth" => self.patient_dob, 
                     "sex" => self.admin_sex, 
                     "alias" => self.patient_alias, 
                     "race" => self.race, 
                     "address"=>{"streetAddress"=>address[0], "otherDesignation"=>address[1], "city"=>address[2], "state"=>address[3], "postalCode"=>address[4], "country"=>address[5], "addressType"=>address[6]}, 
                     "countyCode"=> self.country_code, 
                     "phoneNumbers"=>{"home"=>self.phone_home, "business"=>self.phone_business}, 
                     "homePhone"=>{"number" => "","useCode" => "", "equipmentType" => "", "email" => "", "countryCode" => "", "areaCode" => "", "phoneNumber" => ""},
                     "primaryLanguage"=>self.primary_language, 
                     "maritalStatus"=>self.marital_status, 
                     "religion"=>self.religion, 
                     "patientAccountNumber"=>{"id"=>patientAccountNumber[0], "checkDigit"=>patientAccountNumber[1], "codeIdCheck"=>patientAccountNumber[2], "assigningAuth"=>patientAccountNumber[3], "idTypeCode"=>patientAccountNumber[4], "assigningFacility"=>patientAccountNumber[5]},
                     "ssn"=>self.social_security_num, 
                     "driversLicenseNumber"=>self.driver_license_num, 
                     "mothersId"=>self.mothers_id, 
                     "ethnicGroup"=>self.ethnic_group, 
                     "birthPlace"=>self.birthplace, 
                     "multipleBirthIndicator"=>self.multi_birth, 
                     "birthOrder"=>self.birth_order, 
                     "citizenship"=>self.citizenship, 
                     "veteranStatus"=>self.vet_status, 
                     "nationality"=>self.nationality, 
                     "deathDateTime"=>self.death_date, 
                     "deathIndicator"=>self.death_indicator}
          end
        end
        
        module ClassMethods
        end
        
      end
    end
  end
end