#!/usr/bin/env bash
# Session selector for kitty using fzf
# Lists available .kitty-session files and uses kitty's native
# goto_session action to load/switch, preserving session metadata.
#
# Compatible with macOS Bash 3.2+

set -uo pipefail

export PATH="/usr/local/bin:/opt/homebrew/bin:$HOME/.local/share/devbox/global/default/.devbox/nix/profile/default/bin:$HOME/.local/share/mise/shims:$PATH"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SESSIONS_DIR="$SCRIPT_DIR/sessions"

die() {
	echo "Error: $1"
	read -n 1 -s -r -p "Press any key to close..."
	exit 1
}

if [ ! -d "$SESSIONS_DIR" ]; then
	die "No sessions directory found at $SESSIONS_DIR"
fi

# Collect session files
session_names=$(find "$SESSIONS_DIR" -name '*.kitty-session' -exec basename {} .kitty-session \; | sort)

if [ -z "$session_names" ]; then
	die "No .kitty-session files found in $SESSIONS_DIR"
fi

# Get active session name to mark it
active_session=$(kitty @ ls 2>/dev/null | python3 -c "
import json, sys
data = json.load(sys.stdin)
for os_win in data:
    for tab in os_win.get('tabs', []):
        if tab.get('is_active', False):
            for w in tab.get('windows', []):
                s = w.get('created_in_session_name', '') or tab.get('created_in_session_name', '')
                if s:
                    # Strip path and extension
                    import os
                    s = os.path.basename(s)
                    for ext in ('.kitty-session', '.kitty_session', '.session'):
                        if s.endswith(ext):
                            s = s[:-len(ext)]
                            break
                    print(s)
                    sys.exit(0)
" 2>/dev/null || true)

# Build fzf input
fzf_input=""
while IFS= read -r name; do
	[ -z "$name" ] && continue
	if [ "$name" = "$active_session" ]; then
		fzf_input="${fzf_input}* ${name}
"
	else
		fzf_input="${fzf_input}  ${name}
"
	fi
done <<EOF
$session_names
EOF

selected=$(printf '%s' "$fzf_input" | fzf \
	--prompt="Select session: " \
  --prompt="" \
  --layout=reverse \
  --height=60% \
  --border=rounded \
  --margin=10%,20% \
  --padding=1 \
  --no-info \
  --ansi \
  --color=bg:#1a1b26,fg:#c0caf5 \
  --color=bg+:#24283b,fg+:#c0caf5 \
  --color=hl:#7aa2f7,hl+:#7aa2f7 \
  --color=border:#3b4261 \
  --color=info:#7dcfff,prompt:#7dcfff,pointer:#7aa2f7 \
  --color=marker:#9ece6a,spinner:#9ece6a \
  --pointer="" \
  --marker="" \
  --separator="─") || exit 0

if [ -z "$selected" ]; then
	exit 0
fi

# Strip marker prefix
session_name=$(echo "$selected" | sed 's/^[* ] //')
session_file="$SESSIONS_DIR/${session_name}.kitty-session"

if [ ! -f "$session_file" ]; then
	die "Session file not found: $session_file"
fi

# Use kitty's native goto_session via remote control
kitty @ action goto_session "$session_file"
