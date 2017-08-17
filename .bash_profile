PATH=/usr/local/bin:$PATH
export PYTHONSTARTUP="$HOME/Prefs/pythonstartup.py"

alias hex='hexdump -C'
alias encoding='file -I'

# mysql
PATH=$PATH:/usr/local/mysql/bin

# twist
alias thost='twist web --path'

# register/my
PATH=$PATH:/usr/local/bin/registered
alias reg='register'
alias my='register'
alias unreg='unregister'

### meta commands
alias reload='echo "[+] ~/.bash_profile"; source ~/.bash_profile'
alias nbp='nano ~/.bash_profile'
alias vbp='vi ~/.bash_profile'
alias sbp='subl ~/.bash_profile'

### notes
alias notes='cd ~/Documents/Notes'

### Wayback Machine / Archive.org
alias wayback='wayback_machine_downloader'

### cracking
alias hc='hashcat'
alias hch='hc --help'

### Lynx/Lynxlet
alias lynx='lynx -accept_all_cookies -nopause'
WWW_HOME='http://www.google.com/'
export WWW_HOME

### python
alias p='python3'
alias pipi='pip install'
alias pipi3='pip3 install'
#alias pipil='pip install --user'
#alias pipil3='pip3 install --user'
alias pipf='pip freeze'
alias pipf3='pip3 freeze'
alias unit='python -m unittest'
alias unitd='python -m unittest discover'
alias rmpyc='find . -name \*.pyc -delete'
alias json='python -m json.tool'
#alias pip3=/usr/local/Cellar/python3/3.5.2_1/bin/pip3
alias pysh=/Users/mcotton/Code/pysh/bin/pysh

### virtualenv
alias a='. bin/activate'
alias d='deactivate'
alias virtualenv3='virtualenv -p python3'

### mac/darwin
alias shhh='pmset sleepnow'

### shortcuts
alias l='ls -al'
alias beep="echo -e '\a'"
alias k='kill %-'
alias o='open .'
alias subl='open -a "Sublime Text"'
alias iwillfindyou='find / -name'
cdd () { cd `dirname "$1"`; }; export -f cdd 1> /dev/null
alias wgeta='wget --header="Accept: text/html" --user-agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:21.0) Gecko/20100101 Firefox/21.0"'
alias curlj='curl -H "Content-Type: application/json"'

### markdown
md () { markdown "$1" > "$1".html || echo "Must `brew install markdown`!"; }; export -f md 1> /dev/null
mdo () { md "$1" && open "$1".html; }; export -f mdo 1> /dev/null

### git commands
# show
alias gitb='git branch --list'
alias gitbl='git blame'
alias gitd='git diff'
alias gitds='git diff --staged'
alias gitdl='git diff HEAD^1'
alias gits='git status'
alias gitt='git tag --list'
alias gitw='git whatchanged'
# alias git_current_branch='git rev-parse --abbrev-ref HEAD'

# special git logs
_gitlog () { local pretty="$(python ~/Prefs/gitlogpretty.py "$1")"; shift; git log --pretty=format:"$pretty" "$@"; }; export -f _gitlog 1> /dev/null
alias gitll='git log'
alias gitls="_gitlog hdabs --date=short"
alias gitlg="_gitlog hdabs --date=short --graph --all"
alias gitlgh="_gitlog hdabs --date=short --graph"
alias gitl='gitlg'
alias gitlh='gitlgh'
alias gitly="_gitlog hdabs --since=1.day.ago --until=6am --all --author='Matthew Cotton' --date=short"

# modify
#alias gitau='git add -u'
#alias gitassume='git update-index --assume-unchanged'
alias gitbr='git branch'
alias gitcom='git commit'
alias gitcoma='git commit --amend'
alias gitch='git checkout'
alias gitcherry='git cherry-pick -x'
alias gitfe='git fetch'
alias gitig='nano .gitignore'
alias gitmer='git merge --no-ff'
alias gitmerno='git merge --no-ff --no-commit'
alias gitmerff='git merge --ff'
alias gitrbi='git rebase --interactive'
alias gitstash='git stash save'
alias gitta='git tag -a'
alias gpcb='git pull'
alias gpoh='git push origin head'
alias gpoht='gpoh --tags'
alias gpohi='git push -u origin head'
alias gsuir="git submodule update --init --recursive"
alias ithinkibrokesomething='git reset --soft HEAD~1'
alias ijustbrokeeverything='git reset --hard origin/master && git pull origin master'

# repos
gitclone () { git clone git@github.com:"$1"/"$2".git; }; export -f gitclone 1> /dev/null
gitcloneme () { gitclone "MattCCS" "$1"; }; export -f gitcloneme 1> /dev/null

grao () { git remote add origin git@github.com:"$1"/"$2".git; }; export -f grao 1> /dev/null
graome () { grao "MattCCS" "$1"; }; export -f graome 1> /dev/null

gsadd () { local user="$1"; local repo="$2"; shift 2; git submodule add git@github.com:"$user"/"$repo".git "$@"; }; export -f gsadd 1> /dev/null
gsaddme () { local repo="$1"; shift; gsadd "MattCCS" "$repo" "$@"; }; export -f gsaddme 1> /dev/null

# autocorrect
alias gti='echo "Did you mean *git*?"; git'
alias gut='echo "Did you mean *git*?"; git'
alias gtu='echo "Now this is just a disgrace."'

# personal commands -- private ;)
alias nbpp='nano ~/.bash_profile_private'
alias sbpp='subl ~/.bash_profile_private'
alias nbpr='nano ~/.bash_profile_racap'
alias sbpr='subl ~/.bash_profile_racap'
source ~/.bash_profile_private 2> /dev/null && echo "[+] ~/.bash_profile_private"
source ~/.bash_profile_hubspot 2> /dev/null && echo "[+] ~/.bash_profile_hubspot"
source ~/.bash_profile_racap 2> /dev/null && echo "[+] ~/.bash_profile_racap"

# t () { eval $@; }

_gitkey () { local key="$1"; shift; eval 'GIT_SSH_COMMAND="ssh -i ~/.ssh/$key"' $@; }; export -f gitkey 1> /dev/null
alias gitkey2='_gitkey id2_rsa'

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
