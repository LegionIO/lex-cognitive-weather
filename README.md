# lex-cognitive-weather

A LegionIO cognitive architecture extension that models internal cognitive conditions as atmospheric weather patterns. Fronts represent cognitive pressure systems across domains, and storms model active episodes of confusion, conflict, or sudden insight.

## What It Does

Tracks **fronts** (atmospheric pressure systems) and **storms** (active weather episodes) in cognitive domains.

Each front has:
- A type (`:warm`, `:cold`, `:occluded`, `:stationary`)
- Pressure, temperature, and humidity values
- A severity label based on pressure

Each storm has:
- A condition type (`:clear`, `:cloudy`, `:foggy`, `:stormy`, `:lightning`, `:blizzard`)
- Intensity and coverage values
- An insight log populated by `lightning_strike!` events
- A clarity label inverse to intensity

Fronts can be intensified or retreated. Storms can be intensified or dissipated. The engine surfaces current conditions via a weather forecast and a full atmospheric report.

## Usage

```ruby
require 'lex-cognitive-weather'

client = Legion::Extensions::CognitiveWeather::Client.new

# Create an atmospheric front
result = client.create_front(
  front_type: :cold,
  domain: 'reasoning',
  pressure: 0.6,
  temperature: 0.4,
  humidity: 0.5
)
# => { success: true, front: { id: "uuid...", front_type: :cold, pressure: 0.6, severity_label: "moderate", ... } }

front_id = result[:front][:id]

# Brew a storm from the front
storm = client.brew_storm(
  front_id: front_id,
  condition: :foggy,
  intensity: 0.5,
  coverage: 0.4
)
# => { success: true, storm: { id: "uuid...", condition: :foggy, intensity: 0.5, clarity: "hazy", raging: false, ... } }

# Intensify the storm
client.intensify(storm_id: storm[:storm][:id])
# => { success: true, storm: { intensity: 0.55, ... } }

# Get current forecast
client.forecast
# => { success: true, condition: :foggy, avg_intensity: 0.55, active_storms: 1, clarity_label: "hazy", ... }

# List all fronts
client.list_fronts
# => { success: true, fronts: [...], count: 1 }

# Full atmospheric report
client.weather_status
# => { success: true, front_count: 1, storm_count: 1, fronts: [...], storms: [...], forecast: {...}, ... }
```

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

MIT
