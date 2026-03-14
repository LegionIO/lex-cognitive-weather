# lex-cognitive-weather

Internal cognitive weather systems for the LegionIO cognitive architecture. Models storms of confusion, clear skies of clarity, fog of uncertainty, lightning strikes of insight, and wind shifts of changing priorities. Weather patterns affect cognitive performance and processing capacity.

## Installation

```ruby
gem 'lex-cognitive-weather'
```

## Usage

```ruby
client = Legion::Extensions::CognitiveWeather::Client.new

# Create an atmospheric front
result = client.create_front(front_type: :cold, domain: 'reasoning', pressure: 0.6)

# Brew a storm from the front
storm = client.brew_storm(front_id: result[:front][:id], condition: :foggy, intensity: 0.5)

# Intensify the storm
client.intensify(storm_id: storm[:storm][:id])

# Get current forecast
client.forecast

# Full atmospheric report
client.weather_status
```

## License

MIT
