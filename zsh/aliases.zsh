setopt auto_name_dirs
setopt auto_pushd
setopt pushd_ignore_dups

alias ...='cd ../..'
alias -- -='cd -'
alias _='sudo'
alias l='ls -lah'
alias open='gnome-open'

alias elt='cd /home/jkelly/projects/extra'
alias maketmux='sh /home/jkelly/default_tmux.sh'

alias glom='git pull origin master'
alias glot='git pull origin test'
alias gpom='git push origin master'
alias gpot='git push origin test'
alias gca='git commit -a'
alias gst='git status'

alias rwin='rdesktop -g 1280x1024 -P -z -x l -r sound:off -u webadmin 172.25.8.55 &'
