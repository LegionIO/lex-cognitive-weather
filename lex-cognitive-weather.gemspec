# frozen_string_literal: true

require_relative 'lib/legion/extensions/cognitive_weather/version'

Gem::Specification.new do |spec|
  spec.name          = 'lex-cognitive-weather'
  spec.version       = Legion::Extensions::CognitiveWeather::VERSION
  spec.authors       = ['Esity']
  spec.email         = ['matthewdiverson@gmail.com']

  spec.summary       = 'LEX CognitiveWeather'
  spec.description   = 'Internal cognitive weather systems for brain-modeled agentic AI — ' \
                       'atmospheric fronts, storms of confusion, fog of uncertainty, and lightning strikes of insight'
  spec.homepage      = 'https://github.com/LegionIO/lex-cognitive-weather'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.4'

  spec.metadata['homepage_uri']      = spec.homepage
  spec.metadata['source_code_uri']   = 'https://github.com/LegionIO/lex-cognitive-weather'
  spec.metadata['documentation_uri'] = 'https://github.com/LegionIO/lex-cognitive-weather'
  spec.metadata['changelog_uri']     = 'https://github.com/LegionIO/lex-cognitive-weather'
  spec.metadata['bug_tracker_uri']   = 'https://github.com/LegionIO/lex-cognitive-weather/issues'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir.glob('{lib,spec}/**/*') + %w[lex-cognitive-weather.gemspec Gemfile LICENSE README.md]
  end
  spec.require_paths = ['lib']
end
