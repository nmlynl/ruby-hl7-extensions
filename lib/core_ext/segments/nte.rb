module Extensions
  module HL7
    module Segments
      module NTE

        def self.included base
          base.send :include, InstanceMethods
          base.extend ClassMethods
        end
        
        module InstanceMethods
          def to_hash
            @hash = {"setId" => self.set_id,
                     "source" => self.source,
                     "body" => self.comment}
          end
        end
        
        module ClassMethods
        end
        
      end
    end
  end
end
