#!/usr/bin/env bash
set -euo pipefail

# One-run dependency installer for Ubuntu 22.04/24.04 and Debian-based VPS hosts.

RED=$'\e[1;31m'; GRN=$'\e[1;32m'; YEL=$'\e[1;33m'; CYN=$'\e[1;36m'; DIM=$'\e[2m'; RST=$'\e[0m'
REPO_URL="https://github.com/crimsonpardon/evm-bot"

banner() {
  printf '%s' "$RED"
  cat <<'ART'

 ██████╗██████╗ ██╗███╗   ███╗███████╗ ██████╗ ███╗   ██╗
██╔════╝██╔══██╗██║████╗ ████║██╔════╝██╔═══██╗████╗  ██║
██║     ██████╔╝██║██╔████╔██║███████╗██║   ██║██╔██╗ ██║
██║     ██╔══██╗██║██║╚██╔╝██║╚════██║██║   ██║██║╚██╗██║
╚██████╗██║  ██║██║██║ ╚═╝ ██║███████║╚██████╔╝██║ ╚████║
 ╚═════╝╚═╝  ╚═╝╚═╝╚═╝     ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═══╝
ART
  printf '%s' "$RST"
  printf '  %sEVM Bot V2 installer%s %s• developed by mowaz_official%s\n\n' "$CYN" "$RST" "$DIM" "$RST"
}

footer() {
  printf '\n%s──────────────────────────────────────────────────────────%s\n' "$RED" "$RST"
  printf '  %s⭐ Enjoying EVM Bot? Please give one star!%s\n' "$YEL" "$RST"
  printf '  %s%s%s\n' "$CYN" "$REPO_URL" "$RST"
  printf '%s──────────────────────────────────────────────────────────%s\n\n' "$RED" "$RST"
}

banner

if [[ $EUID -ne 0 ]]; then
  printf '%s✖ Run with sudo:%s sudo bash install.sh\n' "$RED" "$RST"
  exit 1
fi

APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG="$(mktemp /tmp/evm-install.XXXXXX.log)"
export DEBIAN_FRONTEND=noninteractive
TOTAL=5; N=0

step() {  # step "message" command...
  N=$((N + 1)); local msg="$1"; shift
  printf '%s[%d/%d]%s %s ... ' "$CYN" "$N" "$TOTAL" "$RST" "$msg"
  if "$@" >>"$LOG" 2>&1; then
    printf '%s✔%s\n' "$GRN" "$RST"
  else
    printf '%s✖ failed%s\n\n%sLast log lines (%s):%s\n' "$RED" "$RST" "$YEL" "$LOG" "$RST"
    tail -n 15 "$LOG"
    exit 1
  fi
}

install_system() { apt-get update -y && apt-get install -y python3 python3-venv python3-pip ca-certificates curl git sqlite3; }
make_venv()      { python3 -m venv "$APP_DIR/.venv" && "$APP_DIR/.venv/bin/python" -m pip install --upgrade pip wheel; }
install_python() { "$APP_DIR/.venv/bin/pip" install -r "$APP_DIR/requirements.txt"; }
make_env() {
  if [[ ! -f "$APP_DIR/.env" ]]; then
    cp "$APP_DIR/.env.example" "$APP_DIR/.env"; chmod 600 "$APP_DIR/.env"
    echo "created"
  else
    echo "kept"
  fi
}
check_syntax()   { python3 -m py_compile "$APP_DIR/bot.py"; }

step "Installing system packages"      install_system
step "Creating virtual environment"    make_venv
step "Installing Python dependencies"  install_python
step "Preparing .env file"             make_env
step "Checking bot.py syntax"          check_syntax

printf '\n%s✔ All done!%s\n\n' "$GRN" "$RST"
if grep -q '^created$' "$LOG" 2>/dev/null; then
  printf '  %sCreated%s %s/.env — add DISCORD_TOKEN and OWNER_ID before starting.\n' "$YEL" "$RST" "$APP_DIR"
else
  printf '  %sExisting .env preserved.%s\n' "$YEL" "$RST"
fi
printf '\n  %sNext steps%s\n' "$CYN" "$RST"
printf '   1) nano %s/.env\n' "$APP_DIR"
printf '   2) %s/.venv/bin/python %s/bot.py\n' "$APP_DIR" "$APP_DIR"
printf '\n  %sLXD image:%s ubuntu:24.04\n' "$DIM" "$RST"
printf '  %sLXD provisioning stays off until you set ENABLE_LXD_PROVISIONING=true%s\n' "$DIM" "$RST"
printf '  %safter checking networking, quotas and firewall.%s\n' "$DIM" "$RST"

footer
