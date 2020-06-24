# -*- encoding: utf-8 -*-
# stub: jekyll-srcset 0.1.3 ruby lib

Gem::Specification.new do |s|
  s.name = "jekyll-srcset".freeze
  s.version = "0.1.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Mathias Biilmann Christensen".freeze]
  s.date = "2016-01-12"
  s.description = "\n  This Jekyll plugin makes it very easy to send larger images to devices with high pixel densities.\n\n  The plugin adds an `image_tag` Liquid tag that can be used like this:\n\n  {% image_tag src=\"/image.png\" width=\"100\" %}\n".freeze
  s.email = ["info@mathias-biilmann.net".freeze]
  s.homepage = "https://github.com/netlify/jekyll-srcset".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.6".freeze
  s.summary = "This Jekyll plugin ads an image_tag that will generate responsive img tags".freeze

  s.installed_by_version = "2.7.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rmagick>.freeze, [">= 0"])
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.7"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_runtime_dependency(%q<jekyll>.freeze, ["> 2"])
    else
      s.add_dependency(%q<rmagick>.freeze, [">= 0"])
      s.add_dependency(%q<bundler>.freeze, ["~> 1.7"])
      s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_dependency(%q<jekyll>.freeze, ["> 2"])
    end
  else
    s.add_dependency(%q<rmagick>.freeze, [">= 0"])
    s.add_dependency(%q<bundler>.freeze, ["~> 1.7"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
    s.add_dependency(%q<jekyll>.freeze, ["> 2"])
  end
end
