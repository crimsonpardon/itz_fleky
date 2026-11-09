#!/usr/bin/env bash
set -euo pipefail

# One-run installer for Ubuntu 22.04/24.04 and Debian-based VPS hosts.
# Asks for your bot token, main owner ID and a custom prefix, then writes .env for you.

RED=$'\e[1;31m'; GRN=$'\e[1;32m'; YEL=$'\e[1;33m'; CYN=$'\e[1;36m'; DIM=$'\e[2m'; RST=$'\e[0m'
REPO_URL="https://github.com/crimsonpardon/evm-bot"
TTY="${EVM_TTY:-/dev/tty}"

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

# ---------- interactive setup ----------
ask_token() {
  local v
  while true; do
    printf '%s?%s Bot token %s(input hidden — paste it and press Enter)%s: ' "$CYN" "$RST" "$DIM" "$RST"
    IFS= read -rs v <&3 || exit 1; echo
    v="${v//[[:space:]]/}"
    if [[ ${#v} -ge 50 && "$v" == *.* ]]; then TOKEN_IN="$v"; return; fi
    printf '  %s✖ That does not look like a Discord bot token. Copy it from Developer Portal > Bot > Reset Token.%s\n' "$RED" "$RST"
  done
}

ask_owner() {
  local v
  while true; do
    printf '%s?%s Main owner ID %s(your Discord user ID, numbers only)%s: ' "$CYN" "$RST" "$DIM" "$RST"
    IFS= read -r v <&3 || exit 1
    v="${v//[[:space:]]/}"
    if [[ "$v" =~ ^[0-9]{15,22}$ ]]; then OWNER_IN="$v"; return; fi
    printf '  %s✖ An owner ID is 17-20 digits. Enable Developer Mode, right-click your name > Copy User ID.%s\n' "$RED" "$RST"
  done
}

ask_prefix() {
  local v
  while true; do
    printf '%s?%s Custom prefix %s(1-3 characters, e.g. *  !  ?  -  default: *)%s: ' "$CYN" "$RST" "$DIM" "$RST"
    IFS= read -r v <&3 || exit 1
    v="${v:-*}"
    if [[ ${#v} -le 3 && "$v" != *[[:space:]]* && "$v" != *"'"* && "$v" != *'"'* && "$v" != *'\'* ]]; then PREFIX_IN="$v"; return; fi
    printf '  %s✖ Use 1-3 characters with no spaces or quotes.%s\n' "$RED" "$RST"
  done
}

collect_config() {
  CONFIG_MODE="new"
  if ! { exec 3<"$TTY"; } 2>/dev/null; then CONFIG_MODE="skip"; return; fi
  if [[ -f "$APP_DIR/.env" ]]; then
    local a
    printf '%s?%s An existing .env was found. Replace it with new values? %s[y/N]%s: ' "$CYN" "$RST" "$DIM" "$RST"
    IFS= read -r a <&3 || a="n"
    [[ "$a" =~ ^[Yy] ]] || { CONFIG_MODE="keep"; return; }
  fi
  printf '\n%s── Bot configuration ──%s\n' "$YEL" "$RST"
  ask_token; ask_owner; ask_prefix
  printf '\n  %s✔ Token%s  ending ...%s\n  %s✔ Owner%s  %s\n  %s✔ Prefix%s %s   %s(slash commands like /help always work too)%s\n\n' \
    "$GRN" "$RST" "${TOKEN_IN: -4}" "$GRN" "$RST" "$OWNER_IN" "$GRN" "$RST" "$PREFIX_IN" "$DIM" "$RST"
}

write_env() {
  case "$CONFIG_MODE" in
    keep) echo "kept"; return ;;
    skip) [[ -f "$APP_DIR/.env" ]] || cp "$APP_DIR/.env.example" "$APP_DIR/.env"; chmod 600 "$APP_DIR/.env"; echo "created-empty"; return ;;
  esac
  APP_DIR="$APP_DIR" TOKEN_IN="$TOKEN_IN" OWNER_IN="$OWNER_IN" PREFIX_IN="$PREFIX_IN" python3 - <<'PY'
import os, re
d = os.environ["APP_DIR"]
text = open(os.path.join(d, ".env.example"), encoding="utf-8").read()
vals = {"DISCORD_TOKEN": os.environ["TOKEN_IN"], "OWNER_ID": os.environ["OWNER_IN"],
        "BOT_PREFIX": "'" + os.environ["PREFIX_IN"] + "'"}
for k, v in vals.items():
    text, n = re.subn(rf"^{k}=.*$", lambda m: f"{k}={v}", text, flags=re.M)
    if not n:
        text += f"\n{k}={v}\n"
path = os.path.join(d, ".env")
open(path, "w", encoding="utf-8").write(text)
os.chmod(path, 0o600)
PY
  echo "created"
}

banner

if [[ $EUID -ne 0 ]]; then
  printf '%s✖ Run with sudo:%s sudo bash install.sh\n' "$RED" "$RST"
  exit 1
fi

APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOKEN_IN=""; OWNER_IN=""; PREFIX_IN="*"; CONFIG_MODE="new"
collect_config

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
check_syntax()   { python3 -m py_compile "$APP_DIR/bot.py"; }

step "Installing system packages"      install_system
step "Creating virtual environment"    make_venv
step "Installing Python dependencies"  install_python
step "Saving your configuration (.env)" write_env
step "Checking bot.py syntax"          check_syntax

printf '\n%s✔ All done!%s\n\n' "$GRN" "$RST"
if grep -q '^created$' "$LOG"; then
  printf '  %s.env saved%s with your token, owner ID and prefix %s%s%s.\n' "$YEL" "$RST" "$CYN" "$PREFIX_IN" "$RST"
  printf '\n  %sStart the bot%s\n   %s/.venv/bin/python %s/bot.py\n' "$CYN" "$RST" "$APP_DIR" "$APP_DIR"
else
  printf '  %sEdit your settings:%s nano %s/.env\n' "$YEL" "$RST" "$APP_DIR"
  printf '\n  %sStart the bot%s\n   %s/.venv/bin/python %s/bot.py\n' "$CYN" "$RST" "$APP_DIR" "$APP_DIR"
fi
printf '\n  %sChange the prefix later with%s *setprefix <new prefix>\n' "$DIM" "$RST"
printf '  %sLXD provisioning stays off until you set ENABLE_LXD_PROVISIONING=true in .env%s\n' "$DIM" "$RST"
printf '  %safter checking networking, quotas and firewall.%s\n' "$DIM" "$RST"

footer
