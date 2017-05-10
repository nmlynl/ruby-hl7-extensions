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
          if date.blank?
            return nil
          else
            Date.parse(date).strftime(format)
          end
        end
          
        def format_datetime(attr, format = "%m/%d/%Y %k:%M")
          datetime = self.send(attr)
          if datetime.blank?
            return nil
          else 
            DateTime.parse(datetime).strftime(format)
          end
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
          if to_hash["#{provider_type}Provider"] and !to_hash["#{provider_type}Provider"].empty?
            to_hash["#{provider_type}Provider"].merge("providerType" => provider_code)
          else
            {}
          end
        end
        
        def value_for_field(key)
          key = key.to_s
          index = key.split(".").first.to_i
          index, subindex = key.split(".").collect {|i|i.to_i}
          field = self.class.field(index)
          retval= nil
          if field
            if subindex.blank?
              retval = self.send(field[0].to_s)
            else
              field_val = self.send(field[0].to_s)
              if field_val
                retval = field_val.split(self.item_delim)[subindex-1]
              end
            end
          end
          retval = retval.strip  unless retval.blank?
          retval
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
        
        def description
          ""
        end
        
        def field_description(field_index)
          ""
        end

        def is_required?
          false
        end
        
        def index_for(field_name)
          index = self.fields.collect {|field| field[0]}.index(field_name) rescue -1
          if index < 0
            return -1
          else
            return index + 1 
          end
        end
        
        def mappings
          field_mappings = self.fields.inject([]) {|arr, k| arr << {field_name: k[0].to_s.gsub("_", " ").titleize, type: "String", field_code: k[1][:idx]}; arr}
          {
            metadata: {segment_code: self.to_s.split("::").last, display_name: ""},
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
