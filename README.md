# REVillage-Coop

A multiplayer/co-op framework and developer toolkit for **Resident Evil Village** using **REFramework**.

> Status: early development. The current stable toolkit baseline is v0.3.5a; the v0.3.6 Reflection Probe is ready for in-game compatibility testing.

## Current features

- REFramework Lua runtime UI
- Native plugin, pose stream, and remote puppet detection
- Player transform sampling
- Runtime status, uptime, FPS, and frame counters
- Component scanner
- Developer Console with runtime, native, reflection, and error panels
- Read-only player reflection probe with field/method compatibility reporting

## Reflection Probe (v0.3.6)

Copy `reframework/autorun/` into the matching REFramework directory, open **Script Generated UI**, and click **Run player reflection probe**. The probe invokes only the listed player getters, then reads type metadata; it does not read field values or invoke any enumerated methods.

Assumption: the active player is exposed by `app.PlayerManager` through `get_CurrentPlayer`, `get_Player`, or `get_ManualPlayer`. Failed paths are reported safely so Resident Evil Village builds can be compared without taking down the existing component scanner.

## Development roadmap

- **v0.3.5a** — Developer Console ✅
- **v0.3.6** — Reflection Probe (implementation ready; in-game verification pending)
- **v0.3.7** — Field Explorer
- **v0.3.8** — Method Explorer
- **v0.4.0** — Integrated Developer Toolkit
- Later — networking, player state synchronization, animation synchronization, and co-op gameplay systems

## Repository layout

```text
REVillage-Coop/
├── docs/             Project documentation
├── reframework/      REFramework Lua scripts and plugin files
├── builds/           Stable packaged builds
├── tools/            Development and diagnostic utilities
├── CHANGELOG.md      Version history
└── README.md
```

## Development rules

1. Add one feature per build.
2. Test after every change.
3. Keep `main` stable.
4. Develop new work on `develop` or `feature/*` branches.
5. Record successful builds in the changelog.

## Disclaimer

This is an unofficial fan-made project and is not affiliated with or endorsed by Capcom. Resident Evil and related properties belong to their respective owners.
