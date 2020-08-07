PATH=$PATH:/usr/local/bin
PATH=$PATH:/Users/matt/Library/Python/3.7/bin
PATH=$PATH:/Users/matt/Library/Python/3.8/bin
# export PYTHONSTARTUP="$HOME/Prefs/pythonstartup.py"

noerr='2>/dev/null '

########################
# EXPORTS
export LIBREOFFICE="$HOME/Applications/LibreOffice.app"

########################
# NORTHEASTERN
sax () {
    saxon_path='/Users/matt/Documents/CLASS_FOLDERS/Graduate/Year 2/Summer 2020/Database Management Systems/Homework/HW5/Java stuff/SaxonHE10-1J'
    java -cp "$saxon_path/saxon-he-10.1.jar" net.sf.saxon.Transform \
        -s:"$1" \
        -xsl:"$2" \
        -o:"$2.out.html" \
    && open "$2.out.html"
}; export -f sax 1> /dev/null
saxon () {
    saxon_path='/Users/matt/Documents/CLASS_FOLDERS/Graduate/Year 2/Summer 2020/Database Management Systems/Homework/HW5/Java stuff/SaxonHE10-1J'
    base="$1"
    if [[ "$1"  =~ .*\.xml$ ]] || [[ "$1" =~ .*\.xsl$ ]]; then
        base="${${1}:0:-4}"
    fi
    java -cp "$saxon_path/saxon-he-10.1.jar" net.sf.saxon.Transform \
        -s:"$base.xml" \
        -xsl:"$base.xsl" \
        -o:"$base.out.html" \
    && open "$base.out.html"
}; export -f saxon 1> /dev/null

# helpers
split-on-n () {
    echo "first: ${${1}:0:3}"
    echo "-rest: ${${1}:3}"
    echo "last: ${${1}: -3}"
    echo "-rest: ${${1}:0:-3}"
}; export -f split-on-n 1> /dev/null

stem () {
    filename=$(basename -- "$1")
    stem_="${filename%.*}"
    echo $stem_
}; export -f stem 1> /dev/null

ext () {
    filename=$(basename -- "$1")
    extension_="${filename##*.}"
    echo $extension_
}; export -f ext 1> /dev/null

noext () {
    # FIXME: requires abs path...
    echo "`dirname $1`/`stem $1`"
}; export -f noext 1> /dev/null

# OpenSSL / LibreSSL
alias systemssl='/usr/bin/openssl '
alias libressl='/usr/local/Cellar/libressl/2.9.2/bin/openssl '
alias openssl='libressl '

# mysql
PATH=$PATH:/usr/local/mysql/bin

# twist
alias thost='twist web --path'

# register
PATH=$PATH:/usr/local/bin/registered
alias reg='register'
alias unreg='unregister'

# Dwarf Fortress
alias dfort='dwarf-fortress & '  # brew cask

### meta commands
alias reload='source ~/.bash_profile && echo "[+] ~/.bash_profile"'  # WARNING - KILLS CURRENT VIRTUALENV!
alias nbp='nano ~/.bash_profile'
alias vbp='vi ~/.bash_profile'
alias sbp='subl ~/.bash_profile'
alias snet='subl ~/.netrc'

### network
alias listnetworks='networksetup -listallhardwareports'

### notes
alias notes='cd ~/Documents/Notes'

### Wayback Machine / Archive.org
alias wayback='wayback_machine_downloader'

### cracking
alias hc='hashcat'
alias hch='hc --help'

