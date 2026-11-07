#!/usr/bin/env bash
# Umbriel / Noctalia Keybindings Search Viewer
# Dynamically reads keybinds.toml and extracts descriptions from comments
# directly preceding each keybind or inline on the same line.

KEYBINDS_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/umbriel/cfg/keybinds.toml"
if [ ! -f "$KEYBINDS_FILE" ]; then
  KEYBINDS_FILE="$HOME/ShinNix/dotfiles/umbriel/cfg/keybinds.toml"
fi

if [ ! -f "$KEYBINDS_FILE" ]; then
  echo "Keybinds configuration not found: $KEYBINDS_FILE" >&2
  exit 1
fi

generate_list() {
  awk '
  # Skip empty lines and table headers
  /^[[:space:]]*$/ || /^[[:space:]]*\[/ { next }

  # Match comment lines
  /^[[:space:]]*#/ {
    line = $0
    sub(/^[[:space:]]*#[[:space:]]*/, "", line)

    # Ignore section header dividers like "=== Applications ===" or "---"
    if (line !~ /^[=]/ && line !~ /^[-]/ && line !~ /^[|]/ && line != "") {
      last_comment = line
    }
    next
  }

  # Match TOML keybinding lines: "Mod+..." = ...
  /^[[:space:]]*"/ {
    raw_line = $0
    inline_comment = ""

    # Extract quoted key combo
    match(raw_line, /"[^"]+"/)
    combo = substr(raw_line, RSTART + 1, RLENGTH - 2)
    rest = substr(raw_line, RSTART + RLENGTH)

    # Extract action value (either action = "..." or "= \"...\"")
    action_str = ""
    if (match(rest, /action[[:space:]]*=[[:space:]]*"[^"]+"/)) {
      act_part = substr(rest, RSTART, RLENGTH)
      sub(/^action[[:space:]]*=[[:space:]]*"/, "", act_part)
      sub(/"$/, "", act_part)
      action_str = act_part
    } else if (match(rest, /=[[:space:]]*"[^"]+"/)) {
      act_part = substr(rest, RSTART, RLENGTH)
      sub(/^=[[:space:]]*"/, "", act_part)
      sub(/"$/, "", act_part)
      action_str = act_part
    }

    # Prettify modifier names
    gsub(/Mod\+/, "Super + ", combo)
    gsub(/Shift\+/, "Shift + ", combo)
    gsub(/Ctrl\+/, "Ctrl + ", combo)
    gsub(/Alt\+/, "Alt + ", combo)

    desc = last_comment
    if (desc == "") {
      desc = action_str
      sub(/^spawn[[:space:]]+/, "", desc)
    }

    printf "%-26s │ %s\n", combo, desc
    last_comment = ""
  }
  ' "$KEYBINDS_FILE"
}

LAUNCHER="noctalia"
for arg in "$@"; do
  case "$arg" in
    --fuzzel|-f) LAUNCHER="fuzzel" ;;
    --noctalia|-n) LAUNCHER="noctalia" ;;
  esac
done

if [ "$LAUNCHER" = "fuzzel" ] && command -v fuzzel >/dev/null 2>&1; then
  SELECTED=$(generate_list | fuzzel -d -p "Keybindings: " -w 95 -l 24 --placeholder="Search shortcuts or actions...")
else
  SELECTED=$(generate_list | noctalia dmenu -p "Keybindings")
fi

if [ -z "$SELECTED" ]; then
  exit 0
fi

# Lookup and execute selected binding action if user presses Enter
COMBO=$(echo "$SELECTED" | awk -F "│" '{print $1}' | sed 's/[[:space:]]*$//')

MATCHED_ACTION=$(awk -v target="$COMBO" '
/^[[:space:]]*"/ {
  raw_line = $0
  match(raw_line, /"[^"]+"/)
  combo = substr(raw_line, RSTART + 1, RLENGTH - 2)
  rest = substr(raw_line, RSTART + RLENGTH)

  gsub(/Mod\+/, "Super + ", combo)
  gsub(/Shift\+/, "Shift + ", combo)
  gsub(/Ctrl\+/, "Ctrl + ", combo)
  gsub(/Alt\+/, "Alt + ", combo)

  if (combo == target) {
    action_str = ""
    if (match(rest, /action[[:space:]]*=[[:space:]]*"[^"]+"/)) {
      act_part = substr(rest, RSTART, RLENGTH)
      sub(/^action[[:space:]]*=[[:space:]]*"/, "", act_part)
      sub(/"$/, "", act_part)
      action_str = act_part
    } else if (match(rest, /=[[:space:]]*"[^"]+"/)) {
      act_part = substr(rest, RSTART, RLENGTH)
      sub(/^=[[:space:]]*"/, "", act_part)
      sub(/"$/, "", act_part)
      action_str = act_part
    }

    if (action_str ~ /^spawn[[:space:]]+/) {
      sub(/^spawn[[:space:]]+/, "", action_str)
      print "SPAWN:" action_str
    } else if (action_str != "") {
      print "DISPATCH:" action_str
    }
    exit
  }
}
' "$KEYBINDS_FILE")

if [[ "$MATCHED_ACTION" == SPAWN:* ]]; then
  EXEC_CMD="${MATCHED_ACTION#SPAWN:}"
  eval "$EXEC_CMD" &
elif [[ "$MATCHED_ACTION" == DISPATCH:* ]]; then
  DISPATCH_CMD="${MATCHED_ACTION#DISPATCH:}"
  if command -v umbriel >/dev/null 2>&1; then
    umbriel msg $DISPATCH_CMD >/dev/null 2>&1 || true
  fi
fi

