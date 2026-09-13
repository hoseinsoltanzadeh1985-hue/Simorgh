# Simorgh Web Games

The `games/` directory is a self-contained static Mini App site for the Simorgh Game Center.

## Design derived from the supplied UI references

### Retro Flight

The supplied reference uses a vertical arcade layout with a score HUD, high score, fuel meter, lives, river scenery and a large Play action. The Simorgh implementation keeps the useful presentation ideas — compact HUD, high score, fuel management, vertical scrolling scenery, touch controls and Telegram Mini App framing — but implements a non-combat flight loop: collect stars/fuel and avoid natural obstacles.

### Backgammon

The supplied reference shows a polished two-player mobile board with player status, dice, turn flow, settings and chat-style controls. The launcher keeps the same mobile-first visual hierarchy and opens the GPL-3.0 upstream game for the full ruleset and online two-player mode. The upstream project documents valid moves, hitting, bar entry, bearing off, sound, responsive layout and WebRTC online play.

Upstream: `https://github.com/99fk/backgammon-html`
Online game: `https://99fk.github.io/backgammon-html/bg-online.html`

This repository does not claim the upstream code as its own and does not remove its license/copyright notice.

## Architecture

- `index.html` — Game Center entry point.
- `retro-flight.html` — single-file Canvas game with local high score and Telegram WebApp initialization.
- `backgammon.html` — branded Mini App launcher/preview for the upstream full-rules game.
- `tests/smoke.mjs` — dependency-free static regression checks.
- `.github/workflows/games-pages.yml` — smoke test + GitHub Pages deployment.

The game pages contain no bot tokens, Supabase secrets or server credentials. Basic gameplay does not require Supabase.

## Hosting

GitHub Pages publishes the `games/` directory as a static HTTPS site. Telegram Mini Apps require an HTTPS `WebAppInfo.url` in production.

Expected Pages base URL:

`https://hoseinsoltanzadeh1985-hue.github.io/Simorgh/games/`

Before changing the Guardian bot's default game URL, verify the Pages deployment and run the Telegram smoke test. Keep polling/webhook configuration unchanged during this game-only release.
