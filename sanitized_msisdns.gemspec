lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'msisdn-sanitizer/version'

Gem::Specification.new do |s|
  s.name        = 'sanitized_msisdns'
  s.version     = MSISDN.version
  s.author      = 'Sunil Kumar'
  s.email       = 'sunilkumar.gec56@gmail.com'
  s.homepage    = 'http://tech.sunilnkumar.com/'
  s.summary     = %q{Sanitizes msisdns}
  s.description = %q{ Sanitizes the msisdns. Especially helpful for proper formatting of android mobile numbers. }

  s.add_dependency 'mobme_support'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'yard'
  s.add_development_dependency 'simplecov-rcov'
  s.add_development_dependency 'rdiscount'

  s.files              = `git ls-files`.split("\n") - %w(Gemfile.lock .ruby-version)
  s.test_files         = `git ls-files -- {spec}/*`.split("\n")
  s.require_paths      = %w(lib)
end
