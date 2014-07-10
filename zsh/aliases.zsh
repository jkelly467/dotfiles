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

alias rwin='rdesktop -g 1280x1024 -P -z -x l -r sound:off -u adzmar 172.25.8.244 &' #adzmar1
alias rwinIE='rdesktop -g 1280x1024 -P -z -x l -r sound:off -u webadmin 172.25.3.147 &'

alias -g "backlight"="/bin/bash /usr/bin/asus-screen-brightness"
alias -g "klight"="asus-kbd-backlight"

alias vpn='sudo vpnc default'

alias selt='sh /home/jkelly/scripts/selt.sh'
alias eltdep='sh /home/jkelly/scripts/eltdep.sh'
alias breakdown='sh /home/jkelly/scripts/breakdown.sh'
alias tpull='sh /home/jkelly/scripts/tpull.sh'
alias spull='sh /home/jkelly/scripts/spull.sh'
alias mongocast='mongo ds031407.mongolab.com:31407/zer0cast -u zer0cast -p retroafrica'
alias stagdep='ssh deployment@deployment "cd /home/deployment/extra/extra-utils/auto_deploy; /usr/bin/python easy_single_click_deploy.py -p test -f staging.csv"'
alias releasedep='sh /home/jkelly/scripts/releasedep.sh'
alias redisserv='cd /var/log/redis; redis-server'
alias rake='noglob rake'

alias pbar='aoss pianobar'
alias tas='clear; task cases'
