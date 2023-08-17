# encoding: UTF-8
require 'ruby-hl7'

class HL7::Message::Segment::DRF < HL7::Message::Segment
  weight 100
  add_field :set_id, { :idx => 1}
  add_field :field2, { :idx => 2}
  add_field :field3, { :idx => 3}
  add_field :field4, { :idx => 4}
  add_field :field5, { :idx => 5}
  add_field :field6, { :idx => 6}
  add_field :field7, { :idx => 7}
  add_field :field8, { :idx => 8}
  add_field :field9, { :idx => 9}
  add_field :field10, { :idx => 10}
end