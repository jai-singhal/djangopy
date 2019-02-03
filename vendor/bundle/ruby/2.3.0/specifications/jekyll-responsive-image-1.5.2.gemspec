# -*- encoding: utf-8 -*-
# stub: jekyll-responsive-image 1.5.2 ruby lib

Gem::Specification.new do |s|
  s.name = "jekyll-responsive-image"
  s.version = "1.5.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Joseph Wynn"]
  s.date = "2018-07-01"
  s.description = "\n    Highly configurable Jekyll plugin for managing responsive images. Automatically\n    resizes images and provides a Liquid template tag for loading the images with\n    picture, img srcset, Imager.js, etc.\n  "
  s.email = ["joseph@wildlyinaccurate.com"]
  s.homepage = "https://github.com/wildlyinaccurate/jekyll-responsive-image"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.2.1"
  s.summary = "Responsive image management for Jekyll"

  s.installed_by_version = "2.5.2.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<jekyll>, ["< 4.0", ">= 2.0"])
      s.add_runtime_dependency(%q<rmagick>, ["< 3.0", ">= 2.0"])
    else
      s.add_dependency(%q<jekyll>, ["< 4.0", ">= 2.0"])
      s.add_dependency(%q<rmagick>, ["< 3.0", ">= 2.0"])
    end
  else
    s.add_dependency(%q<jekyll>, ["< 4.0", ">= 2.0"])
    s.add_dependency(%q<rmagick>, ["< 3.0", ">= 2.0"])
  end
end
