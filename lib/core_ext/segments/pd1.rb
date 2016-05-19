require 'ruby-hl7'
class HL7::Message::Segment::PD1 < HL7::Message::Segment
  weight 5

  add_field :living_dependency #1-2 character code
  add_field :living_arrangement #1-2 character code
  add_field :primary_facility #facility http://hl7-definition.caristix.com:9010/Default.aspx?version=HL7%20v2.5.1&dataType=XON
  add_field :primary_care_provider #provider http://hl7-definition.caristix.com:9010/Default.aspx?version=HL7%20v2.5.1&dataType=XCN
  add_field :student_indicator #1-2 character code
  add_field :handicap #1-2 character code
  add_field :living_will_code #1-2 character code
  add_field :organ_donor_code #1-2 character code
  add_field :separate_bill #1-2 character code
  add_field :duplicate_patient #hash http://hl7-definition.caristix.com:9010/Default.aspx?version=HL7%20v2.5.1&dataType=CX
  add_field :publicity_code #hash http://hl7-definition.caristix.com:9010/Default.aspx?version=HL7%20v2.5.1&dataType=CE
  add_field :protection_indicator #Y or N
  add_field :protection_indicator_effective_date do |value|
    convert_to_ts(value)
  end
  add_field :place_of_worship #hash http://hl7-definition.caristix.com:9010/Default.aspx?version=HL7%20v2.5.1&dataType=XON
  add_field :advance_directive_code #hash http://hl7-definition.caristix.com:9010/Default.aspx?version=HL7+v2.5.1&dataType=CE
  add_field :immunization_registry_status #1 char code
  add_field :immunization_registry_status_effective_date do |value|
    convert_to_ts(value)
  end #date
  add_field :publicity_code_effective_date do |value|
    convert_to_ts(value)
  end #date
  add_field :military_branch
  add_field :military_rank
  add_field :military_status
  
  def to_hash
    return @hash if @hash
    
    hash = super.to_hash
    
    if self.hash["primaryCareProvider"].blank? 
      hash["primaryCareProvider"] = {}
    else
      primaryCareProvider = self.hash["primaryCareProvider"].split("^") rescue Array.new(30) {|i|""}
      hash["primaryCareProvider"] = {"id" => primaryCareProvider[0],
                                     "lastName" => primaryCareProvider[1],
                                     "firstName" => primaryCareProvider[2],
                                     "middleInitOrName" => primaryCareProvider[3],
                                     "suffix" => primaryCareProvider[4],
                                     "prefix" => primaryCareProvider[5],
                                     "degree" => primaryCareProvider[6],
                                     "sourceTable" => primaryCareProvider[7],
                                     "assigningAuthority" => primaryCareProvider[8],
                                     "nameTypeCode" => primaryCareProvider[9],
                                     "identifierCheckDigit" => primaryCareProvider[10],
                                     "codeIdCheck" => primaryCareProvider[11],
                                     "identifierTypeCode" => primaryCareProvider[12],
                                     "assigningFacility" => primaryCareProvider[13]}
    end
   
    @hash = hash
  end

end