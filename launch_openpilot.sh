#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

export API_HOST="https://api.konik.ai/"
export ATHENA_HOST="wss://athena.konik.ai"

# Generate unique keys for clone devices if not already done
if [ ! -f /data/params/d/DoNotDisturbKey ]; then
  echo "Generating unique device keys..."
  mkdir -p /persist/comma
  openssl genrsa -out /persist/comma/id_rsa 2048
  openssl rsa -in /persist/comma/id_rsa -pubout -out /persist/comma/id_rsa.pub
  chmod 600 /persist/comma/id_rsa
  rm -f /data/params/d/DongleId
  rm -f /persist/comma/dongle_id
  touch /data/params/d/DoNotDisturbKey
  echo "Keys generated. Rebooting..."
  sudo reboot
fi

# On any failure, run the fallback launcher
trap 'exec ./launch_chffrplus.sh' ERR
C3_LAUNCH_SH="./sunnypilot/system/hardware/c3/launch_chffrplus.sh"
MODEL="$(tr -d '\0' < "/sys/firmware/devicetree/base/model")"
export MODEL
if [ "$MODEL" = "comma tici" ]; then
  [ -x "$C3_LAUNCH_SH" ] || false
  exec "$C3_LAUNCH_SH"
fi
exec ./launch_chffrplus.sh
