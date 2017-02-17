# -*- encoding: utf-8 -*-
# stub: ruby-hl7-extensions 1.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "ruby-hl7-extensions"
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Nick Lega"]
  s.date = "2016-11-11"
  s.description = "A simple library to parse and generate HL7 2.x json"
  s.email = "ruby-hl7-json@googlegroups.com"
  s.extra_rdoc_files = ["LICENSE", "README.md"]
  s.files = [".gitignore", "Gemfile", "Gemfile.lock", "LICENSE", "README.md", "Rakefile", "VERSION", "VERSION.yml", "lib/core_ext/segments/rol.rb",
             "lib/core_ext/message.rb", "lib/core_ext/segment.rb", "lib/core_ext/segments/err.rb", "lib/core_ext/segments/sft.rb",
             "lib/core_ext/segments/msh.rb", "lib/core_ext/segments/nk1.rb", "lib/core_ext/segments/orc.rb", "lib/core_ext/segments/evn.rb", "lib/core_ext/segments/nte.rb", "lib/core_ext/segments/obr.rb",      "lib/core_ext/segments/obx.rb", "lib/core_ext/segments/pid.rb", "lib/core_ext/segments/pv1.rb", "lib/core_ext/segments/pd1.rb", "lib/core_ext/segments/segments.rb", "lib/core_ext/segments/dg1.rb", "lib/core_ext/segments/in1.rb", "lib/segments/dg1.rb", "lib/ruby-hl7-extensions.rb", "ruby-hl7-extensions.gemspec"]
  s.homepage = "http://github.com/nmlynl/ruby-hl7-extensions"
  s.rdoc_options = ["--charset=UTF-8"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.6")
  s.rubyforge_project = "ruby-hl7-extensions"
  s.rubygems_version = "2.4.5"
  s.summary = "Ruby HL7 Library w/Extensions"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rake>, ["~> 10.0.0"])
      s.add_runtime_dependency(%q<rubyforge>, ["~> 2.0.4"])
    else
      s.add_dependency(%q<rake>, ["~> 10.0.0"])
      s.add_dependency(%q<rubyforge>, ["~> 2.0.4"])
    end
  else
    s.add_dependency(%q<rake>, ["~> 10.0.0"])
    s.add_dependency(%q<rubyforge>, ["~> 2.0.4"])
  end
end
