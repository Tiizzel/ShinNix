#!/usr/bin/env bash
set -euo pipefail

if command -v spotify-reload-cef >/dev/null 2>&1; then
  spotify-reload-cef || true
elif [ -x "$HOME/.local/bin/spotify-reload-cef" ]; then
  "$HOME/.local/bin/spotify-reload-cef" || true
else
  CLI_VER=$(spicetify -v 2>/dev/null | sed 's/^v//' || true)
  if [ -n "$CLI_VER" ] && [ -f "$HOME/.config/spicetify/config-xpui.ini" ]; then
    sed -i "s/^with *= *.*/with    = $CLI_VER/" "$HOME/.config/spicetify/config-xpui.ini"
  fi
  spicetify -q apply --no-restart 2>/dev/null || true
fi
