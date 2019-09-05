WNAME=ui-test
DIRDEV=$HOME/Code/tetration/ui/

SPLIT1=30
SPLIT2=50
ADJUST=10

CMD0='yarn protractor'
CMD1='RAILS_ENV=test bundle exec rake e2e:server'
CMD2='RAILS_ENV=test bin/webpack --watch --mode development --devtool cheap-module-source-map'

# new back window
tmux new-window -n $WNAME
tmux send-keys 'cd '$DIRDEV C-m
tmux send-keys "$CMD0"
tmux split-window -h -p $SPLIT1
tmux send-keys 'cd '$DIRDEV C-m
tmux send-keys "$CMD1" C-m
tmux split-window -v -p $SPLIT2
tmux send-keys 'cd '$DIRDEV C-m
tmux send-keys "$CMD2" C-m
tmux select-pane -t $window.1
# wx=$(tmux display-message -p '#I')
# tmux send-keys 'tmux resize-pane -t '$wx'.4 -D '$ADJUST C-m
