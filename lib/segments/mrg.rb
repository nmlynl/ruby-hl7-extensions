require 'ruby-hl7'

class HL7::Message::Segment::MRG < HL7::Message::Segment
  weight 4
  add_field :prior_patient_identifier_list, { :idx => 1}
  add_field :prior_alternate_patient_id, { :idx => 2}
  add_field :prior_patient_account_number, { :idx => 3}
  add_field :prior_patient_id, { :idx => 4}
  add_field :prior_visit_number, { :idx => 5}
  add_field :prior_alternate_visit_id, { :idx => 6}
  add_field :prior_patient_name, { :idx => 7}
end
