# $Id$
require 'rubygems'
require 'rake'
require 'rdoc/task'
require 'rubygems/package_task'
require 'rake/contrib/sshpublisher'
require 'rbconfig'
require 'rubyforge'
require 'rspec'
require 'rspec/core/rake_task'
require 'simplecov'

$: << './lib'
require 'ruby-hl7-extensions'

full_name = "Ruby-HL7-Extensions"
short_name = full_name.downcase

# Many of these tasks were garnered from zenspider's Hoe
# just forced to work my way

desc 'Default: Run all examples'
task :default => :spec

spec = Gem::Specification.new do |s|
  s.name = short_name
  s.full_name
  s.version = "0.0.1"
  s.author = "Nick Lega"
  s.email = "ruby-hl7@googlegroups.com"
  s.homepage = "https://github.com/nmlynl/ruby-hl7-extensions"
  s.platform = Gem::Platform::RUBY
  s.summary = "Ruby HL7 Library w/Extensions"
  s.rubyforge_project = short_name
  s.description = "A simple library to parse and generate HL7 2.x messages and spit out json"
  s.files = FileList["{bin,lib,test_data}/**/*"].to_a
  s.require_path = "lib"
  s.test_files = FileList["{test}/**/test*.rb"].to_a
  s.has_rdoc = true
  s.required_ruby_version = '>= 1.8.6'
  s.extra_rdoc_files = %w[README.rdoc LICENSE]
  s.add_dependency("rake", ">= #{RAKEVERSION}")
  s.add_dependency("rubyforge", ">= #{::RubyForge::VERSION}")
end

desc "Run all examples"
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/**/*.rb'
end

desc "Run all examples with SimpleCov"
RSpec::Core::RakeTask.new(:spec_with_simplecov) do |spec|
  ENV['COVERAGE'] = 'true'
  spec.pattern = 'spec/**/*.rb'
end

RDoc::Task.new do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc", "LICENSE", "lib/**/*.rb")
  rd.title = "%s (%s) Documentation" % [ full_name, spec.version ]
  rd.rdoc_dir = 'doc'
end

Gem::PackageTask.new(spec) do |pkg|
  pkg.need_tar = true
end

desc 'Clean up all the extras'
task :clean => [ :clobber_rdoc, :clobber_package ] do
  %w[*.gem ri coverage*].each do |pattern|
    files = Dir[pattern]
    rm_rf files unless files.empty?
  end
end

desc 'Install the package as a gem'
task :install_gem => [:clean, :package] do
  sh "sudo gem install pkg/*.gem"
end
