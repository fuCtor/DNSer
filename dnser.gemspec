# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "dnser/version"

Gem::Specification.new do |s|
  s.name        = 'dnser'
  s.version     = DNSer::VERSION
  s.platform    = Gem::Platform::RUBY
  s.date        = '2013-08-03'
  s.summary     = "DNS zone file in ruby"
  s.description = "Clean ruby syntax for writing DNS zone file."
  s.authors     = ["Alexey Shcherbakov"]
  s.email       = 'schalexey@gmail.com'
  s.files       = `git ls-files`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.homepage    = 'https://github.com/fuCtor/DNSer'
  s.license     = 'MIT'

  s.require_paths = ["lib"]
end