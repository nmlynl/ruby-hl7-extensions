module Extensions
  module HL7
    module Message
      attr_accessor :hash

      def self.included base
        base.send :include, InstanceMethods
        base.extend ClassMethods
      end

      module InstanceMethods
        def providers
          providers = []
        
          if self[:OBR]
            obrs = self[:OBR].is_a?(Array) ? self[:OBR] : [self[:OBR]]
            obrs.each do |obr|
              providers << {hash: obr.ordering_provider_hash, segment: obr}
            end
          end
        
          if self[:PV1]
            pv1 = self[:PV1]
            providers << {hash: pv1.admitting_provider_hash, segment: self[:PV1]}
            providers << {hash: pv1.attending_provider_hash, segment: self[:PV1]}
            providers << {hash: pv1.consulting_provider_hash, segment: self[:PV1]}
            providers << {hash: pv1.referring_provider_hash, segment: self[:PV1]}
          end
        
          providers
        end
        
        def event
          hash[:message][:content]["EVN"]
        end
        
        def sending_application
          hash[:message][:content]["MSH"]["sendingApplication"] rescue nil
        end
        
        def patient_full_name
          name = hash["message"]["content"]["PID"]["patientName"]
          "#{name["lastName"]}, #{name["firstName"]}#{name["middleInitOrName"].blank? ? "" : " #{name["middleInitOrName"]}"}"
        end

        def patient_dob
          Date.parse(hash["message"]["content"]["PID"]["dateTimeBirth"]).strftime("%B %d, %Y")
        end

        def patient_gender
          hash["message"]["content"]["PID"]["sex"]
        end

        def obr_list
          a = hash["message"]["content"]["OBR"]["array"].collect {|obr| ::HL7::Message::Segment.from_hash("OBR", obr)}
          a.to_enum(:each)
        end

        def hash 
          to_hash
        end
        
        def to_hash
          return @hash unless @hash.blank?
          @hash ||= HashWithIndifferentAccess.new
          @hash[:message] = {content: {}}

          last_segment = nil
          self.each do |segment|
            segment_name = segment.segment_name
            if segment_name == "OBR"
              @hash[:message][:content][segment_name.to_sym] ||= {}
              @hash[:message][:content][segment_name.to_sym]["array"] ||= []
              @hash[:message][:content][segment_name.to_sym]["array"] << segment.to_hash

              @hash[:message][:content][segment_name.to_sym]["array"]

              last_segment = segment_name
            elsif segment_name == "OBX"
              if last_segment == "OBR"
                @hash[:message][:content]["OBR"]["array"].last[segment_name] ||= {}
                @hash[:message][:content]["OBR"]["array"].last[segment_name]["array"] ||= []
                @hash[:message][:content]["OBR"]["array"].last[segment_name]["array"] << segment.to_hash
              end
            elsif segment_name == "NTE"
              if last_segment == "OBR"
                @hash[:message][:content]["OBR"]["array"].last["OBX"] ||= {}
                @hash[:message][:content]["OBR"]["array"].last["OBX"]["array"] ||= []
                @hash[:message][:content]["OBR"]["array"].last["OBX"]["array"].last["notes"] ||= [] if @hash[:message][:content]["OBR"]["array"].last["OBX"]["array"].length>0
                @hash[:message][:content]["OBR"]["array"].last["OBX"]["array"].last["notes"] << segment.to_hash
              end
            else
              @hash[:message][:content][segment_name.to_sym] = segment.to_hash
            end
            @hash[:message][:content]["EVN"] = @hash[:message][:content]["MSH"]["messageEvent"] if segment_name == "MSH"
          end

          @hash
        end

        def to_json
          to_hash
          @hash.to_json
        end
      end
      
      module ClassMethods
      end
      
    end
  end
end

class HL7::Message
  include Extensions::HL7::Message
end
