require 'ruby-hl7'
class HL7::Message::Segment::ROL < HL7::Message::Segment
  weight 4
  add_field :role_instance_id
  add_field :action_code
  add_field :role
  add_field :role_person
  add_field :role_begin_date do |value|
    convert_to_ts(value)
  end
  add_field :role_end_date do |value|
    convert_to_ts(value)
  end
  add_field :role_duration
  add_field :role_action_reason
  add_field :provider_type
  add_field :organization_unit_type
  add_field :provider_info
  add_field :phone
  
  def to_hash
    return @hash if @hash
    @hash = super.to_hash
    @hash
  end
  
  def person_hash
    person = self.role_person.split(self.item_delim) rescue Array.new(20) {|i|""}
    
    {"id" => person[0],
     "lastName" => person[1],
     "firstName" => person[2],
     "middleInitOrName" => person[3],
     "suffix" => person[4],
     "prefix" => person[5],
     "degree" => person[6],
     "sourceTable" => person[7],
     "assigningAuthority" => person[8],
     "nameTypeCode" => person[9],
     "identifierCheckDigit" => person[10],
     "codeIdCheck" => person[11],
     "identifierTypeCode" => person[12],
     "assigningFacility" => person[13],
     "providerType" => self.role}
  end
  
end