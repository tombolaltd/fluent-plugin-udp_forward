# encoding: utf-8
Gem::Specification.new do |gem|
  gem.name = "fluent-plugin-udp_forward"
  gem.description = "This input plugin allows you to collect incoming events over UDP"
  gem.homepage = "https://github.com/tombolaltd/fluent-plugin-udp_forward"
  gem.summary = gem.description
  gem.version = "1.0.1"
  gem.license = 'MIT'
  gem.authors = ["Sohaib Maroof"]
  gem.email = "sohaib.maroof@tombola.com"
  gem.has_rdoc = false
  gem.files = `git ls-files`.split("\n")
  gem.require_paths = ['lib']
  gem.add_runtime_dependency "fluentd", [">= 0.14.0", "< 2"]
end


