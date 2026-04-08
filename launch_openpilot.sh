#!/usr/bin/env bash

export API_HOST="https://api.konik.ai/"
export ATHENA_HOST="wss://athena.konik.ai"

set -euo pipefail
IFS=$'\n\t'
trap 'exec ./launch_chffrplus.sh' ERR
C3_LAUNCH_SH="./sunnypilot/system/hardware/c3/launch_chffrplus.sh"
MODEL="$(tr -d '\0' < "/sys/firmware/devicetree/base/model")"
export MODEL
if [ "$MODEL" = "comma tici" ]; then
  [ -x "$C3_LAUNCH_SH" ] || false
  exec "$C3_LAUNCH_SH"
fi
exec ./launch_chffrplus.sh
