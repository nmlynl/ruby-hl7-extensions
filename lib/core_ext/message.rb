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
        
        def reason_for_visit(add_newline = true)
          retval = ""
          if pv2
            retval << (add_newline ? "\n" : "")
            retval << "Reason for Visit: #{@pv2.admit_reason}"
          end
          retval
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
            pv1 = [pv1] unless pv1.is_a?Array
            pv1.each do |pv|
              providers << {hash: pv.provider_hash("admitting","AD"), segment: pv}
              providers << {hash: pv.provider_hash("attending","AT"), segment: pv}
              providers << {hash: pv.provider_hash("consulting","CP"), segment: pv}
              providers << {hash: pv.provider_hash("referring","RP"), segment: pv}
              providers << {hash: pv.provider_hash("otherHealthcare","OTHER"), segment: pv}
            end
          end
        
          if self[:ROL]
            roles = self[:ROL]
            roles = [self[:ROL]] unless self[:ROL].is_a?Array
            roles.each do |rol| 
              providers << {hash: rol.person_hash, segment: rol}
            end
          end 
          
          if self[:PD1]
            pd1 = self[:PD1]
            pd1 = [pd1] unless pd1.is_a?Array
            pd1.each do |pd|
              providers << {hash: pd.provider_hash("primaryCare","PP"), segment: pd}
            end
          end
          
          if self[:ZNP]
            znp = self[:ZNP]
            znp = [znp] unless znp.is_a?Array
            znp.each do |z|
              providers << {hash: z.provider_hash("znpProvider","ZNP"), segment: z}
            end
          end

          retval = []
          providers.inject(retval) {|a,provider| a << provider unless provider[:hash].empty?; a}
          retval
        end
        
        def notes
          notes_str = ""
          
          if self[:NTE]
            notes = self[:NTE]
            notes = [notes] unless notes.is_a?Array
            notes.each do |nte|
              note = nte.value_for_field("3").gsub("\n","") rescue nil
              if note
                if note.include?"^"
                  notes_str << "#{nte.value_for_field("3.2")}: #{nte.value_for_field("3.4")}"
                else
                  notes_str << note
                end
              else
              end
              notes_str << "\n"
            end            
          end
          
          notes_str
        end

        def evn
          @evn ||= segments_for(:EVN).first
        end
        
        def msh
          @msh ||= segments_for(:MSH).first
        end
        
        def pid
          @pid ||= segments_for(:PID).first
        end
        
        def pv1
          @pv1 ||= segments_for(:PV1).first
        end
        
        def pv2
          @pv2 ||= segments_for(:PV2).first
        end

        def pd1
          @pd1 ||= segments_for(:PD1).first
        end

        def in1
          @in1 ||= segments_for(:IN1).first
        end
        
        def dg1
          @dg1 ||= segments_for(:DG1).first
        end

        def mrg
          @mrg ||= segments_for(:MRG).first
        end

        def drf
          @drf ||= segments_for(:DRF).first
        end

        def obr_list
          # a = hash["message"]["content"]["OBR"]["array"].collect {|obr| ::HL7::Message::Segment.from_hash("OBR", obr)}
          # a.to_enum(:each)
          hash["message"]["content"]["OBR"]["segment_array"].to_enum(:each)
        end

        def orc_list
          # a = hash["message"]["content"]["ORC"]["array"].collect {|orc| ::HL7::Message::Segment.from_hash("ORC", orc)}
          # a.to_enum(:each)
          hash["message"]["content"]["ORC"]["segment_array"].to_enum(:each)          
        end
        
        def message_type
          msh.value_for_field("9.1")
        end
        
        def event
          msh.value_for_field("9.2")
        end
        
        def sending_application
          msh.value_for_field("3.1")
        end
        
        def patient_mrn
          pid.value_for_field("3.1")
        end

        def account_number
          pv1.value_for_field("19.1")
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
                @hash[:message][:content][segment_name.to_sym]["segment_array"] ||= []
                @hash[:message][:content][segment_name.to_sym]["segment_array"] << segment

                if last_segment == "ORC"
                  @hash[:message][:content]["ORC"]["array"].last["OBR"] ||= {}
                  @hash[:message][:content]["ORC"]["array"].last["OBR"]["array"] ||= []
                  @hash[:message][:content]["ORC"]["array"].last["OBR"]["array"] << segment.to_hash
                  @hash[:message][:content]["ORC"]["array"].last["OBR"]["segment_array"] ||= []
                  @hash[:message][:content]["ORC"]["array"].last["OBR"]["segment_array"] << segment                  
                else
                  last_segment = segment_name
                end
              elsif segment_name == "OBX"
                if last_segment == "OBR"
                  @hash[:message][:content]["OBR"]["array"].last[segment_name] ||= {}
                  @hash[:message][:content]["OBR"]["array"].last[segment_name]["array"] ||= []
                  @hash[:message][:content]["OBR"]["array"].last[segment_name]["array"] << segment.to_hash
                  @hash[:message][:content]["OBR"]["array"].last[segment_name]["segment_array"] ||= []                  
                  @hash[:message][:content]["OBR"]["array"].last[segment_name]["segment_array"] << segment                  
                end
              elsif segment_name == "ORC"
                @hash[:message][:content]["ORC"] ||= {}
                @hash[:message][:content]["ORC"]["array"] ||= []
                @hash[:message][:content]["ORC"]["array"] << segment.to_hash
                @hash[:message][:content]["ORC"]["segment_array"] ||= []
                @hash[:message][:content]["ORC"]["segment_array"] << segment                
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
              elsif segment_name == "TQ1"

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
