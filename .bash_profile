PATH=/usr/local/bin:$PATH
export PYTHONSTARTUP="$HOME/Prefs/pythonstartup.py"

noerr='2>/dev/null '

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
alias reload='echo "[+] ~/.bash_profile"; source ~/.bash_profile'  # WARNING - KILLS CURRENT VIRTUALENV!
alias nbp='nano ~/.bash_profile'
alias vbp='vi ~/.bash_profile'
alias sbp='subl ~/.bash_profile'
alias snet='subl ~/.netrc'

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
# (pip2 provided by brew-python2)
# (pip3 provided by brew-python3)
alias pipi2='pip2 install'
alias pipi3='pip3 install'
alias pipir2='pip2 install -r requirements.txt'
alias pipir3='pip3 install -r requirements.txt'
alias pipf2='pip2 freeze'
alias pipf3='pip3 freeze'
alias pipfr2='pip2 freeze > requirements.txt'
alias pipfr3='pip3 freeze > requirements.txt'

alias pip='pip3'  # <-- personal favorite
alias pipi='pipi3'  # <-- personal favorite
alias pipir='pipir3'  # <-- personal favorite
alias pipf='pipf3'  # <-- personal favorite
alias pipfr='pipfr3'  # <-- personal favorite

alias unit='python -m unittest'
alias unitd='python -m unittest discover'
alias pysh=/Users/mcotton/Code/pysh/bin/pysh

_pslice () { python -c "import sys;a,b,c=[int(i) or None for i in sys.argv[1:]];print(sys.stdin.read().rstrip('\n')[slice(a,b,c)])" "$1" "$2" "$3"; }; export -f _pslice 1> /dev/null
pslice () { _pslice "${1:-0}" "${2:-0}" "${3:-0}"; }; export -f pslice 1> /dev/null

_psplit () { python -c "import sys;a,b=sys.argv[1:];a=a or None;b=int(b) or -1;print(' '.join(sys.stdin.read().rstrip('\n').split(a,b)))" "$1" "$2"; }; export -f _psplit 1> /dev/null
psplit () { _psplit "${1:-}" "${2:-0}"; }; export -f psplit 1> /dev/null

_preplace () { python -c "import sys;a,b,c=sys.argv[1:];c=int(c) or -1;print(sys.stdin.read().rstrip('\n').replace(a,b,c))" "$1" "$2" "$3"; }; export -f _preplace 1> /dev/null
preplace () { _preplace "${1:-}" "${2:-}" "${3:-0}"; }; export -f preplace 1> /dev/null

# protip:  chain these ^ with "while read _ _ _"

### virtualenv
alias a='. bin/activate'
alias d='deactivate'
alias virtualenv2='virtualenv -p python2'
alias virtualenv3='virtualenv -p python3'
alias venv='virtualenv3' # <-- personal favorite

### mac/darwin
alias shhh='pmset sleepnow'

### shortcuts
alias l='ls -al'
alias k='kill %-'
alias o='open .'
alias subl='open -a "Sublime Text"'
alias hex='hexdump -C'
alias hexf='open -a "Hex Fiend"'
alias json='python -m json.tool'
alias rmpyc='find . -name \*.pyc -delete'
alias encoding='file -I'
alias beep="echo -e '\a'"

refreshanaconda () {
    ps ax | grep anaconda | grep jsonserver | awk '{print $1}' | \
    while read pid; do
        echo "Killing anaconda jsonserver: $pid"
        kill $pid
    done
}; export -f refreshanaconda 1> /dev/null

alias iwillfindyou='find / -name'
cdd () { cd `dirname "$1"`; }; export -f cdd 1> /dev/null
alias wgeta='wget --header="Accept: text/html" --user-agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:21.0) Gecko/20100101 Firefox/21.0"'
alias curlj='curl -H "Content-Type: application/json"'

### markdown
md () { markdown "$1" > "$1".html || echo "Must `brew install markdown`!"; }; export -f md 1> /dev/null
mdo () { md "$1" && open "$1".html; }; export -f mdo 1> /dev/null

### ssh stuff
addpub () { cat ~/.ssh/id_rsa.pub | ssh "$1@$2" "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"; }; export -f addpub 1> /dev/null

### git commands
# global settings
# ssh-add ~/.ssh/id_rsa  # <--- WARNING:  INCOMPATIBLE WITH _gitkey COMMAND!  (unless you add both)
git config --global credential.helper cache  # https://stackoverflow.com/questions/5343068/is-there-a-way-to-skip-password-typing-when-using-https-on-github
git config --global core.pager 'less -S'  # truncate lines that go too long

# show
alias gitb='git branch --list'  # git branch(es)
alias gitbl='git blame'
alias gitd='git diff'
alias gitds='git diff --staged'
alias gitdl='git diff HEAD~1'  # git diff last
alias gits='git status'
alias gitt='git tag --list'  # git tag(s)
alias gitw='git whatchanged'
# alias git_current_branch='git rev-parse --abbrev-ref HEAD'

