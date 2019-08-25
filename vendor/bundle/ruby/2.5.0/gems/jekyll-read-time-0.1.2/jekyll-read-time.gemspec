lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "jekyll-read-time/version"
Gem::Specification.new do |spec|
  spec.name          = "jekyll-read-time"
  spec.summary       = "Jekyll liquid tag to indicating the read time of the content"
  spec.description   = "Jekyll liquid tag to indicating the read time of the content"
  spec.version       = JekyllReadTime::VERSION
  spec.authors       = ["Jam Risser"]
  spec.email         = ["jam@jamrizzi.com"]
  spec.homepage      = "https://github.com/jamrizzi/jekyll-read-time"
  spec.licenses      = ["MIT"]
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r!^(test|spec|features)/!)  }
  spec.require_paths = ["lib"]
  spec.add_dependency "jekyll", "~> 3.0"
  spec.add_development_dependency "rake", "~> 11.0"
  spec.add_development_dependency "rspec", "~> 3.5"
  spec.add_development_dependency "rubocop", "~> 0.52"
end
