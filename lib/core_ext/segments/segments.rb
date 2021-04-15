require 'core_ext/segments/msh'
require 'core_ext/segments/pid'
require 'core_ext/segments/orc'
require 'core_ext/segments/obr'
require 'core_ext/segments/obx'
require 'core_ext/segments/nte'
require 'core_ext/segments/nk1'
require 'core_ext/segments/pv1'
require 'core_ext/segments/pv2'
require 'core_ext/segments/evn'
require 'core_ext/segments/sft'
require 'core_ext/segments/err'
require 'core_ext/segments/rol'
require 'core_ext/segments/pd1'
require 'segments/dg1'
require 'segments/mrg'
require 'segments/zdrf'
require 'segments/znp'
require 'core_ext/segments/dg1'
require 'core_ext/segments/in1'
require 'core_ext/segments/mrg'


segments = ["MSH","PID","ORC","OBR","OBX","NTE","NK1", "PV1", "PV2", "EVN", "SFT", "ERR", "PD1", "ROL", "DG1", "IN1", "MRG"]
segments.each do |segment_name|

  eval("class HL7::Message::Segment::#{segment_name} < HL7::Message::Segment
    include Extensions::HL7::Segments::#{segment_name}
  end")

end
