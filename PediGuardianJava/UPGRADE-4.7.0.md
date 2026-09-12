# Termux upgrade procedure

1. Keep the existing `~/PediGuardian/PediGuardianJava/.env` unchanged.
2. Back up the current JAR and `.env` before replacement.
3. Copy `pedi-guardian-java-4.7.0.jar` into `~/PediGuardian/PediGuardianJava/`.
4. Start with the existing `.env` and `DEPLOYMENT_MODE=local`.
5. Verify `/version`, `/panel`, `/game`, `/security`, and the normal moderation flow.

The update bundle includes `UPDATE-4.7.0.sh`, which performs the backup-first replacement automatically.

Important: this is the Java emergency/recovery path. Production webhook ownership should remain single-owner; do not run two Telegram update consumers against the same bot token simultaneously.