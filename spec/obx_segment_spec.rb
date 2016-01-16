# encoding: UTF-8
require 'spec_helper'
describe HL7::Message::Segment::OBX do
  context 'general' do
    before :all do
      @base = "OBX|1|NM|30341-2^Erythrocyte sedimentation rate^LN^815117^ESR^99USI^^^Erythrocyte sedimentation rate||10|mm/h^millimeter per hour^UCUM|0 to 17|N|0.1||F|||20110331140551-0800||Observer|||20110331150551-0800|^A Site|||Century Hospital^^^^^NIST-AA-1&2.16.840.1.113883.3.72.5.30.1&ISO^XX^^^987|2070 Test Park^^Los Angeles^CA^90067^USA^B^^06037|2343242^Knowsalot^Phil^J.^III^Dr.^^^NIST-AA-1&2.16.840.1.113883.3.72.5.30.1&ISO^L^^^DN"
    end

    it 'allows access to an OBX segment' do
      obx = HL7::Message::Segment::OBX.new @base
      obx.set_id.should == "1"
      obx.value_type.should == "NM"
      obx.observation_id.should == "30341-2^Erythrocyte sedimentation rate^LN^815117^ESR^99USI^^^Erythrocyte sedimentation rate"
      obx.observation_sub_id.should == ""
      obx.observation_value.should == "10"
      obx.units.should == "mm/h^millimeter per hour^UCUM"
      obx.references_range.should == "0 to 17"
      obx.abnormal_flags.should == "N"
      obx.probability.should == "0.1"
      obx.nature_of_abnormal_test.should == ""
      obx.observation_result_status.should == "F"
      obx.effective_date_of_reference_range.should == ""
      obx.user_defined_access_checks.should == ""
      obx.observation_date.should == "20110331140551-0800"
      obx.producer_id.should == ""
      obx.responsible_observer.should == "Observer"
      obx.observation_site.should == '^A Site'
      obx.observation_method.should == ""
      obx.equipment_instance_id.should == ""
      obx.analysis_date.should == "20110331150551-0800"
      obx.performing_organization_name.should == "Century Hospital^^^^^NIST-AA-1&2.16.840.1.113883.3.72.5.30.1&ISO^XX^^^987"
      obx.performing_organization_address.should == "2070 Test Park^^Los Angeles^CA^90067^USA^B^^06037"
      obx.performing_organization_medical_director.should == "2343242^Knowsalot^Phil^J.^III^Dr.^^^NIST-AA-1&2.16.840.1.113883.3.72.5.30.1&ISO^L^^^DN"
    end

    it 'allows creation of an OBX segment' do
      lambda do
        obx = HL7::Message::Segment::OBX.new
        obx.value_type = "TESTIES"
        obx.observation_id = "HR"
        obx.observation_sub_id = "2"
        obx.observation_value = "SOMETHING HAPPENned"
      end.should_not raise_error
    end
  end
end
