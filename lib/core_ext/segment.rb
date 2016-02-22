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

        def format_date(attr, format = "%B %d, %Y")
          date = self.send(attr)
          Date.parse(date).strftime(format) if date
        end
          
        def format_datetime(attr, format = "%m/%d/%Y %k:%M")
          datetime = self.send(attr)
          DateTime.parse(datetime).strftime(format) if datetime
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
        
        def provider_hash(provider_type, provider_code)
          if to_hash["#{provider_type}Provider"]
            to_hash["#{provider_type}Provider"].merge("providerType" => provider_code)
          else
            {}
          end
        end
        
        def value_for_field(key)
          index = key.split(".").first.to_i
          index, subindex = key.split(".").collect {|i|i.to_i}
          field = self.class.field(index)
          if field
            if subindex.blank?
              return self.send(field[0].to_s)
            else
              field_val = self.send(field[0].to_s)
              if field_val
                return field_val.split(self.item_delim)[subindex-1]
              else
                return nil
              end
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
        
        def mappings
          field_mappings = self.fields.inject([]) {|arr, k| arr << {field_name: k[0].to_s.gsub("_", " ").titleize, type: "String", field_code: k[1][:idx]}; arr}
          
          {
            metadata: {segment_code: self.to_s.downcase, display_name: ""},
            fields: field_mappings
          }
        end
      end
            
    end
  end
end

class HL7::Message::Segment
  include Extensions::HL7::Segment
end


# HL7::Message::Segment::PV1.fields.inject([]) {|arr, k| arr << {field_name: k[0].to_s.gsub("_", " ").titleize, type: String, field_code: k[1][:idx]}; arr}
#   pp field
# end
#
# ::HL7::Types.enumeration.inject([]) {|arr, k| arr << {code: k[1][0], label: k[1][1]}; arr}}
