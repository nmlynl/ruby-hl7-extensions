module Extensions
  module HL7
    module Segments
      module PV1

        def self.included base
          base.send :include, InstanceMethods
          base.extend ClassMethods
        end
        
        module InstanceMethods
          
          def assigned_location_str
            location = self.assigned_location.split(self.item_delim)
            point_of_care = location[0] rescue nil
            room = location[1] rescue nil
            bed = location[2] rescue nil
            
            "#{point_of_care}#{room.blank? ? "" : "-#{room}"}#{bed.blank? ? "" : "-#{bed}"}"
          end

          def prior_location_str
            location = self.prior_location.split(self.item_delim)
            point_of_care = location[0] rescue nil
            room = location[1] rescue nil
            bed = location[2] rescue nil
            
            "#{point_of_care}#{room.blank? ? "" : "-#{room}"}#{bed.blank? ? "" : "-#{bed}"}"
          end
          
          def consulting_provider
            fname = self.value_for_field("9.3")
            lname = self.value_for_field("9.2")
            if fname and lname
              "#{lname}, #{fname}"
            else
              ""
            end
          end
          
          def to_hash
            return @hash if @hash
            
            hash = super.to_hash
            
            assignedLocation = self.hash["assignedLocation"].split("^") rescue Array.new(15) {|i| "" }
            hash["patientLocation"] =  {"pointOfCare" => assignedLocation[0],
                                        "room" => assignedLocation[1],
                                        "bed" => assignedLocation[2],
                                        "facility" => assignedLocation[3],
                                        "locationStatus" => assignedLocation[4],
                                        "personLocationType" => assignedLocation[5],
                                        "building" => assignedLocation[6],
                                        "floor" => assignedLocation[7]}
            
            if self.hash["attendingDoctor"].blank? 
              hash["attendingProvider"] = {}
            else
              attendingProvider = self.hash["attendingDoctor"].split("^") rescue Array.new(20) {|i|""}
              hash["attendingProvider"] = {"id" => attendingProvider[0],
                                           "lastName" => attendingProvider[1],
                                           "firstName" => attendingProvider[2],
                                           "middleInitOrName" => attendingProvider[3],
                                           "suffix" => attendingProvider[4],
                                           "prefix" => attendingProvider[5],
                                           "degree" => attendingProvider[6],
                                           "sourceTable" => attendingProvider[7],
                                           "assigningAuthority" => attendingProvider[8],
                                           "nameTypeCode" => attendingProvider[9],
                                           "identifierCheckDigit" => attendingProvider[10],
                                           "codeIdCheck" => attendingProvider[11],
                                           "identifierTypeCode" => attendingProvider[12],
                                           "assigningFacility" => attendingProvider[13]}
            end
           
            if self.hash["admittingDoctor"].blank?
              hash["admittingProvider"] = {}
            else
              admittingProvider = self.hash["admittingDoctor"].split("^") rescue Array.new(20) {|i|""}
              hash["admittingProvider"] = {"id" => admittingProvider[0],
                                           "lastName" => admittingProvider[1],
                                           "firstName" => admittingProvider[2],
                                           "middleInitOrName" => admittingProvider[3],
                                           "suffix" => admittingProvider[4],
                                           "prefix" => admittingProvider[5],
                                           "degree" => admittingProvider[6],
                                           "sourceTable" => admittingProvider[7],
                                           "assigningAuthority" => admittingProvider[8],
                                           "nameTypeCode" => admittingProvider[9],
                                           "identifierCheckDigit" => admittingProvider[10],
                                           "codeIdCheck" => admittingProvider[11],
                                           "identifierTypeCode" => admittingProvider[12],
                                           "assigningFacility" => admittingProvider[13]}
            end
            
            if self.hash["referringDoctor"].blank?
              hash["referringProvider"] = {}
            else
              referringProvider = self.hash["referringDoctor"].split("^") rescue Array.new(20) {|i|""}
              hash["referringProvider"] = {"id" => referringProvider[0],
                                           "lastName" => referringProvider[1],
                                           "firstName" => referringProvider[2],
                                           "middleInitOrName" => referringProvider[3],
                                           "suffix" => referringProvider[4],
                                           "prefix" => referringProvider[5],
                                           "degree" => referringProvider[6],
                                           "sourceTable" => referringProvider[7],
                                           "assigningAuthority" => referringProvider[8],
                                           "nameTypeCode" => referringProvider[9],
                                           "identifierCheckDigit" => referringProvider[10],
                                           "codeIdCheck" => referringProvider[11],
                                           "identifierTypeCode" => referringProvider[12],
                                           "assigningFacility" => referringProvider[13]}
            end
            
            if self.hash["consultingDoctor"].blank?
              hash["consultingProvider"] = {}
            else
              consultingProvider = self.hash["consultingDoctor"].split("^") rescue Array.new(20) {|i|""}
              hash["consultingProvider"] = {"id" => consultingProvider[0],
                                           "lastName" => consultingProvider[1],
                                           "firstName" => consultingProvider[2],
                                           "middleInitOrName" => consultingProvider[3],
                                           "suffix" => consultingProvider[4],
                                           "prefix" => consultingProvider[5],
                                           "degree" => consultingProvider[6],
                                           "sourceTable" => consultingProvider[7],
                                           "assigningAuthority" => consultingProvider[8],
                                           "nameTypeCode" => consultingProvider[9],
                                           "identifierCheckDigit" => consultingProvider[10],
                                           "codeIdCheck" => consultingProvider[11],
                                           "identifierTypeCode" => consultingProvider[12],
                                           "assigningFacility" => consultingProvider[13]}
            end
            visitNumber = self.hash["visitNumber"].split("^") rescue Array.new(20) {|i|""}
            hash["visit"] = {"id" => visitNumber[0],
                             "checkDigit" => visitNumber[1],
                             "codeIdCheck" => visitNumber[2],
                             "assigningAuthority" => visitNumber[3],
                             "idTypeCode" => visitNumber[4]}

            @hash = hash
          end
        end
        
        module ClassMethods
          def description
            "Patient Visit"
          end
          
          def field_description(field_index)
            [
              "Set Id - Pv1",
              "Patient Class",
              "Assigned Patient Location",
              "Admission Type",
              "Preadmit Number",
              "Prior Patient Location",
              "Attending Doctor",
              "Referring Doctor",
              "Consulting Doctor",
              "Hospital Service",
              "Temporary Location",
              "Preadmit Test Indicator",
              "Re-admission Indicator",
              "Admit Source",
              "Ambulatory Status",
              "Vip Indicator",
              "Admitting Doctor",
              "Patient Type",
              "Visit Number",
              "Financial Class",
              "Charge Price Indicator",
              "Courtesy Code",
              "Credit Rating",
              "Contract Code",
              "Contract Effective Date",
              "Contract Amount",
              "Contract Period",
              "Interest Code",
              "Transfer To Bad Debt Code",
              "Transfer To Bad Debt Date",
              "Bad Debt Agency Code",
              "Bad Debt Transfer Amount",
              "Bad Debt Recovery Amount",
              "Delete Account Indicator",
              "Delete Account Date",
              "Discharge Disposition",
              "Discharged To Location",
              "Diet Type",
              "Servicing Facility",
              "Bed Status",
              "Account Status",
              "Pending Location",
              "Prior Temporary Location",
              "Admit Date/Time",
              "Discharge Date/Time",
              "Current Patient Balance",
              "Total Charges",
              "Total Adjustments",
              "Total Payments",
              "Alternate Visit Id",
              "Visit Indicator",
              "Other Healthcare Provider",
              "Service Episode Description",
              "Service Episode Identifier",
            ][field_index-1]
          end
          
        end
        
      end
    end
  end
end