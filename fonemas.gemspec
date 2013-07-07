# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fonemas/version'

Gem::Specification.new do |spec|
  spec.name          = "fonemas"
  spec.version       = Fonemas::VERSION
  spec.authors       = ["Manuel Bahamondez Honores"]
  spec.email         = ["manuel@bahamondez.com"]
  spec.description   = %q{Creación de fonemas para ser utilizadas en el reconocimiento de voz con cmu sphinx}
  spec.summary       = %q{Lista todas las pronunciaciones posibles para una palabra en Chileno}
  spec.homepage      = "http://www.b9.cl"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_runtime_dependency "text-hyphen", '~> 1.4.1'
  spec.add_runtime_dependency "unicode_utils", '~> 1.4.0'
  spec.add_runtime_dependency "rest-client", "~> 1.6.7"
end
