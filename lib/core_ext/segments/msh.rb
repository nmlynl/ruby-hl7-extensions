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
            return @hash if @hash
            
            @hash = super.to_hash
            
            sendingApplication = self.sending_app.split("^") rescue Array.new(20) {|i|""}
            sendingFacility = self.sending_facility.split("^") rescue Array.new(20) {|i|""}
            recvApp = self.recv_app.split("^") rescue Array.new(20) {|i|""}
            recvFacility = self.recv_facility.split("^") rescue Array.new(20) {|i|""}
            message_type = self.message_type.split("^") rescue Array.new(20) {|i|""}
            processing_id = self.processing_id.split("^") rescue Array.new(5) {|i|""}
            version_id = self.version_id.split("^") rescue Array.new(5) {|i|""}
            principal_language_of_message = self.principal_language_of_message.split("^") rescue Array.new(5) {|i|""}
            message_profile_identifier = self.message_profile_identifier.split("^") rescue Array.new(5) {|i|""}
            
            @hash.merge!({"fieldSeparator" => self.enc_chars,
                         "encodingCharacters" => self.enc_chars,
                         "sendingApplication" => {"namespaceId" => sendingApplication[0],
                                                  "universalId" => sendingApplication[1],
                                                  "universalIdType" => sendingApplication[2]},
                         "sendingFacility" => {"namespaceId" => sendingFacility[0],
                                               "universalId" => sendingFacility[1],
                                               "universalIdType" => sendingFacility[2]},
                         "receivingApplication" => {"namespaceId" => recvApp[0],
                                                    "universalId" => recvApp[1],
                                                    "universalIdType" => recvApp[2]},
                         "receivingFacility" => {"namespaceId" => recvFacility[0],
                                                 "universalId" => recvFacility[1],
                                                 "universalIdType" => recvFacility[2]},
                         "dateTime" => self.time,
                         "security" => self.security,
                         "messageType" => {"messageCode" => message_type[0],
                                           "triggerEvent" => message_type[1],
                                           "messageStructure" => message_type[2]},
                         "messageControlId" => self.message_control_id,
                         "processingId" => {"id" => message_control_id[0],
                                            "processingMode" => message_control_id[1]},
                         "versionId" => {"id" => version_id[0],
                                         "internationalizationCode" => version_id[1],
                                         "internationalVersionId" => version_id[2]},
                         "sequenceNumber" => self.seq,
                         "continuationPointer" => self.continue_ptr,
                         "acceptAcknowledgmentType" => self.accept_ack_type,
                         "applicationAcknowledgmentType" => self.app_ack_type,
                         "countryCode" => self.country_code,
                         "characterSet" => self.charset,
                         "principalLanguageOfMessage" => {"id" => principal_language_of_message[0],
                                                          "text" => principal_language_of_message[1],
                                                          "nameOfCodingSystem" => principal_language_of_message[2],
                                                          "alternateId" => principal_language_of_message[3],
                                                          "alternateText" => principal_language_of_message[4],
                                                          "nameOfAlternateCodingSystem" => principal_language_of_message[5]},
                          "alternateCharacterSetHandlingScheme" => self.alternate_character_set_handling_scheme,
                          "messageProfileIdentifier" => {"entityIdentifier" => message_profile_identifier[0],
                                                         "namespaceId" => message_profile_identifier[1],
                                                         "universalId" => message_profile_identifier[2],
                                                         "universalIdType" => message_profile_identifier[3]},
                         "sending_responsible_org" => self.sending_responsible_org,
                         "receiving_responsible_org" => self.receiving_responsible_org,
                         "sending_network_address" => self.sending_network_address,
                         "receiving_network_address" => self.receiving_network_address})
            @hash                      
          end
          
          def value_for_field(key)
            index = key.split(".").first.to_i
            index, subindex = key.split(".").collect {|i|i.to_i}
            field = self.class.field(index-1)
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
          def is_required?
            true
          end
          
          def description
            "Message Header"
          end
          
          def field_description(field_index)
            ["Encoding Characters",
             "Sending Application",
             "Sending Facility",
             "Receiving Application",
             "Receiving Facility",
             "Date/Time Of Message",
             "Security",
             "Message Type",
             "Message Control Id",
             "Processing Id",
             "Version Id",
             "Sequence Number",
             "Continuation Pointer",
             "Accept Acknowledgment Type",
             "Application Acknowledgment Type",
             "Country Code",
             "Character Set",
             "Principal Language Of Message",
             "Alternate Character Set Handling Scheme",
             "Message Profile Identifier",
             "Sending Responsible Organization",
             "Receiving Responsible Organization",
             "Sending Network Address",
             "Receiving Network Address"][field_index-1]            
          end
          
        end
        
      end
    end
  end
end

# Message Types: http://hl7-definition.caristix.com:9010/Default.aspx?version=HL7+v2.5.1&dataType=MSG
# Message : http://hl7-definition.caristix.com:9010/Default.aspx?version=HL7+v2.5.1&dataType=MSG