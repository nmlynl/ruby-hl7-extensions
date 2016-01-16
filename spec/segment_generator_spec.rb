require 'spec_helper'

describe HL7::Message::SegmentGenerator do
  describe 'valid_segments_parts?' do

    let(:element){ "MSH|1|2|3" }
    let(:delimiter){ HL7::Message::Delimiter.new('|', '^', '\r') }
    let(:segment_generator) do
      HL7::Message::SegmentGenerator.new(element, nil, delimiter)
    end

    it "should return true if @seg_parts is an array of one element or more" do
      segment_generator.valid_segments_parts?.should be true
    end

    context 'when is empty' do
      it "should return false if empty_segment_is_error is false" do
        segment_generator.seg_parts = nil
        HL7.ParserConfig[:empty_segment_is_error] = false
        segment_generator.valid_segments_parts?.should be false
      end

      it "should raise an error if empty_segment_is_error is true" do
        HL7.ParserConfig[:empty_segment_is_error] = true
        segment_generator.seg_parts = nil
        expect do
          segment_generator.valid_segments_parts?
        end.to raise_error HL7::EmptySegmentNotAllowed
      end
    end
  end
end
