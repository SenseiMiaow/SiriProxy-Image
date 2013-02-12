# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "siriproxy-image"
  s.version     = "1.0"
  s.authors     = ["DJXFMA"]
  s.email       = ["djxfma@gmail.com"]
  s.homepage    = "https://github.com/DJXFMA/SiriProxy-Image"
  s.summary     = %q{Searches for given image}
  s.description = %q{Image searcher}

  s.rubyforge_project = "siriproxy-image"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "httparty"

  s.add_development_dependency "rake"

end