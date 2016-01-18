# -*- encoding: utf-8 -*-
# stub: ruby-hl7 1.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "ruby-hl7-extensions"
  s.version = "1.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Nick Lega"]
  s.date = "2014-09-09"
  s.description = "A simple library to parse and generate HL7 2.x json"
  s.email = "ruby-hl7-json@googlegroups.com"
  s.extra_rdoc_files = ["LICENSE", "README.rdoc"]
  s.files = [".gitignore", "Gemfile", "Gemfile.lock", "LICENSE", "NOTES.md", "README.rdoc", "Rakefile", "VERSION", "VERSION.yml",  "lib/ruby-hl7-extensions.rb", "lib/core_ext/message.rb", "lib/core_ext/segment.rb", "lib/test/hl7_messages.rb", "ruby-hl7-json.gemspec", "spec/basic_parsing_spec.rb", "spec/batch_parsing_spec.rb", "spec/child_segment_spec.rb", "spec/core_ext/date_time_spec.rb", "spec/default_segment_spec.rb", "spec/dynamic_segment_def_spec.rb", "spec/err_segment_spec.rb", "spec/evn_segment_spec.rb", "spec/msa_segment_spec.rb", "spec/msh_segment_spec.rb", "spec/nk1_segment_spec.rb", "spec/obr_segment_spec.rb", "spec/obx_segment_spec.rb", "spec/orc_segment_spec.rb", "spec/pid_segment_spec.rb", "spec/prd_segment_spec.rb", "spec/pv1_segment_spec.rb", "spec/rf1_segment_spec.rb", "spec/segment_field_spec.rb", "spec/segment_generator_spec.rb", "spec/segment_list_storage_spec.rb", "spec/segment_spec.rb", "spec/sft_segment_spec.rb", "spec/spec_helper.rb", "spec/speed_parsing_spec.rb", "spec/spm_segment_spec.rb", "test_data/adt_a01.hl7", "test_data/cerner/cerner_bordetella.hl7", "test_data/cerner/cerner_en.hl7", "test_data/cerner/cerner_lead.hl7", "test_data/cerner/cerner_sequential.hl7", "test_data/empty-batch.hl7", "test_data/empty.hl7", "test_data/empty_segments.hl7", "test_data/lotsunknowns.hl7", "test_data/nist/ORU_R01_2.5.1_SampleTestCase1.er7", "test_data/nist/ORU_R01_2.5.1_SampleTestCase2.er7", "test_data/nist/ORU_R01_2.5.1_SampleTestCase3.er7", "test_data/nist/ORU_R01_2.5.1_SampleTestCase4.er7", "test_data/nist/ORU_R01_2.5.1_SampleTestCase5.er7", "test_data/nist/ORU_R01_2.5.1_SampleTestCase6.er7", "test_data/obxobr.hl7", "test_data/realm/realm-animal-rabies.hl7", "test_data/realm/realm-bad-batch.hl7", "test_data/realm/realm-batch.hl7", "test_data/realm/realm-campylobacter-jejuni.hl7", "test_data/realm/realm-cj-badloinc.hl7", "test_data/realm/realm-cj-joeslab.hl7", "test_data/realm/realm-cj.hl7", "test_data/realm/realm-err.hl7", "test_data/realm/realm-hepatitis-c-virus.hl7", "test_data/realm/realm-lead-laboratory-result.hl7", "test_data/realm/realm-minimal-message.hl7", "test_data/rqi_r04.hl7", "test_data/test.hl7", "test_data/test2.hl7"]
  s.homepage = "http://github.com/nmlynl/ruby-hl7-extensions"
  s.rdoc_options = ["--charset=UTF-8"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.6")
  s.rubyforge_project = "ruby-hl7-extensions"
  s.rubygems_version = "2.4.5"
  s.summary = "Ruby HL7 Library w/Extensions"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rake>, [">= 10.0.0"])
      s.add_runtime_dependency(%q<rubyforge>, [">= 2.0.4"])
    else
      s.add_dependency(%q<rake>, [">= 10.0.0"])
      s.add_dependency(%q<rubyforge>, [">= 2.0.4"])
    end
  else
    s.add_dependency(%q<rake>, [">= 10.0.0"])
    s.add_dependency(%q<rubyforge>, [">= 2.0.4"])
  end
end