### cropping
crop () {
    file="$1"
    x="$2"
    y="$3"
    w="$4"
    h="$5"
    ffmpeg -i "$file" -vf "crop='$w:$h:$x:$y'" "$file-crop.mp4"
}; export -f crop 1> /dev/null
crop-square-left () { ffmpeg -i "$1" -vf "crop='min(iw,ih):min(iw,ih):0:0'" "`dirname $1`/left-`basename $1`"; }; export -f crop-square-left 1> /dev/null
crop-square-center () { ffmpeg -i "$1" -vf "crop='min(iw,ih):min(iw,ih):max((iw-ih)/2,0):max((ih-iw)/2,0)'" "`dirname $1`/center-`basename $1`"; }; export -f crop-square-center 1> /dev/null
crop-square-right () { ffmpeg -i "$1" -vf "crop='min(iw,ih):min(iw,ih):max(iw-ih,0):max(ih-iw,0)'" "`dirname $1`/right-`basename $1`"; }; export -f crop-square-right 1> /dev/null

### screen capture
devices () { ffmpeg -f avfoundation -list_devices true -i ""; }; export -f devices 1> /dev/null
record-air () { record-macos "30" "1440" "900" "$1" "$2"; }; export -f record-air 1> /dev/null
record-macos () {
    ffmpeg -f avfoundation -r "$1" -video_size "$2x$3" -i "$4:$5" -pix_fmt yuv420p "rec.mov"
}; export -f record-macos 1> /dev/null

