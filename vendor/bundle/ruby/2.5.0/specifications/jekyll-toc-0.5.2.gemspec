# -*- encoding: utf-8 -*-
# stub: jekyll-toc 0.5.2 ruby lib

Gem::Specification.new do |s|
  s.name = "jekyll-toc".freeze
  s.version = "0.5.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["toshimaru".freeze, "torbjoernk".freeze]
  s.date = "2018-02-05"
  s.description = "A liquid filter plugin for Jekyll which generates a table of contents.".freeze
  s.email = "me@toshimaru.net".freeze
  s.homepage = "https://github.com/toshimaru/jekyll-toc".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.1.0".freeze)
  s.rubygems_version = "2.7.7".freeze
  s.summary = "Jekyll Table of Contents plugin".freeze

  s.installed_by_version = "2.7.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>.freeze, ["~> 1.6"])
      s.add_development_dependency(%q<appraisal>.freeze, [">= 0"])
      s.add_development_dependency(%q<codeclimate-test-reporter>.freeze, ["~> 1.0"])
      s.add_development_dependency(%q<jekyll>.freeze, [">= 3.1"])
      s.add_development_dependency(%q<minitest>.freeze, ["~> 5.0"])
      s.add_development_dependency(%q<pry>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
    else
      s.add_dependency(%q<nokogiri>.freeze, ["~> 1.6"])
      s.add_dependency(%q<appraisal>.freeze, [">= 0"])
      s.add_dependency(%q<codeclimate-test-reporter>.freeze, ["~> 1.0"])
      s.add_dependency(%q<jekyll>.freeze, [">= 3.1"])
      s.add_dependency(%q<minitest>.freeze, ["~> 5.0"])
      s.add_dependency(%q<pry>.freeze, [">= 0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<nokogiri>.freeze, ["~> 1.6"])
    s.add_dependency(%q<appraisal>.freeze, [">= 0"])
    s.add_dependency(%q<codeclimate-test-reporter>.freeze, ["~> 1.0"])
    s.add_dependency(%q<jekyll>.freeze, [">= 3.1"])
    s.add_dependency(%q<minitest>.freeze, ["~> 5.0"])
    s.add_dependency(%q<pry>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
  end
end
