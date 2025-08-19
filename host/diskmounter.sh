#!/bin/bash
set -euo pipefail

# Parametri (default coerenti)
DEFAULT_CTID="103"
DEFAULT_BASE="/mnt/sharedVMDrive"

read -p "Enter the container ID (default: $DEFAULT_CTID): " CTID
CTID=${CTID:-$DEFAULT_CTID}

read -p "Base path on host (default: $DEFAULT_BASE): " BASE
BASE=${BASE:-$DEFAULT_BASE}

# Controlli base
for d in "$BASE" "$BASE/tvshows" "$BASE/movies"; do
  if [[ ! -d "$d" ]]; then
    echo "ERRORE: directory mancante sul host: $d"
    echo "Crea/monta prima $BASE (es. in /etc/fstab) e le sottocartelle tvshows/movies."
    exit 1
  fi
done

# Trova prossimo mp libero
next_mp_index() {
  local used
  used="$(pct config "$CTID" | sed -n 's/^mp\([0-9]\+\):.*/\1/p' | sort -n | tail -1 || true)"
  if [[ -z "${used:-}" ]]; then echo 0; else echo $((used + 1)); fi
}

# Aggiunge i mount (idempotente)
add_mount() {
  local hostdir="$1" target="$2"
  if pct config "$CTID" | grep -q "mp[0-9]\+: $hostdir,"; then
    echo ">> Già montato: $hostdir -> $target (skip)"
  else
    local idx; idx="$(next_mp_index)"
    echo ">> Montando $hostdir -> $target come mp$idx"
    pct set "$CTID" -mp${idx} "${hostdir},mp=${target}"
  fi
}

add_mount "$BASE/tvshows" "/shared/tvshows"
add_mount "$BASE/movies"  "/shared/movies"

echo ">> Riavvio CT $CTID..."
pct restart "$CTID"

echo ">> Verifica dentro al CT:"
echo "pct exec $CTID -- bash -lc 'ls -la /shared /shared/tvshows /shared/movies || true'"
