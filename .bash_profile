PATH=$PATH:/usr/local/bin

### meta commands
alias reload='echo "[+] ~/.bash_profile"; source ~/.bash_profile'
alias nbp='nano ~/.bash_profile'
alias vbp='vi ~/.bash_profile'

### python
alias unit='python -m unittest'
alias unitd='python -m unittest discover'

### virtualenv
alias a='. bin/activate'
alias d='deactivate'
alias virtualenv3='virtualenv -p python3'

### mac/darwin
alias shhh='pmset sleepnow'

### shortcuts
alias beep="echo -e '\a'"
alias k='kill %-'
alias o='open .'
alias subl='open -a "Sublime Text"'

### markdown
md () { markdown "$1" > "$1".html || echo "Must `brew install markdown`!"; }
export -f md 1> /dev/null
mdo () { md "$1" && open "$1".html; }
export -f mdo 1> /dev/null

### git commands
# show
alias gits='git status'
alias gitd='git diff'
alias gitds='git diff --staged'
alias giti='nano .gitignore'
alias gitt='git tag --list'
alias gitb='git branch --list'
alias gitw='git whatchanged'
alias gitbl='git blame'

alias git_current_branch='git rev-parse --abbrev-ref HEAD'
alias gpcb='git pull origin "$(git_current_branch)"'
alias gitfe='git fetch'

alias gitlf='git log'

# special git logs
gitlog () { local pretty="$(python ~/Prefs/gitlogpretty.py "$1")"; shift; git log --pretty=format:"$pretty" "$@"; }
export -f gitlog 1> /dev/null
alias gitl="gitlog hdabs --date=short"
alias gitlg="gitlog hdabs --date=short --graph"
alias gitly="gitlog hdabs --since=1.day.ago --until=6am --all --author='Matthew Cotton' --date=short"

# modify
alias gitcom='git commit'
alias gitch='git checkout'
alias gitbr='git branch'
alias gpoh='git push origin head'
alias gpohi='git push -u origin head'
alias gitstash='git stash save'
alias gitm='git merge --no-ff'
alias gitmff='git merge --ff'
alias gitrbi='git rebase --interactive'
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

gsadd () { local user="$1"; local repo="$2"; shift; shift; git submodule add git@github.com:"$user"/"$repo".git "$@"; }
export -f gsadd 1> /dev/null
gsaddme () { local repo="$1"; shift; gsadd "MattCCS" "$repo" "$@"; }
export -f gsaddme 1> /dev/null
alias gsuir="git submodule update --init --recursive"

# autocorrect
alias gti='echo "Did you mean *git*?"; git'
alias gut='echo "Did you mean *git*?"; git'
alias gtu='echo "Now this is just a disgrace."'

# personal commands -- private ;)
source ~/.bash_profile_private 2> /dev/null && echo "[+] ~/.bash_profile_private" || echo "[ ] ~/.bash_profile_private"
source ~/.bash_profile_hubspot 2> /dev/null && echo "[+] ~/.bash_profile_hubspot" || echo "[ ] ~/.bash_profile_hubspot"
