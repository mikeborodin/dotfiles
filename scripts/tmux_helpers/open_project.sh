PROJECT=$1

if [ -z "$PROJECT" ]; then
  echo "PROJECT is not set"
  exit 1
else
  echo "Setting up projects/$PROJECT"
fi

session_name="${PROJECT}"

if tmux has-session -t $session_name 2>/dev/null; then
  tmux switch-client -t $session_name
else
  session_root="$HOME/projects/$PROJECT"

  if [ -d "$session_root/app" ]; then
    session_root="$session_root/app"
  fi

  tmux new-session -c "$session_root" -s "$session_name" -n "code" -d
  tmux new-window -c "$session_root" -t "$session_name" -n "term"

  sleep 1

  tmux send-keys -t "$session_name:code" "drd" C-m
  tmux send-keys -t "$session_name:term" "drd" C-m

  tmux select-window -t "$session_name:code"
  tmux switch-client -t "$session_name"
fi
