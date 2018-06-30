WNAME=dot
DIRDOT=$HOME/dotfiles/

SPLIT=15
ADJUST=10

# new dotfile window
tmux new-window -n $WNAME
tmux send-keys 'cd '$DIRDOT C-m
tmux send-keys 'vim' C-m
tmux send-keys ',k'
tmux split-window -v -p $SPLIT
tmux send-keys 'cd '$DIRDOT C-m
# wx=$(tmux display-message -p '#I')
# tmux send-keys 'echo '$wx C-m
# tmux send-keys 'tmux resize-pane -t '$wx'.2 -D '$ADJUST C-m
