# Project Roadmap

## Stable baseline — v0.3.5a

- Developer Console
- Player component scanner
- Runtime and native status reporting
- Error visibility

## v0.3.6 — Reflection Probe

Goal: determine which REFramework reflection APIs are reliable in Resident Evil Village.

Planned work:

- Safely obtain the player managed object and type definition
- Probe field enumeration paths
- Probe method enumeration paths
- Record compatibility results without crashing the game
- Preserve the v0.3.5a component scanner as fallback

## v0.3.7 — Field Explorer

- Enumerate fields
- Display names and types
- Safely read selected live values
- Add filtering and watch support

## v0.3.8 — Method Explorer

- Enumerate methods
- Display signatures
- Add safe invocation experiments for zero-argument diagnostic methods

## v0.4.0 — Developer Toolkit

- Object Explorer
- Live Values
- Method Browser
- Watch Window
- Recorder

## Later co-op milestones

- Network transport stabilization
- Remote player lifecycle
- Transform synchronization
- Animation synchronization
- Combat and interaction synchronization
- Save/progression rules
