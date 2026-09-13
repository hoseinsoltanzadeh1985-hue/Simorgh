# Simorgh Web Games

The `games/` directory is a self-contained static Mini App site for the Simorgh Game Center.

## Game Center

- `index.html` — main game page with two visual cards and launch buttons.
- `retro-flight.html` — lightweight non-combat retro flight arcade.
- `backgammon.html` — lightweight touch-friendly backgammon board for local play/testing.
- `assets/` — preview artwork used by the games area.

## Hosting

A GitHub Pages workflow is included at `.github/workflows/games-pages.yml`. After GitHub Pages is enabled for the repository, the games are served as normal HTTPS static pages, which is suitable for Telegram Web Apps.

Expected Pages base URL:

`https://hoseinsoltanzadeh1985-hue.github.io/Simorgh/games/`

The game pages contain no server credentials and do not require Supabase for basic play.