## other ffmpeg
vid-to-gif () {
    ffmpeg -i "$1" \
    -filter_complex 'fps=30,scale=-1:-1:flags=lanczos,split [o1] [o2];[o1] palettegen [p]; [o2] fifo [o3];[o3] [p] paletteuse' \
    "$1.gif"
}; export -f vid-to-gif 1> /dev/null
vid-to-mp4 () { ffmpeg -i "$1" "$1.mp4"; }; export -f vid-to-mp4 1> /dev/null
gif-to-mp4 () { ffmpeg -i "$1" -movflags faststart -pix_fmt yuv420p -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" "$1.mp4"; }; export -f gif-to-mp4 1> /dev/null
frames-to-mp4 () {
    # ARG 1: 60
    # ARG 2: 256x256
    # ARG 3: "./dir/image%05d.png"
    fps="$1"
    WxH="$2"
    filenamePattern="$3"
    ffmpeg -r "$fps" -f image2 -s "$WxH" -i "$filenamePattern" -vcodec libx264 -crf 25 -pix_fmt yuv420p out.mp4
}; export -f frames-to-mp4 1> /dev/null
mux-video-audio () { ffmpeg -i "$1" -i "$2" -c copy -map 0:0 -map 1:1 -shortest "$1-mux.mp4"; }; export -f mux-video-audio 1> /dev/null
stabilize () {
    vid="$1"
    ffmpeg -i "$vid" -vf vidstabdetect=shakiness=10:accuracy=15 -f null - \
    && ffmpeg -i "$vid" -vf vidstabtransform=zoom=5:smoothing=30 -vcodec libx264 -preset slow -tune film -crf 20 -an "$vid-stabilized.mp4" \
    && rm transforms.trf
}; export -f stabilize 1> /dev/null
stabdefault () {
    vid="$1"
    ffmpeg -i "$vid" -vf vidstabdetect=shakiness=5:accuracy=15:stepsize=6:mincontrast=0.3:show=2 -y dummy.mp4 \
    && ffmpeg -i "$vid" -vf "scale=trunc((iw*1.15)/2)*2:trunc(ow/a/2)*2" -y scaled.mp4 \
    && ffmpeg -i scaled.mp4 -vf vidstabtransform=smoothing=30:input="transforms.trf":interpol=linear:crop=black:zoom=-15:optzoom=0,unsharp=5:5:0.8:3:3:0.4 -y stabilized-output.mp4 \
    && rm dummy.mp4 scaled.mp4 transforms.trf
}; export -f stabdefault 1> /dev/null
compare () {
    ffmpeg -i "$1" -i "$2" -filter_complex hstack "`basename $1`-vs-`basename $2`.mp4"
}; export -f compare 1> /dev/null
compare3 () {
    ffmpeg -i "$1" -i "$2" -i "$3" -filter_complex hstack=3 "`basename $1`-vs-`basename $2`-vs-`basename $3`.mp4"
}; export -f compare3 1> /dev/null
compare3v () {
    ffmpeg -i "$1" -i "$2" -i "$3" -filter_complex vstack=3 "`basename $1`-vs-`basename $2`-vs-`basename $3`.mp4"
}; export -f compare3v 1> /dev/null
scale () {
    ffmpeg -i "$1" -vf scale="$2:$3" "$1-$2x$3.mp4"
}; export -f scale 1> /dev/null
upscale-letterbox () {
    w="$2"
    h="$3"
    ffmpeg -i "$1" \
    -vf "scale=$w:$h:force_original_aspect_ratio=decrease,pad=$w:$h:(ow-iw)/2:(oh-ih)/2" \
    "`noext $1`-up${w}x${h}.`ext $1`"
}; export -f upscale-letterbox 1> /dev/null
trim-video () {
    file="$1"
    start="$2"
    duration="$3"
    ffmpeg -ss "$start" -i "$file" -t "$duration" -c copy "$file-trim-temp.mp4" && \
    ffmpeg -i "$file-trim-temp.mp4" -to "$duration" "$file-trim-$start-$duration.mp4" && \
    rm "$file-trim-temp.mp4"
}; export -f trim-video 1> /dev/null

face () {
    deactivate
    source /Users/matt/Repos/GoodRepos/first-order-model/venv/bin/activate \
        && python3 /Users/matt/Repos/GoodRepos/first-order-model/demo.py \
        --cpu \
        --config /Users/matt/Repos/GoodRepos/first-order-model/config/vox-256.yaml \
        --source_image "$1" \
        --driving_video "$2" \
        --checkpoint /Users/matt/Repos/GoodRepos/first-order-model/checkpoints/vox-cpk.pth.tar \
        --relative \
        --adapt_scale \
        --result_video "`basename $1`-`basename $2`"
    deactivate
}; export -f face 1> /dev/null

### Lynx/Lynxlet
alias lynx='lynx -accept_all_cookies -nopause'
WWW_HOME='http://www.google.com/'
export WWW_HOME

### python
alias p='python3.7 '
alias pver='p --version'
alias pdoc='pydoc -w ./'
# (pip2 provided by brew-python2)
# (pip3 provided by brew-python3)
alias pipi2='pip2 install'
alias pipi3='pip3.7 install'
alias pipir2='pip2 install -r requirements.txt'
alias pipir3='pip3.7 install -r requirements.txt'
alias pipf2='pip2 freeze'
alias pipf3='pip3.7 freeze'
alias pipfr2='pip2 freeze > requirements.txt'
alias pipfr3='pip3.7 freeze > requirements.txt'
pipit2 () { PYTHONUSERBASE="$2" pip2 install "$1";; }; export -f pipit2 1> /dev/null  # "pipit = PIP Install Target"
pipit3 () { PYTHONUSERBASE="$2" pip3.7 install "$1";; }; export -f pipit3 1> /dev/null

alias pip='pip3.7'  # <-- personal favorite
alias pipi='pipi3'  # <-- personal favorite
alias pipir='pipir3'  # <-- personal favorite
alias pipf='pipf3'  # <-- personal favorite
alias pipfr='pipfr3'  # <-- personal favorite
alias pipit='pipit3'  # <-- personal favorite

alias unit='python -m unittest'
alias unitd='python -m unittest discover'
alias pysh=/Users/mcotton/Code/pysh/bin/pysh

_pslice () { python -c "import sys;a,b,c=[int(i) or None for i in sys.argv[1:]];print(sys.stdin.read().rstrip('\n')[slice(a,b,c)])" "$1" "$2" "$3";; }; export -f _pslice 1> /dev/null
pslice () { _pslice "${1:-0}" "${2:-0}" "${3:-0}";; }; export -f pslice 1> /dev/null

_psplit () { python -c "import sys;a,b=sys.argv[1:];a=a or None;b=int(b) or -1;print(' '.join(sys.stdin.read().rstrip('\n').split(a,b)))" "$1" "$2";; }; export -f _psplit 1> /dev/null
psplit () { _psplit "${1:-}" "${2:-0}";; }; export -f psplit 1> /dev/null

_preplace () { python -c "import sys;a,b,c=sys.argv[1:];c=int(c) or -1;print(sys.stdin.read().rstrip('\n').replace(a,b,c))" "$1" "$2" "$3";; }; export -f _preplace 1> /dev/null
preplace () { _preplace "${1:-}" "${2:-}" "${3:-0}";; }; export -f preplace 1> /dev/null

# protip:  chain these ^ with "while read _ _ _"

alias pfirst="head -n "
alias plast="tail -n "
pbetween () { pfirst "$2" | plast $(($2 - $1));; }; export -f pbetween 1> /dev/null

autoclick() {
    while (true); do doubleclick; done
}; export -f autoclick 1>/dev/null
click() {
    /Users/matt/AppleScripts/MouseTools -leftClick \
    && /Users/matt/AppleScripts/MouseTools -releaseMouse
}; export -f click 1>/dev/null
doubleclick() {
    /Users/matt/AppleScripts/MouseTools -doubleLeftClick \
    && /Users/matt/AppleScripts/MouseTools -releaseMouse
}; export -f doubleclick 1>/dev/null


### virtualenv
# a () { source ./"$1"/bin/activate; }; export -f a 1>/dev/null
a () { source "${1:-.}/bin/activate"; }; export -f a 1>/dev/null
alias d='deactivate'
alias virtualenv2='virtualenv -p python2'
alias virtualenv3='virtualenv -p python3.7'
alias pvenv2='python2 -m venv'
alias pvenv3.7='python3.7 -m venv'
alias pvenv3.8='python3.8 -m venv'
alias pvenv='p -m venv'
alias venv='pvenv' # <-- personal favorite

alias vv='venv venv'
alias av='a venv'
alias dv='d'

### mac/darwin
alias shhh='pmset displaysleepnow'
alias deepsleep='pmset sleepnow'

### shortcuts
alias l='ls -al'
alias k='kill %-'
alias o='open .'
alias subl='open -a "Sublime Text"'
alias osaj='osascript -l JavaScript '
alias bin='xxd -b'
alias hex='hexdump -C'
alias hexf='open -a "Hex Fiend"'
alias json='python -m json.tool'
alias rmpyc='find . -name \*.pyc -delete'
alias encoding='file -I'
alias beep="echo -e '\a'"

### youtube
yt () {
    youtube-dl -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]" "$1" --no-check-certificate
}; export -f yt 1> /dev/null
yta () {
    youtube-dl -f "bestaudio[ext=m4a]" "$1" --no-check-certificate
}; export -f yta 1> /dev/null
ytd () {
    youtube-dl "$1" --no-check-certificate
}; export -f ytd 1> /dev/null

