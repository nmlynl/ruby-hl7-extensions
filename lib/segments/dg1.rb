# encoding: UTF-8
require 'ruby-hl7'

class HL7::Message::Segment::DG1 < HL7::Message::Segment
  weight 100
  add_field :set_id
  add_field :diagnosis_coding_method
  add_field :diagnosis_code
  add_field :diagnosis_description
  add_field :diagnosis_date_time do |value|
    convert_to_ts(value)
  end
  add_field :diagnosis_type
  add_field :major_diagnostic_category
  add_field :diagnostic_related_group
  add_field :drg_approval_indicator
  add_field :drg_grouper_review_code
  add_field :outlier_type
  add_field :outlier_days
  add_field :outlier_cost
  add_field :grouper_version_and_type
  add_field :diagnosis_priority
  add_field :diagnosing_clinician
  add_field :diagnosis_classification
  add_field :confidential_indicator
  add_field :attestation_date_time do |value|
    convert_to_ts(value)
  end
  add_field :diagnosis_identifier
  add_field :diagnosis_action_code
end