# -*- encoding: utf-8 -*-
# stub: jekyll-toc 0.5.2 ruby lib

Gem::Specification.new do |s|
  s.name = "jekyll-toc"
  s.version = "0.5.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["toshimaru", "torbjoernk"]
  s.date = "2018-02-05"
  s.description = "A liquid filter plugin for Jekyll which generates a table of contents."
  s.email = "me@toshimaru.net"
  s.homepage = "https://github.com/toshimaru/jekyll-toc"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 2.1.0")
  s.rubygems_version = "2.5.2.1"
  s.summary = "Jekyll Table of Contents plugin"

  s.installed_by_version = "2.5.2.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, ["~> 1.6"])
      s.add_development_dependency(%q<appraisal>, [">= 0"])
      s.add_development_dependency(%q<codeclimate-test-reporter>, ["~> 1.0"])
      s.add_development_dependency(%q<jekyll>, [">= 3.1"])
      s.add_development_dependency(%q<minitest>, ["~> 5.0"])
      s.add_development_dependency(%q<pry>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<nokogiri>, ["~> 1.6"])
      s.add_dependency(%q<appraisal>, [">= 0"])
      s.add_dependency(%q<codeclimate-test-reporter>, ["~> 1.0"])
      s.add_dependency(%q<jekyll>, [">= 3.1"])
      s.add_dependency(%q<minitest>, ["~> 5.0"])
      s.add_dependency(%q<pry>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<nokogiri>, ["~> 1.6"])
    s.add_dependency(%q<appraisal>, [">= 0"])
    s.add_dependency(%q<codeclimate-test-reporter>, ["~> 1.0"])
    s.add_dependency(%q<jekyll>, [">= 3.1"])
    s.add_dependency(%q<minitest>, ["~> 5.0"])
    s.add_dependency(%q<pry>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
