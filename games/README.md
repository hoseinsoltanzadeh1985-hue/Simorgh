# Simorgh Web Games

The `games/` directory is a self-contained static Mini App site for the Simorgh Game Center.

## Design derived from the supplied UI references

### Retro Flight

The supplied reference uses a vertical arcade layout with a score HUD, high score, fuel meter, lives, river scenery and a large Play action. The Simorgh implementation keeps the useful presentation ideas — compact HUD, high score, fuel management, vertical scrolling scenery, touch controls and Telegram Mini App framing — but implements a non-combat flight loop: collect stars/fuel and avoid natural obstacles.

### Backgammon

The supplied reference shows a polished two-player mobile board with player status, dice, turn flow, settings and chat-style controls. The launcher keeps the same mobile-first visual hierarchy and opens the GPL-3.0 upstream game for the full ruleset and online two-player mode. The upstream project documents valid moves, hitting, bar entry, bearing off, sound, responsive layout and WebRTC online play.

### Voice Wheel

The wheel is a non-monetary current-voice-call selection utility. It is designed around the requested behavior:

- The source roster is the people present at execution time; no attendance weighting or old-history weighting is used.
- The administrator chooses how many people to select (bounded by the supplied roster size in the UI).
- Each participant is rendered as their display name plus `(@username)` when a username exists; otherwise only the display name is shown.
- Every spin selects exactly one remaining participant at random.
- The selected participant is shown prominently as the winner, recorded in the winners panel, and removed from the wheel before the next spin.
- Spinning continues until the requested number of winners is reached or the current roster is exhausted.
- The page accepts a base64url JSON roster in the URL fragment (`#data=...`) and an optional `?count=N`, so participant data is not sent as an HTTP request to the static host.
- When opened without roster data, a small demo roster is used strictly for UI testing.

For the production Telegram integration, the trusted worker/backend must obtain the current voice roster and generate the `count` + fragment payload. The static page is not an authorization boundary and must not be used to infer Telegram membership or permissions by itself.

## Architecture

- `index.html` — Game Center entry point.
- `retro-flight.html` — single-file Canvas game with local high score and Telegram WebApp initialization.
- `backgammon.html` — branded Mini App launcher/preview for the upstream full-rules game.
- `voice-wheel.html` — multi-winner voice-call wheel UI with sequential elimination.
- `tests/smoke.mjs` — dependency-free static regression checks.
- `.github/workflows/games-pages.yml` — smoke test + GitHub Pages deployment.

The game pages contain no bot tokens, Supabase secrets or server credentials. Basic gameplay does not require Supabase.

## Hosting

GitHub Pages publishes the `games/` directory as a static HTTPS site. Telegram Mini Apps require an HTTPS `WebAppInfo.url` in production.

Expected Pages base URL:

`https://hoseinsoltanzadeh1985-hue.github.io/Simorgh/games/`

Before changing the Guardian bot's default game URL, verify the Pages deployment and run the Telegram smoke test. Keep polling/webhook configuration unchanged during this game-only release.
