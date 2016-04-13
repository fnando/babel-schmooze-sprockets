require "./lib/babel-schmooze-sprockets/version"

Gem::Specification.new do |spec|
  spec.name          = "babel-schmooze-sprockets"
  spec.version       = BabelSchmoozeSprockets::VERSION
  spec.authors       = ["Nando Vieira"]
  spec.email         = ["fnando.vieira@gmail.com"]

  spec.summary       = "Add Babel support to sprockets using Schmooze."
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/fnando/babel-schmooze-sprockets"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject {|f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) {|f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "schmooze"
  spec.add_dependency "sprockets", "~> 4.x"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest-utils"
  spec.add_development_dependency "pry-meta"
end
