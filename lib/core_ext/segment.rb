module Extensions
  module HL7
    module Segment
      attr_accessor :hash
      
      def self.included base
        base.send :include, InstanceMethods
        base.extend ClassMethods
      end
      
      module InstanceMethods
        
        def segment_name
          self.class.to_s.split("::").last
        end
  
        def to_hash
          @hash ||= {}
          fields = self.class.fields
          if fields.is_a?Hash
            self.class.fields.keys.each do |key|
              @hash[key.to_s.camelize(:lower)] = self.handle_element(key)
            end
          end
          @hash
        end
  
        def handle_element(key)
          self.send(key)
        end
      end
      
      module ClassMethods
        def from_hash(type, hash)
          clazz = eval("::HL7::Message::Segment::#{type}")
          instance = clazz.new
          instance.hash = hash

          fields = clazz.fields
          fields.keys.each do |field|
            instance.send("#{field}=",hash[field.to_s.camelize(:lower)])
          end  
          instance
        end
      end
            
    end
  end
end