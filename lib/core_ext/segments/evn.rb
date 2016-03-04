module Extensions
  module HL7
    module Segments
      module EVN

        def self.included base
          base.send :include, InstanceMethods
          base.extend ClassMethods
        end
        
        module InstanceMethods
          def event_datetime
            self.event_occurred || self.recorded_date
          end  
        end
        
        module ClassMethods
          def description
            "Event Type"
          end
          
          def field_description(field_index)
            [
              "Event Type Code",
              "Recorded Date/Time",
              "Date/Time Planned Event",
              "Event Reason Code",
              "Operator Id",
              "Event Occurred",
              "Event Facility"
              ][field_index-1]
          end
        end
        
      end
    end
  end
end
    