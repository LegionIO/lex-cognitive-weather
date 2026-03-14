# frozen_string_literal: true

require 'securerandom'
require 'legion/extensions/cognitive_weather/version'
require 'legion/extensions/cognitive_weather/helpers/constants'
require 'legion/extensions/cognitive_weather/helpers/front'
require 'legion/extensions/cognitive_weather/helpers/storm'
require 'legion/extensions/cognitive_weather/helpers/weather_engine'
require 'legion/extensions/cognitive_weather/runners/cognitive_weather'
require 'legion/extensions/cognitive_weather/client'

module Legion
  module Extensions
    module CognitiveWeather
      extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core
    end
  end
end
