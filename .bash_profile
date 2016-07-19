
### meta commands
alias reload='source ~/.bash_profile'
alias nbp='nano ~/.bash_profile'

alias shhh='pmset sleepnow'

### shortcuts
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

# modify
alias gitstash='git stash save'
alias gpoh='git push origin head'
alias JESUSTAKETHEWHEEL='git reset --hard origin/master; git pull origin master'

# repos
gitclone () { git clone git@github.com:"$1"/"$2".git; }
export -f gitclone
gitcloneme () { gitclone "MattCCS" "$1"; }
export -f gitcloneme

grao () { git remote add origin git@github.com:"$1"/"$2".git; }
export -f grao
graome () { grao "MattCCS" "$1"; }
export -f graome

# correct
alias gti='echo "Did you mean *git*?"; git'
alias gut='echo "Did you mean *git*?"; git'
alias gtu='echo "Now this is just a disgrace."'

# hubspot commands -- private ;)
source ~/.bash_profile_hubspot
