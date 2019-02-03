# -*- encoding: utf-8 -*-
# stub: jekyll-srcset 0.1.3 ruby lib

Gem::Specification.new do |s|
  s.name = "jekyll-srcset"
  s.version = "0.1.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Mathias Biilmann Christensen"]
  s.date = "2016-01-12"
  s.description = "\n  This Jekyll plugin makes it very easy to send larger images to devices with high pixel densities.\n\n  The plugin adds an `image_tag` Liquid tag that can be used like this:\n\n  {% image_tag src=\"/image.png\" width=\"100\" %}\n"
  s.email = ["info@mathias-biilmann.net"]
  s.homepage = "https://github.com/netlify/jekyll-srcset"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.2.1"
  s.summary = "This Jekyll plugin ads an image_tag that will generate responsive img tags"

  s.installed_by_version = "2.5.2.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rmagick>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.7"])
      s.add_development_dependency(%q<rake>, ["~> 10.0"])
      s.add_runtime_dependency(%q<jekyll>, ["> 2"])
    else
      s.add_dependency(%q<rmagick>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.7"])
      s.add_dependency(%q<rake>, ["~> 10.0"])
      s.add_dependency(%q<jekyll>, ["> 2"])
    end
  else
    s.add_dependency(%q<rmagick>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.7"])
    s.add_dependency(%q<rake>, ["~> 10.0"])
    s.add_dependency(%q<jekyll>, ["> 2"])
  end
end
