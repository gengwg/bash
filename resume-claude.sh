#!/usr/bin/env bash
#
# resume-last-10.sh
# Opens your N most recent Claude Code sessions, each in its own tab,
# running `claude --resume <session-id>`.
#
# Auto-detects the terminal emulator. Supported for real tabs:
#   terminator, gnome-terminal, mate-terminal, xfce4-terminal, konsole, tilix
# Fallback: tmux (windows == tabs; switch with Ctrl-b n / Ctrl-b p)
#
# Usage:
#   chmod +x resume-last-10.sh
#   ./resume-last-10.sh              # last 10
#   ./resume-last-10.sh 5            # last 5
#   ./resume-last-10.sh -l           # list only, open nothing
#   ./resume-last-10.sh --tmux       # force tmux mode
#   ./resume-last-10.sh --terminator # force terminator tabs

set -euo pipefail

PROJECTS_DIR="$HOME/.claude/projects"
COUNT=10
LIST_ONLY=0
FORCE_TMUX=0
FORCE_TERMINATOR=0

for arg in "$@"; do
  case "$arg" in
    -l|--list)    LIST_ONLY=1 ;;
    --tmux)       FORCE_TMUX=1 ;;
    --terminator) FORCE_TERMINATOR=1 ;;
    ''|*[!0-9]*) ;;              # ignore non-numbers / unknown flags
    *) COUNT="$arg" ;;
  esac
done

[ -d "$PROJECTS_DIR" ] || { echo "No Claude Code dir at $PROJECTS_DIR" >&2; exit 1; }

# --- find the N most recently modified session files --------------------
mapfile -t files < <(find "$PROJECTS_DIR" -mindepth 2 -maxdepth 2 -name '*.jsonl' -printf '%T@ %p\n' 2>/dev/null | sort -rn | head -n "$COUNT" | cut -d' ' -f2-)
[ "${#files[@]}" -gt 0 ] || { echo "No *.jsonl sessions under $PROJECTS_DIR" >&2; exit 1; }

