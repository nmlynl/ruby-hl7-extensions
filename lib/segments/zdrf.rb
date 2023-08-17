require 'ruby-hl7'

class HL7::Message::Segment::ZDRF < HL7::Message::Segment
  add_field :custom_field_1, { :idx => 1}
  add_field :custom_field_2, { :idx => 2}
  add_field :custom_field_3, { :idx => 3}
  add_field :custom_field_4, { :idx => 4}
  add_field :custom_field_5, { :idx => 5}
  add_field :custom_field_6, { :idx => 6}
  add_field :custom_field_7, { :idx => 7}
  add_field :custom_field_8, { :idx => 8}
  add_field :custom_field_9, { :idx => 9}
  add_field :custom_field_10, { :idx => 10}
  add_field :custom_field_11, { :idx => 11}
  add_field :custom_field_12, { :idx => 12}
  add_field :custom_field_13, { :idx => 13}
  add_field :custom_field_14, { :idx => 14}
  add_field :custom_field_15, { :idx => 15}
  add_field :custom_field_16, { :idx => 16}
  add_field :custom_field_17, { :idx => 17}
  add_field :custom_field_18, { :idx => 18}
  add_field :custom_field_19, { :idx => 19}
  add_field :custom_field_20, { :idx => 20}
  
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