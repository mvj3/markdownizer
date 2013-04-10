# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "markdownizer/version"

Gem::Specification.new do |s|
  s.name        = "markdownizer"
  s.version     = Markdownizer::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Josep M. Bach", "Josep Jaume Rey", "Oriol Gual"]
  s.email       = ["info@codegram.com"]
  s.homepage    = "http://github.com/codegram/markdownizer"
  s.summary     = %q{Render any text as markdown, with code highlighting and all!}
  s.description = %q{Render any text as markdown, with code highlighting and all!}

  s.rubyforge_project = "markdownizer"

  s.add_runtime_dependency 'activerecord', '>= 3.0.3'
  s.add_runtime_dependency 'activesupport'
  s.add_runtime_dependency 'rdiscount'

  s.add_development_dependency 'rocco'
  s.add_development_dependency 'git'
  s.add_development_dependency 'pygments.rb'
  s.add_development_dependency 'coderay'
  s.add_development_dependency 'json'
  s.add_development_dependency 'rspec', '~> 2.5.0'
  s.add_development_dependency 'pry-debugger'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
