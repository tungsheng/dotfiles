WN=go
DN=go
DIR=$HOME/Code/

SPLIT=15
ADJUST=10

# new inn window
tmux new-window -n $WN
tmux send-keys 'cd '$DIR$DN C-m
tmux send-keys 'vim' C-m
tmux send-keys ',k'
tmux split-window -v -p $SPLIT
tmux send-keys 'cd '$DIR$DN C-m
tmux split-window -h
tmux send-keys 'cd '$DIR$DN C-m
# wx=$(tmux display-message -p '#I')
# tmux send-keys 'tmux resize-pane -t '$wx'.3 -D '$ADJUST C-m
