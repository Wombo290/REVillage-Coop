# Changelog

All notable project changes will be documented here.

## [Unreleased]

### Added
- v0.3.6 read-only Reflection Probe with safe player resolution and field/method metadata reporting

### Confirmed
- REFramework v1.5.9.7 resolves the RE8 player as `via.GameObject` through `app.PropsManager:get_Player`
- Field enumeration safely returns an empty list and method enumeration returns 37 entries on the live player object

### Planned
- v0.3.7 Field Explorer
- v0.3.8 Method Explorer
- v0.4.0 Integrated Developer Toolkit

## [0.3.5a] - 2026-07-30

### Added
- Developer Console
- Runtime status panel
- Native status panel
- Reflection status panel
- Error display panel

### Confirmed stable
- F8 UI
- Native plugin detection
- Pose stream detection
- Remote puppet detection
- Player transform sampling
- Uptime and FPS counters
- Dynamic title
- Component scanner