refreshanaconda () {
    ps ax | grep anaconda | grep jsonserver | awk '{print $1}' | \
    while read pid; do
        echo "Killing anaconda jsonserver: $pid"
        kill $pid
    done
}; export -f refreshanaconda 1> /dev/null

alias iwillfindyou='find / -name'
cdd () { cd "`dirname "$1"`";; }; export -f cdd 1> /dev/null
alias wgeta='wget --header="Accept: text/html" --user-agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:21.0) Gecko/20100101 Firefox/21.0"'
alias curlj='curl -H "Content-Type: application/json"'

### markdown
md () { markdown "$1" > "$1".html || echo "Must `brew install markdown`!";; }; export -f md 1> /dev/null
mdo () { md "$1" && open "$1".html;; }; export -f mdo 1> /dev/null

### ssh stuff
alias sshno="ssh -i ~/.ssh/id_rsa_nopass "
addpub () { cat ~/.ssh/"$1.pub" | ssh "$2" "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys";; }; export -f addpub 1> /dev/null

deploy () { scp -r $1 $2; }; export -f deploy 1> /dev/null


########################################
#             git commands             #
########################################

# global settings
# ssh-add ~/.ssh/id_rsa  # <--- WARNING:  INCOMPATIBLE WITH _gitkey COMMAND!  (unless you add both)
git config --global credential.helper cache  # https://stackoverflow.com/questions/5343068/is-there-a-way-to-skip-password-typing-when-using-https-on-github
git config --global core.pager 'less -S'  # truncate lines that go too long

