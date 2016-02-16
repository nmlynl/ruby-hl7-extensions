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
        end
        
      end
    end
  end
end
    