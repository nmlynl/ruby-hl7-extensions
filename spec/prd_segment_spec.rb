# encoding: UTF-8
require 'spec_helper'

describe HL7::Message::Segment::PRD do
  context 'general' do
    let (:base) { 'PRD|RP|LastName^FirstName^MiddleInitial^SR^NickName|444 Home Street^Apt B^Ann Arbor^MI^99999^USA|^^^A Wonderful Clinic|^WPN^PH^^^07^5555555|PH|4796^AUSHICPR|20130109163307+1000|20140109163307+1000' }
    let (:prd) { HL7::Message::Segment::PRD.new base }

    it 'should set the provider_role' do
      prd.provider_role.should eql 'RP'
    end

    it 'should set the name' do
      prd.provider_name.should eql 'LastName^FirstName^MiddleInitial^SR^NickName'
    end

    it 'should set the provider_address' do
      prd.provider_address.should eql '444 Home Street^Apt B^Ann Arbor^MI^99999^USA'
    end

    it 'should set the provider_location' do
      prd.provider_location.should eql '^^^A Wonderful Clinic'
    end

    it 'should set provider_communication_information' do
      prd.provider_communication_information.should eql '^WPN^PH^^^07^5555555'
    end
  end
end
