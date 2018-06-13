WNAME=backstage
DNAME=backstage
DIRDEV=$HOME/Documents/webapp/fullinn/

SPLIT=15
SPLIT_1_2=50
ADJUST=10

# new backstage window
tmux new-window -n $WNAME
tmux send-keys 'cd '$DIRDEV$DNAME C-m
tmux send-keys 'vim' C-m
tmux send-keys ',k'
tmux split-window -v -p $SPLIT
tmux send-keys 'cd '$DIRDEV$DNAME C-m
tmux send-keys 'yarn start' C-m
tmux split-window -h -p $SPLIT_1_2
tmux send-keys 'cd '$DIRDEV$DNAME C-m
# wx=$(tmux display-message -p '#I')
# tmux send-keys 'tmux resize-pane -t '$wx'.3 -D '$ADJUST C-m
