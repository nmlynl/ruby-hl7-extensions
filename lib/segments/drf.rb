# encoding: UTF-8
require 'ruby-hl7'

class HL7::Message::Segment::DRF < HL7::Message::Segment
  weight 100
  add_field :set_id
  add_field :field1
  add_field :field2
  add_field :field3
  add_field :field4
  add_field :field5
  add_field :field6
  add_field :field7
  add_field :field8
  add_field :field9
  add_field :field10
end