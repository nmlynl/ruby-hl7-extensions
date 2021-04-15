require 'ruby-hl7'

class HL7::Message::Segment::ZDRF < HL7::Message::Segment
  add_field :custom_field_1
  add_field :custom_field_2
  add_field :custom_field_3
  add_field :custom_field_4
  add_field :custom_field_5
  add_field :custom_field_6
  add_field :custom_field_7
  add_field :custom_field_8
  add_field :custom_field_9
  add_field :custom_field_10
  add_field :custom_field_11
  add_field :custom_field_12
  add_field :custom_field_13
  add_field :custom_field_14
  add_field :custom_field_15
  add_field :custom_field_16
  add_field :custom_field_17
  add_field :custom_field_18
  add_field :custom_field_19
  add_field :custom_field_20
  
  def to_hash
    return @hash if @hash
    
    hash = super.to_hash
    hash["id"] = hash["customField1"]
    hash["npi"] = find_value(hash["customField2"])
    hash["phone"] = find_value(hash["customField3"])
    hash["email"] = find_value(hash["customField4"])
    hash["fname"] = find_value(hash["customField5"])
    hash["lname"] = find_value(hash["customField6"])
    hash
  end
  
  def provider_hash(key,code)
    to_hash.merge({"providerType"=>code})
  end
  
  private
  
  def find_value(string="")
    string.split("^").last
  end
end