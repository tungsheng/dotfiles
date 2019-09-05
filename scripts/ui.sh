WNAME=ui
DIRDEV=$HOME/Code/tetration/ui/

SPLIT1=30
SPLIT2=50
ADJUST=10

CMD1='bin/webpack-dev-server'
CMD2='rails s'

# new back window
tmux new-window -n $WNAME
tmux send-keys 'cd '$DIRDEV C-m
tmux send-keys "$CMD1" C-m
tmux split-window -h -p $SPLIT2
tmux send-keys 'cd '$DIRDEV C-m
tmux send-keys "$CMD2" C-m
tmux select-pane -t $window.1
# wx=$(tmux display-message -p '#I')
# tmux send-keys 'tmux resize-pane -t '$wx'.4 -D '$ADJUST C-m
