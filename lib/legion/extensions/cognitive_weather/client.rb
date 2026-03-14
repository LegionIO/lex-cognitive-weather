# frozen_string_literal: true

require 'legion/extensions/cognitive_weather/helpers/constants'
require 'legion/extensions/cognitive_weather/helpers/front'
require 'legion/extensions/cognitive_weather/helpers/storm'
require 'legion/extensions/cognitive_weather/helpers/weather_engine'
require 'legion/extensions/cognitive_weather/runners/cognitive_weather'

module Legion
  module Extensions
    module CognitiveWeather
      class Client
        include Runners::CognitiveWeather

        def initialize(**)
          @weather_engine = Helpers::WeatherEngine.new
        end

        private

        attr_reader :weather_engine
      end
    end
  end
end
