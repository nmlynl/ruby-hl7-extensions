module Extensions
  module HL7
    module Segments
      module MSH

        def self.included base
          base.send :include, InstanceMethods
          base.extend ClassMethods
        end
        
        module InstanceMethods
          def to_hash
            @hash = {"enc_chars" => self.enc_chars,
                    "seq" => self.seq,
                    "sendingApplication" => self.sending_app,
                    "sendingFacility" => self.sending_facility,
                    "receivingApplication" => self.recv_app,
                    "receivingFacility" => self.recv_facility,
                    "dateTime" => self.time,
                    "security" => self.security,
                    "messageType" => self.message_type.split("^").first,
                    "messageEvent" => self.message_type.split("^").last,
                    "messageControlId" => self.message_control_id,
                    "processingID" => self.processing_id,
                    "versionID" => self.version_id}
          end
        end
        
        module ClassMethods
        end
        
      end
    end
  end
end

