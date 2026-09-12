# Simorgh 4.7.0

This release upgrades the existing Simorgh/PediGuardian Java controller from the 4.4.0-patched baseline to the validated 4.7.0 track.

## Changes
- Preserves `.env`; no secrets are committed.
- Adds the 4.7 command/handler engine, owner/service controls, and Glass panel.
- Uses Telegram-native admin state as the authority for privileged actions.
- Keeps the Voice Chat wheel as a current-roster selection request with a separate worker architecture.
- Keeps Air Raider and Backgammon as Mini App entry points.
- Keeps media/music separate from Guardian.
- Keeps Supabase audit/access integration.

## Verified artifact
- `pedi-guardian-java-4.7.0.jar`: `ff7505be8e20edde66f890ae8dedc314a8b457d2aab021325b9270a26b65d1f8`
- `PediGuardian-4.7.0-java-source.zip`: `028b0d9affdb1a63297fdc349342a8b0249c86b32198ad59b12051e93df098b5`
- update bundle: `49e952cad0552546d7cc3df9c1aa21d3d03c4015ff5845180288fa6962ea032e`

The corresponding Termux update package is prepared separately so the existing `.env` can be backed up and reused safely.