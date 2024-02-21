WNAME=inn
DNAME=inn
DIRGO=$GOPATH/src/git.fullinn.tw/fullinn/

SPLIT=15
ADJUST=10

# new inn window
tmux new-window -n $WNAME
tmux send-keys 'cd '$DIRGO$DNAME C-m
tmux send-keys 'vim' C-m
tmux send-keys ',k'
tmux split-window -v -p $SPLIT
tmux send-keys 'cd '$DIRGO$DNAME C-m
tmux send-keys 'mongod' C-m
tmux split-window -h
tmux send-keys 'cd '$DIRGO$DNAME C-m
tmux select-pane -t $window.2
tmux split-window -h
tmux send-keys 'cd '$DIRGO$DNAME C-m
tmux send-keys 'make stylesheets generate build' C-m
tmux send-keys './bin/inn server' C-m
tmux select-pane -t $window.4
# wx=$(tmux display-message -p '#I')
# tmux send-keys 'tmux resize-pane -t '$wx'.3 -D '$ADJUST C-m
