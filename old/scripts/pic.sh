WNAME=pic
DNAME=pic
DIRDEV=$HOME/Documents/workApp/fullinn/

SPLIT=15
ADJUST=10

# new pic window
tmux new-window -n $WNAME
tmux send-keys 'cd '$DIRDEV$DNAME C-m
tmux send-keys 'vim' C-m
tmux send-keys ',k'
tmux split-window -v -p $SPLIT
tmux send-keys 'cd '$DIRDEV$DNAME C-m
tmux send-keys 'picfit -c config/local.json' C-m
tmux split-window -h
tmux send-keys 'cd '$DIRDEV$DNAME C-m
# wx=$(tmux display-message -p '#I')
# tmux send-keys 'tmux resize-pane -t '$wx'.3 -D '$ADJUST C-m
