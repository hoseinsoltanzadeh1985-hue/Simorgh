#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
APP_DIR="$HOME/PediGuardian/PediGuardianJava"
TS="$(date +%Y%m%d-%H%M%S)"
PACKAGE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
NEW_JAR="$PACKAGE_DIR/PediGuardianJava/pedi-guardian-java-4.7.0.jar"

[ -f "$APP_DIR/.env" ] || { echo "ERROR: $APP_DIR/.env not found"; exit 1; }
[ -f "$NEW_JAR" ] || { echo "ERROR: 4.7.0 JAR not found beside this script"; exit 1; }

mkdir -p "$APP_DIR/backups/$TS"
cp -f "$APP_DIR/.env" "$APP_DIR/backups/$TS/.env"
for f in pedi-guardian-java-4.4.0-patched.jar pedi-guardian-java-4.5.2.jar pedi-guardian-java-4.6.1-command-engines.jar pedi-guardian-java-4.7.0.jar; do
  [ -f "$APP_DIR/$f" ] && cp -f "$APP_DIR/$f" "$APP_DIR/backups/$TS/" || true
done

pkill -f 'pedi-guardian-java-(4\\.4\\.0|4\\.5\\.2|4\\.6\\.1|4\\.7\\.0)\\.jar' 2>/dev/null || true
sleep 1
cp -f "$NEW_JAR" "$APP_DIR/pedi-guardian-java-4.7.0.jar"
chmod 600 "$APP_DIR/.env"
cd "$APP_DIR"
set -a
. ./.env
set +a
nohup java -jar pedi-guardian-java-4.7.0.jar > guardian-4.7.0.log 2>&1 &
echo $! > guardian.pid
sleep 2
printf 'Simorgh/PediGuardian 4.7.0 started. PID=%s\n' "$(cat guardian.pid)"
tail -n 30 guardian-4.7.0.log || true
