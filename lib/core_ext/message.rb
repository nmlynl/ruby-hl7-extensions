module Extensions
  module HL7
    module Message
      attr_accessor :hash

      def self.included base
        base.send :include, InstanceMethods
        base.extend ClassMethods
      end

      module InstanceMethods
        def segments_for(key)
          self.select {|segment| segment.segment_name == key.to_s}
        end
        
        def providers
          providers = []

          if self[:ORC]
            orcs = self[:ORC].is_a?(Array) ? self[:ORC] : [self[:ORC]]
            orcs.each do |orc|
              providers << {hash: orc.ordering_provider_hash, segment: orc}
            end
          end
        
          if self[:OBR]
            obrs = self[:OBR].is_a?(Array) ? self[:OBR] : [self[:OBR]]
            obrs.each do |obr|
              providers << {hash: obr.ordering_provider_hash, segment: obr}
            end
          end
        
          if self[:PV1]
            pv1 = self[:PV1]
            providers << {hash: pv1.provider_hash("admitting","AD"), segment: self[:PV1]}
            providers << {hash: pv1.provider_hash("attending","AT"), segment: self[:PV1]}
            providers << {hash: pv1.provider_hash("consulting","CP"), segment: self[:PV1]}
            providers << {hash: pv1.provider_hash("referring","RP"), segment: self[:PV1]}
          end
        
          if self[:ROL]
            roles = self[:ROL]
            roles = [self[:ROL]] unless self[:ROL].is_a?Array
            roles.each do |rol| 
              providers << {hash: rol.person_hash, segment: rol}
            end
          end 
            
          providers
        end
        
        def msh
          @msh ||= segments_for(:MSH).first
        end
        
        def message_type
          msh.value_for_field("8.1")
        end
        
        def event
          msh.value_for_field("8.2")
        end
        
        def sending_application
          msh.value_for_field("3.1")
        end
        
        def pid
          @pid ||= segments_for(:PID).first
        end
        
        def patient_full_name
          last_name = pid.value_for_field("5.1")
          first_name = pid.value_for_field("5.2")
          middle_initial_or_name = pid.value_for_field("5.3")

          "#{last_name}, #{first_name}#{middle_initial_or_name.blank? ? "" : " #{middle_initial_or_name}"}"
        end

        def patient_dob
          Date.parse(pid.patient_dob).strftime("%B %d, %Y") if pid.patient_dob
        end

        def patient_mrn
          pid.value_for_field("3.1")
        end

        def patient_gender
          pid.value_for_field("8")
        end

        def pv1
          @pv1 ||= segments_for(:PV1).first
        end
        
        def account_number
          pv1.value_for_field("19.1")
        end

        def obr_list
          # segments_for(:OBR).to_enum(:each)
          a = hash["message"]["content"]["OBR"]["array"].collect {|obr| ::HL7::Message::Segment.from_hash("OBR", obr)}
          a.to_enum(:each)
        end

        def orc_list
          # segments_for(:OBR).to_enum(:each)
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
