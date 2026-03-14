# lex-cognitive-weather

**Level 3 Leaf Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-agentic/CLAUDE.md`
- **Gem**: `lex-cognitive-weather`
- **Version**: 0.1.0
- **Namespace**: `Legion::Extensions::CognitiveWeather`

## Purpose

Models internal cognitive conditions as atmospheric weather patterns. Atmospheric fronts represent cognitive pressure systems (analytical, emotional, social domains) that interact to brew storms — episodes of confusion, foggy uncertainty, stormy conflict, or lightning-strike insight. Fronts and storms evolve over time through intensification and dissipation. The engine surfaces current conditions via a weather forecast and full atmospheric report.

## Gem Info

- **Gemspec**: `lex-cognitive-weather.gemspec`
- **Require**: `lex-cognitive-weather`
- **Ruby**: >= 3.4
- **License**: MIT
- **Homepage**: https://github.com/LegionIO/lex-cognitive-weather

## File Structure

```
lib/legion/extensions/cognitive_weather/
  version.rb
  helpers/
    constants.rb      # Front types, condition types, severity/clarity label tables
    front.rb          # Front class — one atmospheric pressure system
    storm.rb          # Storm class — one active weather episode
    weather_engine.rb # WeatherEngine — registry of fronts and storms
  runners/
    cognitive_weather.rb  # Runner module — public API (extend self)
  client.rb
```

## Key Constants

| Constant | Value | Meaning |
|---|---|---|
| `MAX_FRONTS` | 100 | Hard cap on active fronts |
| `MAX_STORMS` | 50 | Hard cap on active storms |
| `PRESSURE_CHANGE_RATE` | 0.05 | Default intensify rate per call |
| `DISSIPATION_RATE` | 0.03 | Default dissipate rate per call |

`FRONT_TYPES`: `[:warm, :cold, :occluded, :stationary]`

`CONDITION_TYPES`: `[:clear, :cloudy, :foggy, :stormy, :lightning, :blizzard]`

Severity labels (strings, not symbols): `0.9+` = `'catastrophic'`, `0.75..0.9` = `'severe'`, `0.55..0.75` = `'moderate'`, `0.35..0.55` = `'mild'`, `0.15..0.35` = `'light'`, `0.0..0.15` = `'calm'`

Clarity labels (strings, not symbols): `0.85+` = `'crystal'`, `0.65..0.85` = `'clear'`, `0.45..0.65` = `'hazy'`, `0.25..0.45` = `'murky'`, `0.0..0.25` = `'opaque'`

`Constants.label_for(table, value)` — utility method for range-based label lookup, clamps value to 0.0–1.0.

## Key Classes

### `Helpers::Front`

One atmospheric pressure system in a cognitive domain.

- `advance!(rate)` — increases pressure by `PRESSURE_CHANGE_RATE`; increases temperature and humidity by half that rate
- `retreat!(rate)` — decreases pressure, temperature, and humidity symmetrically
- `high_pressure?` — pressure >= 0.7; `low_pressure?` — pressure <= 0.3
- `severity_label` — string label based on `SEVERITY_LABELS` table applied to pressure
- Fields: `id` (UUID), `front_type`, `domain`, `pressure`, `temperature`, `humidity`, `created_at`

### `Helpers::Storm`

One active weather episode anchored to one or more fronts.

- `intensify!(rate)` — increases intensity by rate; coverage increases by half that rate
- `dissipate!(rate)` — decreases intensity and coverage symmetrically
- `lightning_strike!(domain:)` — generates a random-intensity insight event logged in `@insight_log`; returns the entry hash with `id`, `domain`, `intensity`, `struck_at`
- `raging?` — intensity >= 0.75; `clearing?` — intensity <= 0.25
- `clarity_label` — clarity is inverse of intensity: `Constants.label_for(CLARITY_LABELS, 1.0 - intensity)`
- Fields: `id` (UUID), `condition`, `front_ids`, `intensity`, `coverage`, `insight_log`

### `Helpers::WeatherEngine`

Registry of fronts and storms.

- `create_front(front_type:, domain:, pressure:, temperature:, humidity:)` — returns nil if at `MAX_FRONTS`
- `brew_storm(front_id:, condition:, intensity:, coverage:)` — returns nil if at `MAX_STORMS` or front not found; storm is anchored to the specified front
- `intensify_storm(storm_id:, rate:)` — delegates to `Storm#intensify!`; returns nil if not found
- `dissipate_all!(rate)` — dissipates every storm by one cycle; returns count of storms
- `weather_forecast` — current conditions summary: dominant condition (from highest-intensity storm), `avg_intensity`, `active_storms`, `dominant_front` (highest-pressure front), `clarity_label`, `severity_label`; returns clear/calm forecast when no storms exist
- `most_severe` — front with highest pressure; `calmest` — front with lowest pressure
- `atmospheric_report` — full report with all fronts, storms, forecast, most_severe, calmest

## Runners

Module: `Legion::Extensions::CognitiveWeather::Runners::CognitiveWeather` (`extend self`)

| Runner | Key Args | Returns |
|---|---|---|
| `create_front` | `front_type:`, `domain:`, `pressure:`, `temperature:`, `humidity:` | `{ success:, front: }` or `{ success: false, reason: :max_fronts_reached }` |
| `brew_storm` | `front_id:`, `condition:`, `intensity:`, `coverage:` | `{ success:, storm: }` or `{ success: false, reason: :brew_failed }` |
| `intensify` | `storm_id:`, `rate:` | `{ success:, storm: }` or `{ success: false, reason: :storm_not_found }` |
| `forecast` | — | forecast hash merged with `success: true` |
| `list_fronts` | — | `{ success:, fronts:, count: }` |
| `weather_status` | — | full atmospheric report merged with `success: true` |

All runners accept optional `engine:` keyword for test injection.

## Integration Points

- No actors defined; `dissipate_all` should be called periodically as a decay tick
- `forecast` surfaces current cognitive conditions to other extensions; foggy/stormy conditions could gate decision-making runners
- `lightning_strike!` on a storm is called directly on the Storm object (not exposed as a runner); insight events are stored in the storm's `insight_log`
- All state is in-memory per `WeatherEngine` instance

## Development Notes

- Severity and clarity labels are **strings**, not symbols — unlike most other cognitive extensions that use symbol labels
- `brew_storm` requires a valid front_id to exist; brewed storms carry `front_ids: [front_id]` but the front is only checked for existence, not mutated
- `weather_forecast` derives `dominant_front` from `most_severe` (highest pressure), not necessarily the front anchoring the highest-intensity storm
- Storms are never auto-removed; dissipation only reduces intensity/coverage — callers must prune zero-intensity storms manually if desired
- `ArgumentError` in `Storm.new` if condition type is not in `CONDITION_TYPES`; same for `Front.new` if front type is not in `FRONT_TYPES`
