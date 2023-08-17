# encoding: UTF-8
require 'ruby-hl7'

class HL7::Message::Segment::DG1 < HL7::Message::Segment
  weight 100
  add_field :set_id, { :idx => 1}
  add_field :diagnosis_coding_method, { :idx => 2}
  add_field :diagnosis_code, { :idx => 3}
  add_field :diagnosis_description, { :idx => 4}
  add_field :diagnosis_date_time, { :idx => 5} do |value|
    convert_to_ts(value)
  end
  add_field :diagnosis_type, { :idx => 6}
  add_field :major_diagnostic_category, { :idx => 7}
  add_field :diagnostic_related_group, { :idx => 8}
  add_field :drg_approval_indicator, { :idx => 9}
  add_field :drg_grouper_review_code, { :idx => 10}
  add_field :outlier_type, { :idx => 11}
  add_field :outlier_days, { :idx => 12}
  add_field :outlier_cost, { :idx => 13}
  add_field :grouper_version_and_type, { :idx => 14}
  add_field :diagnosis_priority, { :idx => 15}
  add_field :diagnosing_clinician, { :idx => 16}
  add_field :diagnosis_classification, { :idx => 17}
  add_field :confidential_indicator, { :idx => 18}
  add_field :attestation_date_time, { :idx => 19} do |value|
    convert_to_ts(value)
  end
  add_field :diagnosis_identifier, { :idx => 20}
  add_field :diagnosis_action_code, { :idx => 21}
end