# info
alias gitpath='git rev-parse --show-toplevel'
alias gitname='basename `git rev-parse --show-toplevel`'

# show
alias gitb='git branch --list'  # git branch(es)
alias gitbl='git blame'
alias gitd='git diff'
alias gitds='git diff --staged'
alias gitdl='git diff HEAD~1'  # git diff last
alias gits='git status'
alias gitsh='git show '
alias gitt='git tag --list'  # git tag(s)
alias gitw='git whatchanged'
alias git_current_branch='git rev-parse --abbrev-ref HEAD'

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
gitchi () { git checkout -b "$1" "origin/$1";; }; export -f gitchi 1> /dev/null
alias gitcherry='git cherry-pick -x'
alias gitfe='git fetch'
alias gitfea='git fetch --all'
alias gitfeap='git fetch --all --prune'
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
alias gitp='git pull'
alias gitpcb='git pull origin "$(git_current_branch)"'
alias gitpoh='git push origin head'
alias gitpoht='git push origin head --tags'
alias gitpohi='git push -u origin head'  # "initial"
alias gitsuir="git submodule update --init --recursive"
# alias gitrmbranchlocal="git branch -D "
# alias gitrmbranchremote="git push origin --delete "
gitsuto () { git branch --set-upstream-to="origin/$1" "$2";; }; export -f gitsuto 1> /dev/null
alias ithinkibrokesomething='git reset --soft HEAD~1'
alias ijustbrokeeverything='git reset --hard origin/master && git pull origin master'

alias gpcb='gitpcb'  # <-- frequent usage
alias gpoh='gitpoh'  # <-- frequent usage
alias gpoht='gitpoht'  # <-- frequent usage

# repos
gitclone () { git clone git@github.com:"$1"/"$2".git;; }; export -f gitclone 1> /dev/null
gitcloneme () { gitclone "MattCCS" "$1";; }; export -f gitcloneme 1> /dev/null

grao () { git remote add origin git@github.com:"$1"/"$2".git;; }; export -f grao 1> /dev/null
graome () { grao "MattCCS" "$1";; }; export -f graome 1> /dev/null

gsadd () { local user="$1"; local repo="$2"; shift 2; git submodule add git@github.com:"$user"/"$repo".git "$@";; }; export -f gsadd 1> /dev/null
gsaddme () { local repo="$1"; shift; gsadd "MattCCS" "$repo" "$@";; }; export -f gsaddme 1> /dev/null

# autocorrect
alias gti='echo "Did you mean *git*?"; git'
alias gut='echo "Did you mean *git*?"; git'
alias gtu='echo "Now this is just a disgrace."'

# personal commands -- private ;)
alias nbpp='nano ~/.bash_profile_private'
alias sbpp='subl ~/.bash_profile_private'
alias nbpr='nano ~/.bash_profile_racap'
alias sbpr='subl ~/.bash_profile_racap'
alias nbprp='nano ~/.bash_profile_racap_personal'
alias sbprp='subl ~/.bash_profile_racap_personal'
FILE=~/.bash_profile_private && test -f $FILE && source $FILE && echo "[+] ~/.bash_profile_private"
FILE=~/.bash_profile_hubspot && test -f $FILE && source $FILE && echo "[+] ~/.bash_profile_hubspot"
FILE=~/.bash_profile_racap && test -f $FILE && source $FILE && echo "[+] ~/.bash_profile_racap"

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
alias gitkey2='_gitkey id_rsa_github_mattccs '

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