# --- write one launcher script per session (avoids all quoting issues) --
tmpdir="$(mktemp -d /tmp/claude-resume.XXXXXX)"
launchers=()
titles=()
declare -A title_seen=()
echo "Found ${#files[@]} session(s):"
i=0
for f in "${files[@]}"; do
  id="$(basename "$f" .jsonl)"
  cwd="$(grep -m1 -o '"cwd":"[^"]*"' "$f" | sed 's/.*"cwd":"//; s/"$//')"
  [ -z "${cwd:-}" ] && cwd="$HOME"

  # window/tab title: the project directory name, disambiguated with a short
  # session id when two sessions share a directory. ':' and '.' confuse tmux
  # target parsing and ',' splits terminator's label list, so squash them.
  title="$(basename "$cwd")"
  title="${title//[:., ]/-}"
  [ -z "$title" ] && title="session"
  if [ -n "${title_seen[$title]:-}" ]; then
    title="$title~${id:0:4}"
  else
    title_seen[$title]=1
  fi

  printf '  %-24s %s  (%s)\n' "$title" "$id" "$cwd"

  i=$((i+1))
  L="$tmpdir/tab_$i.sh"
  cat > "$L" <<EOF
#!/usr/bin/env bash
printf '\033]0;%s\007' '$title'
cd '$cwd'
claude --resume '$id'
exec "\${SHELL:-/bin/zsh}"
EOF
  chmod +x "$L"
  launchers+=("$L")
  titles+=("$title")
done

[ "$LIST_ONLY" -eq 1 ] && { echo "(list only) launchers in $tmpdir"; exit 0; }

have() { command -v "$1" >/dev/null 2>&1; }

# Terminator has no "--tab foo --tab bar" style CLI, so build a throwaway
# layout: one Window holding a Notebook (== the tab bar) with one Terminal per
# session. Tab labels come from the Notebook's `labels` list.
open_terminator() {
  local cfg="$tmpdir/terminator-config"
  local usercfg="${XDG_CONFIG_HOME:-$HOME/.config}/terminator/config"
  local parent n

  # Start from the user's own config so profile/colors/font/keybindings apply,
  # minus its [layouts] section so ours is the only layout defined.
  if [ -f "$usercfg" ]; then
    awk '/^\[/ && !/^\[\[/ { skip = ($0 ~ /^\[layouts\][[:space:]]*$/) } !skip' "$usercfg" > "$cfg"
  else
    : > "$cfg"
  fi

  {
    echo '[layouts]'
    echo '  [[claude-resume]]'
    echo '    [[[window0]]]'
    echo '      type = Window'
    echo '      parent = ""'
    if [ "${#launchers[@]}" -gt 1 ]; then
      echo '    [[[notebook0]]]'
      echo '      type = Notebook'
      echo '      parent = window0'
      printf '      labels = %s\n' "$(IFS=,; echo "${titles[*]}")"
      echo '      active_page = 0'
      parent=notebook0
    else
      parent=window0        # a one-tab notebook is pointless
    fi
    for n in "${!launchers[@]}"; do
      printf '    [[[terminal%s]]]\n' "$n"
      echo   '      type = Terminal'
      printf '      parent = %s\n' "$parent"
      printf '      order = %s\n' "$n"
      echo   '      profile = default'
      printf '      command = %s\n' "${launchers[$n]}"
      printf '      title = %s\n' "${titles[$n]}"
    done
  } >> "$cfg"

  echo "Opening ${#launchers[@]} terminator tab(s)..."
  # --no-dbus is required: terminator is single-instance over dbus, so without
  # it an already-running terminator handles the request, ignores our -g config
  # (it has its own loaded), fails to find the layout and just opens a plain
  # default window instead.
  terminator --no-dbus -g "$cfg" -l claude-resume
}

# Add one tab per session to the CURRENT terminator window (DBus remote
# control), instead of launching a separate terminator window.
open_terminator_tabs() {
  have terminator || return 1
  echo "Adding ${#launchers[@]} tab(s) to the current Terminator window..."
  local n
  for n in "${!launchers[@]}"; do
    terminator --new-tab -x "${launchers[$n]}" &
    sleep 0.2
  done
  wait
}

open_tmux() {
  have tmux || { echo "tmux not installed either. Install one of: gnome-terminal, konsole, xfce4-terminal, tilix, or tmux." >&2; exit 1; }
  local s="claude-sessions"
  tmux kill-session -t "$s" 2>/dev/null || true
  local n w
  for n in "${!launchers[@]}"; do
    if [ "$n" -eq 0 ]; then
      w="$(tmux new-session -d -s "$s" -n "${titles[$n]}" -P -F '#{window_id}' "${launchers[$n]}")"
    else
      w="$(tmux new-window -t "$s" -n "${titles[$n]}" -P -F '#{window_id}' "${launchers[$n]}")"
    fi
    # Keep our names: these are *window* options, so they must be set on each
    # window. Without them tmux renames windows after the running process
    # (hence the default "1:bash  2:bash  ...").
    tmux set-option -t "$w" automatic-rename off
    tmux set-option -t "$w" allow-rename off
  done
  echo "tmux session '$s' ready. Attaching (switch tabs: Ctrl-b n / Ctrl-b p)..."
  tmux attach -t "$s"
}

# --- pick a terminal ----------------------------------------------------
if [ "$FORCE_TMUX" -eq 1 ]; then
  open_tmux; exit 0
fi

if [ "$FORCE_TERMINATOR" -eq 1 ]; then
  have terminator || { echo "terminator not installed." >&2; exit 1; }
  open_terminator; exit 0
fi

# TERMINATOR_UUID is exported into every terminator terminal, so this means
# "we were launched from terminator" -> honour it over any other terminal.
if [ -n "${TERMINATOR_UUID:-}" ] && have terminator; then
  open_terminator_tabs

elif have gnome-terminal || have mate-terminal; then
  TERM_BIN="$(command -v gnome-terminal || command -v mate-terminal)"
  args=(); for L in "${launchers[@]}"; do args+=(--tab -- "$L"); done
  "$TERM_BIN" "${args[@]}"

elif have xfce4-terminal; then
  args=(); for L in "${launchers[@]}"; do args+=(--tab --command="$L"); done
  xfce4-terminal "${args[@]}"

elif have konsole; then
  tabsfile="$tmpdir/konsole-tabs"
  for L in "${launchers[@]}"; do echo "command: $L"; done > "$tabsfile"
  konsole --tabs-from-file "$tabsfile"

elif have tilix; then
  first=1
  for L in "${launchers[@]}"; do
    if [ "$first" -eq 1 ]; then tilix -e "$L" & first=0
    else tilix -a session-add-right -e "$L"; fi
    sleep 0.3
  done

elif have terminator; then
  open_terminator

else
  echo "No supported tabbed terminal found; using tmux." >&2
  open_tmux
fi
