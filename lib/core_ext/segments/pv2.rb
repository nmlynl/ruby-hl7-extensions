module Extensions
  module HL7
    module Segments
      module PV2

        def self.included base
          base.send :include, InstanceMethods
          base.extend ClassMethods
        end
        
        module InstanceMethods
        end
        
      end
    end
  end
end