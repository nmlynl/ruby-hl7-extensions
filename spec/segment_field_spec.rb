# encoding: UTF-8
require 'spec_helper'

class MockSegment < HL7::Message::Segment
  weight 1
  add_field :no_block
  alias_field :no_block_alias, :no_block
  add_field :validating do |value|
    value == "bad" ? nil : value
  end
  add_field :converting do |value|
    "X" + value
  end
end

describe HL7::Message::Segment do
  before :all do
    @base = "Mock|no_block|validated|converted"
  end

  context "block on field definitions" do
    it 'is evaluated on access by field name' do
      msg = MockSegment.new(@base)

      msg.to_s.should       == @base
      msg.no_block.should   == "no_block"
      msg.validating.should == "validated"
      msg.converting.should == "Xconverted"

      msg.no_block = "NO_BLOCK"
      msg.no_block.should == "NO_BLOCK"

      msg.validating = "good"
      msg.validating.should == "good"
      msg.validating = "bad"
      msg.validating.should == ""

      msg.converting = "empty"
      msg.converting.should == "XXempty"
    end

    it 'is not evaluated on read access by eXXX alias' do
      msg = MockSegment.new(@base)

      msg.e1.should == "no_block"
      msg.e2.should == "validated"
      msg.e3.should == "converted"
    end

    it 'is not evaluated on write access by eXXX alias' do
      msg = MockSegment.new(@base)

      msg.e1 = "NO_BLOCK"
      msg.e1.should == "NO_BLOCK"

      msg.e2 = "good"
      msg.e2.should == "good"
      msg.e2 = "bad"
      msg.e2.should == "bad"

      msg.e3 = "empty"
      msg.e3.should == "empty"
    end
  end

  describe '#alias_field' do
    context 'with a valid field' do
      it 'uses alias field names' do
        msg = MockSegment.new(@base)
        msg.no_block.should == "no_block"
        msg.no_block_alias.should == "no_block"
      end
    end

    context 'with an invalid field' do

      class MockInvalidSegment < HL7::Message::Segment
        weight 1
        add_field :no_block
        alias_field :no_block_alias, :invalid_field
        add_field :second
        add_field :third
      end


      it 'throws an error when the field is invalid' do
        msg = MockInvalidSegment.new(@base)
        lambda{  msg.no_block_alias }.should raise_error
      end
    end
  end
end
