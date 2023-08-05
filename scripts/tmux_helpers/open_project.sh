PROJECT=$1
if [ -z "$PROJECT" ]; then
  echo "PROJECT is not set"
  exit 1
else 
 echo "Setting up projects/$PROJECT"
fi

session_name="p/${PROJECT}"

if tmux has-session -t $session_name 2>/dev/null; then
 # tmux new-session  -s "tmp" -n "tmp" -d 'tmux switch-client -t "$session_name"'
 tmux switch-client -t $sesison_name
else
session_root="$HOME/projects/$PROJECT"
tmux new-session -c "$session_root" -s "$session_name" -n "code" -d  
tmux new-window -c "$session_root" -t "$session_name" -n term 
tmux new-window -c "$session_root" -t "$session_name" -n git 

tmux send-keys -t "$session_name:code" "nvim" C-m
tmux send-keys -t "$session_name:term" "flutter doctor && flutter pub get" C-m
tmux send-keys -t "$session_name:git" "lazygit" C-m

echo "created windows"

tmux select-window -t "$session_name:code"
tmux switch-client -t "$session_name"
fi

