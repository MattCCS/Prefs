
### meta commands
alias reload='echo "[+] ~/.bash_profile"; source ~/.bash_profile'
alias nbp='nano ~/.bash_profile'

alias shhh='pmset sleepnow'

### shortcuts
alias beep="echo -e '\a'"
alias k='kill %-'
alias o='open .'

### git commands
# show
alias gits='git status'
alias gitd='git diff'
alias giti='nano .gitignore'
alias gitt='git tag --list'
alias gitb='git branch --list'
alias gitl='git log'
alias gitl1='git log --pretty=oneline --abbrev-commit'
alias gitlf="git log --graph --pretty=format:'%C(yellow)%h %Cred%ad %Cblue%an%Cgreen%d %Creset%s' --date=short"

# modify
alias gpoh='git push origin head'
alias gitco='git commit'
alias gitstash='git stash save'
alias JESUSTAKETHEWHEEL='git reset --hard origin/master; git pull origin master'

# repos
gitclone () { git clone git@github.com:"$1"/"$2".git; }
export -f gitclone 1> /dev/null
gitcloneme () { gitclone "MattCCS" "$1"; }
export -f gitcloneme 1> /dev/null

grao () { git remote add origin git@github.com:"$1"/"$2".git; }
export -f grao 1> /dev/null
graome () { grao "MattCCS" "$1"; }
export -f graome 1> /dev/null

# autocorrect
alias gti='echo "Did you mean *git*?"; git'
alias gut='echo "Did you mean *git*?"; git'
alias gtu='echo "Now this is just a disgrace."'

# personal commands -- private ;)
source ~/.bash_profile_private 2> /dev/null && echo "[+] ~/.bash_profile_private" || echo "[ ] ~/.bash_profile_private"
source ~/.bash_profile_hubspot 2> /dev/null && echo "[+] ~/.bash_profile_hubspot" || echo "[ ] ~/.bash_profile_hubspot"
