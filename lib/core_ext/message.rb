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
        
        def message_type
          msh = hash["message"]["content"]["MSH"]
          @msh ||= ::HL7::Message::Segment.from_hash("MSH", msh)
          @msh.to_hash["messageType"]["messageCode"]
        end
        
        def event
          msh = hash["message"]["content"]["MSH"]
          @msh ||= ::HL7::Message::Segment.from_hash("MSH", msh)
          @msh.to_hash["messageType"]["triggerEvent"]
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

        def patient_mrn
          pid = hash["message"]["content"]["PID"]
          @pid ||= ::HL7::Message::Segment.from_hash("PID", pid)
          @pid.mrn
        end

        def patient_gender
          hash["message"]["content"]["PID"]["sex"]
        end

        def obr_list
          a = hash["message"]["content"]["OBR"]["array"].collect {|obr| ::HL7::Message::Segment.from_hash("OBR", obr)}
          a.to_enum(:each)
        end

        def patient
          patient = hash["message"]["content"]["PID"]
          ::HL7::Message::Segment.from_hash("PID", patient)
        end

        def patient_visit
          patient_visit = hash["message"]["content"]["PV1"]
          ::HL7::Message::Segment.from_hash("PV1", patient_visit)
        end

        def orc_list
          a = hash["message"]["content"]["ORC"]["array"].collect {|orc| ::HL7::Message::Segment.from_hash("ORC", orc)}
          a.to_enum(:each)
        end
        
        def hash 
          to_hash
        end
        
        def to_hash
          begin
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
                if last_segment == "ORC"
                  @hash[:message][:content]["ORC"]["array"].last["OBR"] ||= {}
                  @hash[:message][:content]["ORC"]["array"].last["OBR"]["array"] ||= []
                  @hash[:message][:content]["ORC"]["array"].last["OBR"]["array"] << segment.to_hash
                else
                  last_segment = segment_name
                end
              elsif segment_name == "OBX"
                if last_segment == "OBR"
                  @hash[:message][:content]["OBR"]["array"].last[segment_name] ||= {}
                  @hash[:message][:content]["OBR"]["array"].last[segment_name]["array"] ||= []
                  @hash[:message][:content]["OBR"]["array"].last[segment_name]["array"] << segment.to_hash
                end
              elsif segment_name == "ORC"
                @hash[:message][:content]["ORC"] ||= {}
                @hash[:message][:content]["ORC"]["array"] ||= []
                @hash[:message][:content]["ORC"]["array"] << segment.to_hash
                last_segment = segment_name
              elsif segment_name == "NTE"
                if last_segment == "OBR"
                  @hash[:message][:content]["OBR"]["array"].last["OBX"] ||= {}
                  @hash[:message][:content]["OBR"]["array"].last["OBX"]["array"] ||= []
                  if @hash[:message][:content]["OBR"]["array"].last["OBX"]["array"].length>0
                    @hash[:message][:content]["OBR"]["array"].last["OBX"]["array"].last["notes"] ||= [] 
                    @hash[:message][:content]["OBR"]["array"].last["OBX"]["array"].last["notes"] << segment.to_hash
                  end
                end
              else
                @hash[:message][:content][segment_name.to_sym] = segment.to_hash
              end
              @hash[:message][:content]["EVN"] = @hash[:message][:content]["MSH"]["messageEvent"] if segment_name == "MSH"
            end

            @hash
          rescue => e
            puts e.message
            pp e.backtrace[0..10]
          end
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
