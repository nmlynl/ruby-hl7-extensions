module Extensions
  module HL7
    module Segments
      module IN1

        def self.included base
          base.send :include, InstanceMethods
          base.extend ClassMethods
        end
        
        module InstanceMethods
          def insurance_co
            self.value_for_field("4")
          end
          
          def insurance_plan
            self.value_for_field("2.2")
          end
          
          def insured_name
            lname = self.value_for_field("16.1")
            fname = self.value_for_field("16.2")
            middle = self.value_for_field("16.3")
            "#{lname}, #{fname} #{middle}"
          end
          
          def insured_address
            if self.value_for_field("19")
              address1, address2, city, state, zip = self.value_for_field("19").split(@item_delim) 
              "#{address1}#{address2.blank? ? "," : ", #{address2},"} #{city}, #{state}, #{zip}"
            else
              ""
            end
          end
        end
      end
    end
  end
end
