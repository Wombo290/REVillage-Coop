# REVillage-Coop

A multiplayer/co-op framework and developer toolkit for **Resident Evil Village** using **REFramework**.

> Status: early development. The current stable toolkit baseline is v0.3.5a.

## Current features

- REFramework Lua runtime UI
- Native plugin, pose stream, and remote puppet detection
- Player transform sampling
- Runtime status, uptime, FPS, and frame counters
- Component scanner
- Developer Console with runtime, native, reflection, and error panels

## Development roadmap

- **v0.3.5a** — Developer Console ✅
- **v0.3.6** — Reflection Probe
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
