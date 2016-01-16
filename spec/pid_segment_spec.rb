# encoding: UTF-8
require 'spec_helper'

describe HL7::Message::Segment::PID do
  context 'general' do
    before :all do
      @base = "PID|1||333||LastName^FirstName^MiddleInitial^SR^NickName||19760228|F||2106-3^White^HL70005^CAUC^Caucasian^L||||||||555.55|012345678||||||||||201011110924-0700|Y|||||||||"
    end

    it 'validates the admin_sex element' do
      pid = HL7::Message::Segment::PID.new
      lambda do
        vals = %w[F M O U A N C] + [ nil ]
        vals.each do |x|
          pid.admin_sex = x
        end
        pid.admin_sex = ""
      end.should_not raise_error

      lambda do
        ["TEST", "A", 1, 2].each do |x|
          pid.admin_sex = x
        end
      end.should raise_error(HL7::InvalidDataError)
    end

    it "sets values correctly" do
      pid = HL7::Message::Segment::PID.new @base
      pid.set_id.should == "1"
      pid.patient_id.should == ""
      pid.patient_id_list.should == "333"
      pid.alt_patient_id.should == ""
      pid.patient_name.should == "LastName^FirstName^MiddleInitial^SR^NickName"
      pid.mother_maiden_name.should == ""
      pid.patient_dob.should == "19760228"
      pid.admin_sex.should == "F"
      pid.patient_alias.should == ""
      pid.race.should == "2106-3^White^HL70005^CAUC^Caucasian^L"
      pid.address.should == ""
      pid.country_code.should == ""
      pid.phone_home.should == ""
      pid.phone_business.should == ""
      pid.primary_language.should == ""
      pid.marital_status.should == ""
      pid.religion.should == ""
      pid.account_number.should == "555.55"
      pid.social_security_num.should == "012345678"
      pid.driver_license_num.should == ""
      pid.mothers_id.should == ""
      pid.ethnic_group.should == ""
      pid.birthplace.should == ""
      pid.multi_birth.should == ""
      pid.birth_order.should == ""
      pid.citizenship.should == ""
      pid.vet_status.should == ""
      pid.nationality.should == ""
      pid.death_date.should == "201011110924-0700"
      pid.death_indicator.should == "Y"
      pid.id_unknown_indicator.should == ""
      pid.id_readability_code.should == ""
      pid.last_update_date.should == ""
      pid.last_update_facility.should == ""
      pid.species_code.should == ""
      pid.breed_code.should == ""
      pid.strain.should == ""
      pid.production_class_code.should == ""
      pid.tribal_citizenship.should == ""
    end
  end
end
