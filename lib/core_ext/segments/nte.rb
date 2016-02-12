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
            return @hash if @hash
            
            @hash = super.to_hash
            
            @hash.merge!({"setId" => self.set_id,
                          "source" => self.source,
                          "body" => self.comment})
            
            @hash
          end
        end
        
        module ClassMethods
        end
        
      end
    end
  end
end
