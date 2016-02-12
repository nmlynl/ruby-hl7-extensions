module Extensions
  module HL7
    module Segment
      attr_accessor :hash
      
      def self.included base
        base.send :include, InstanceMethods
        base.extend ClassMethods
      end
      
      module InstanceMethods
  
        def [](key)
          to_hash[key]
        end
        
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
        
        def value_for_field(key)
          index = key.split(".").first.to_i
          index, subindex = key.split(".").collect {|i|i.to_i}
          field = self.class.field(index)
          if field
            if subindex.blank?
              return self.send(field[0].to_s)
            else
              return self.send(field[0].to_s).split(self.item_delim)[subindex-1]
            end
          end
        end
      end
      
      module ClassMethods
        def field(index)
          fields.each do |field|
            return field if field[1][:idx] == index
          end
        end
        
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

class HL7::Message::Segment
  include Extensions::HL7::Segment
end
