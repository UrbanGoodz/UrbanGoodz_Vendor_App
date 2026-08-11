# Urban Goodz Digital Human — Rive Assets (Vendor App)

This directory is the landing point for the real Rive character files produced
by the Rive asset lane. It intentionally ships **empty of `.riv` binaries** — no
placeholder or fabricated Rive files are committed here. The Flutter integration
(`RiveAssetManager`) detects when a file is absent and renders the persona
fallback (styled avatar card) instead, so the app stays green before the assets
arrive.

## Expected files (drop-in contract)

| File               | Persona  | Role                          |
| ------------------ | -------- | ----------------------------- |
| `monique.riv`      | Monique  | Urban Goodz AI Concierge      |
| `skylar.riv`       | Skylar   | Urban Goodz Chief of Staff    |

## State machine input contract

Each `.riv` must expose a state machine (any name; the integration uses the
default / first state machine) with the following inputs:

| Input           | Type    | Meaning                                   |
| --------------- | ------- | ----------------------------------------- |
| `isSpeaking`    | boolean | Speaking state active                     |
| `isListening`   | boolean | Listening state active                    |
| `isThinking`    | boolean | Thinking / analyzing state active         |
| `emotion`       | number  | 0 neutral · 1 sassy · 2 excited · 3 explaining · 4 executive · 5 analysis · 6 alert · 7 concerned · 8 happy |
| `gesture`       | number  | 0 idle · 1 nod · 2 wave · 3 thinking_pose · 4 pointer · 5 hand_gesture · 6 subtle_smile · 7 alert_gesture |
| `confidence`    | number  | 0.0 - 1.0 response confidence             |
| `viseme_id`     | number  | Current lip-sync viseme index (0 = sil, 1 = A, 2 = E, 3 = O, 4 = U, 5 = MBP, 6 = FV, 7 = LNDT) |

## State list

`Idle`, `Listening`, `Thinking`, `Speaking`, `Happy`, `Concerned` (core) plus
persona-specific states — Monique: `Sassy`, `Excited`, `Explaining`; Skylar:
`Executive`, `Analysis`, `Alert`.

## Delivery checklist

- [ ] Real `.riv` files exported from the Rive editor by the asset lane.
- [ ] Artboards named `Monique` and `Skylar` (or a single default artboard).
- [ ] State machine inputs match the table above so `DigitalHumanController`
      can drive them without code changes.
- [ ] Files verified by hex/header inspection and loaded once in the app.
