#!/bin/bash

if ! tmux has-session -t 'Default'; then
   tmux new-session -s 'Default' -d -n 'workspace'
   tmux rename-window 'work'
   tmux new-window -a -n 'ssh'
   # tmux new-window -a -n 'bgtasks'
   # tmux split-window -t 'bgtasks'
   # tmux send-keys -t 'bgtasks' 'ham' 'C-m'
   # tmux send-keys -t 'bgtasks' 'hotot' 'C-m'
   tmux select-window -t '1'
   tmux attach-session -t 'Default'
fi

tmux attach -t 'Default'
