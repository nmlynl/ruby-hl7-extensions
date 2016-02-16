require 'core_ext/segments/msh'
require 'core_ext/segments/pid'
require 'core_ext/segments/orc'
require 'core_ext/segments/obr'
require 'core_ext/segments/obx'
require 'core_ext/segments/nte'
require 'core_ext/segments/nk1'
require 'core_ext/segments/pv1'
require 'core_ext/segments/evn'

segments = ["MSH","PID","ORC","OBR","OBX","NTE","NK1", "PV1", "EVN"]
segments.each do |segment_name|

  eval("class HL7::Message::Segment::#{segment_name} < HL7::Message::Segment
    include Extensions::HL7::Segments::#{segment_name}
  end")

end

require 'core_ext/segments/rol'