########################################
#           special git logs           #
########################################
#            log = default log, full commit messages
#         pretty = one line, all metadata (helper function)
#           flat = no branches
#           here = only branches leading to here
#            all = everything - every branch/stash/dead-end/etc
#
########################################
#               modifiers              #
########################################
#      yesterday = flat, since yesterday
#      last week = flat, since last week
#     last month = flat, since last month
#
#            +me = only by me
########################################

alias gitlg='git log '  # log
alias _gitlp='git log --date=short --pretty=format:"%C(yellow)%h %Cred%ad %Cblue%an %C(auto)%d %Creset%s" '  # pretty
alias gitlf='_gitlp '  # flat
alias gitlh='_gitlp --graph '  # here
alias gitla='_gitlp --graph --all '  # all

alias y='--since=1.day.ago '
alias lw='--since=last.week '
alias lm='--since=last.month '
alias fp='--first-parent '

alias me='--author="$(git config user.name)" '

alias gitl='gitlh '  # <-- personal favorite

gitaheadbehind () {
    [ -z $1 ] && remote="master" || remote=$1
    git for-each-ref --format="%(refname:short)" refs/heads | \
    while read local; do
        git rev-list --left-right ${local}...${remote} -- 2>/dev/null >/tmp/git_upstream_status_delta || continue
        [ "$local" = "$remote" ] && continue

        AHEAD=$(grep -c '^<' /tmp/git_upstream_status_delta)
        BEHIND=$(grep -c '^>' /tmp/git_upstream_status_delta)

        if [[ "$AHEAD" -eq "0" && "$BEHIND" -eq "0" ]]; then
            TEXT="is up-to-date with"
        elif [[ "$AHEAD" -eq "0" ]]; then
            TEXT="(\e[92mbehind $BEHIND\e[0m)"
        elif [[ "$BEHIND" -eq "0" ]]; then
            TEXT="(\e[91mahead $AHEAD\e[0m)"
        else
            TEXT="(\e[93mahead $AHEAD, behind $BEHIND\e[0m)"
        fi

        echo "$local $TEXT $remote"
    done
}; export -f gitaheadbehind 1> /dev/null

# modify
alias gitaa='git add .'
alias gitau='git add -u'
alias gitbr='git branch'
alias gitcom='git commit'
alias gitcoma='git commit --amend'
alias gitch='git checkout'
alias gitcherry='git cherry-pick -x'
alias gitfe='git fetch'
alias gitfea='git fetch --all'
alias gitig='nano .gitignore'
alias gitmer='git merge --no-ff'
alias gitmersq='git merge --squash'
alias gitmerno='git merge --no-ff --no-commit'
alias gitmerff='git merge --ff'
alias gitrb='git rebase'
alias gitrbi='git rebase --interactive'
alias gitstash='git stash save'
alias gitta='git tag -a'
#alias gituntrack='git update-index --assume-unchanged'
alias gitpcb='git pull'
# alias gpcb='git pull origin "$(git_current_branch)"'
alias gitpoh='git push origin head'
alias gitpoht='git push origin head --tags'
alias gitpohi='git push -u origin head'
alias gitsuir="git submodule update --init --recursive"
alias ithinkibrokesomething='git reset --soft HEAD~1'
alias ijustbrokeeverything='git reset --hard origin/master && git pull origin master'

alias gpcb='gitpcb'  # <-- frequent usage
alias gpoh='gitpoh'  # <-- frequent usage
alias gpoht='gitpoht'  # <-- frequent usage

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

_gitkey () {
    local key="$1"
    shift 2  # remove the "git" from the now-expanded passed command
    git -c core.sshCommand="ssh -i ~/.ssh/$key" $@
}; export -f _gitkey 1> /dev/null

_gitkeyexperiment () {
    local key="$1"
    local name="$2"
    local email="$3"
    shift 4  # remove the "git" from the now-expanded passed command
    git -c core.sshCommand="ssh -i ~/.ssh/$key" -c user.name="$name" -c user.email="$email" $@
}; export -f _gitkeyexperiment 1> /dev/null

alias gitkey1='_gitkey id_rsa '
alias gitkey2='_gitkey id2_rsa '

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# EXPANSION EXPERIMENTS:
alias test_echo='echo 1'
alias test_noexp='test_echo'
alias test_yesexp='test_echo '
alias test_yesexp_chained='test_yesexp test_yesexp'
# Tests:
#   No expansion:
#       test_noexp test_echo -> "1 test_echo"
#       test_noexp test_noexp -> "1 test_noexp"
#       test_noexp test_yesexp -> "1 test_yesexp"
#
#   Yes expansion:
#       test_yesexp test_echo -> "1 echo 1"  (1st-level)
#       test_yesexp test_noexp -> "1 echo 1"  (2nd-level)
#       test_yesexp test_yesexp -> "1 echo 1"  (2nd-level)
#       test_yesexp test_yesexp test_yesexp -> "1 echo 1 echo 1"  (3rd-level)
#       test_yesexp_chained test_yesexp_chained -> "1 echo 1 echo 1 echo 1"  (4th-level)