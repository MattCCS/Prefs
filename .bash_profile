PATH=$PATH:/usr/local/bin
# PATH=$PATH:/Users/matt/Library/Python/3.9/bin
PATH=$PATH:/Users/matt/Library/Python/3.8/bin
PATH=$PATH:/Users/matt/Library/Python/3.7/bin
# PATH="$PATH:/usr/local/opt/python@3.8/bin/python3"
# PATH="$PATH:/usr/local/opt/python@3.8/bin/pip3"
PATH="$PATH:/usr/local/opt/python@3.8/bin/"
# export PYTHONSTARTUP="$HOME/Prefs/pythonstartup.py"
PATH="/usr/local/sbin:$PATH"

noerr='2>/dev/null '

PAGER="less -S"

# oh-my-zsh
# FILE=~/.zshrc && test -f $FILE && source $FILE && echo "[+] ~/.zshrc"
if [ ! -z "$ZSH_NAME" ]; then
    unalias -m '*'
    unalias -m g
    echo "[+] Unaliased ZSH items"
fi

########################
# EXPORTS
export LIBREOFFICE="$HOME/Applications/LibreOffice.app"

########################
# S
alias envs="aws-vault list"
alias staging="aws-vault exec staging "

alias kk="kubectl "
alias klist="kubectl get pods -o wide "
kon () {
    pod="$1"; shift
    kk exec --stdin --tty "$pod" -- "$@"
}; export -f kon 1> /dev/null
kdjango () {
    kon "$1" python manage.py shell_plus
}; export -f kdjango 1> /dev/null
kdb () {
    kon "$1" python manage.py dbshell
}; export -f kdb 1> /dev/null
kbash () {
    kon "$1" /bin/bash
}; export -f kbash 1> /dev/null
kdiagram () {
    models=${2:-"Organization,Membership,User,Service,OrgService,ServiceSetting,Identity"}
    kon "$1" python manage.py graph_models -a -I "$models"
}; export -f kdiagram 1> /dev/null
alias kerd="kdiagram "

dot-to-png () {
    dot -Tpng "$1" -o "$1.png" \
        && open "$1.png"
}; export -f dot-to-png 1> /dev/null

erd-diagram () {
    # models=${1:-"Organization,Membership,User,Service,OrgService,ServiceSetting"}
    models=${1:-"Organization,Membership,User,Token,Actor,Service,OrgService,ServiceSetting,Identity,Group,Permission,SlackChannelMap,DataHandle"}
    # docker-compose run --rm queuer python manage.py graph_models -a -I "$models" --output output.dot \
    docker-compose run --rm queuer python manage.py graph_models -a -I "$models" | paftern 6 | pbeforen 1 > output.dot \
        && dot -Tpng output.dot -o output.png \
        && open output.png
}; export -f erd-diagram 1> /dev/null

prep-deploy () {
    echo "[.] Activating sym-deploy repo" \
        && osascript -l AppleScript ~/home/my-repos/AppleScripts/prep-deploy.scpt
}; export -f prep-deploy 1> /dev/null

# # asdf
# # . $(brew --prefix asdf)/asdf.sh  # Fixes: https://github.com/asdf-vm/asdf/issues/607 ; encountered after laptop/setup
# alias asd='. $(brew --prefix asdf)/asdf.sh && asdf '  # Fixes: https://github.com/asdf-vm/asdf/issues/607 ; encountered after laptop/setup


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

# MediaMan helpers
mmo () {
    # "MediaMan offload"
    service="$1"; shift;
    for f in $@; do
        hash="`xxh64sum $f | head -c 16`"
        echo "mm://xxh64:$hash" > "$f.mm"
        mm "$service" put "$f" && mv "$f" ~/.Trash
    done
}; export -f mmo 1> /dev/null

# helpers
split-on-n () {
    echo "first: ${${1}:0:3}"
    echo "-rest: ${${1}:3}"
    echo "last: ${${1}: -3}"
    echo "-rest: ${${1}:0:-3}"
}; export -f split-on-n 1> /dev/null

stem () {
    filename=$(basename -- "$1")
    echo "${filename%.*}"
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

mvsafe () {
    src="$1"
    dstdir="$2"

    fname="`basename $src`"
    fstem="`stem $fname`"
    fext="`ext $fname`"

    COUNTER=1
    dst="$dstdir/$fname"
    while [[ -f "$dst" ]]; do
        COUNTER=$((COUNTER + 1))
        dst="$dstdir/$fstem $COUNTER.$fext"
    done

    mv "$src" "$dst"
}; export -f mvsafe 1> /dev/null

rextension () {
    for f in "$@"; do
        guess="`file -b $f`"
        if [[ $guess == "JPEG image data"* ]]; then
            ext="jpg"
        elif [[ $guess == "PNG image data"* ]]; then
            ext="png"
        elif [[ $guess == "GIF image data"* ]]; then
            ext="gif"
        elif [[ $guess == "ISO Media, Apple QuickTime movie"* ]]; then
            ext="mov"
        elif [[ $guess == "ISO Media, Apple iTunes ALAC/AAC-LC"* ]]; then
            ext="m4a"
        else
            echo "Unknown: $f (`file -b $f`)"
            continue
        fi

        if [[ "$f" == *".$ext" ]]; then
            continue
        fi

        mv "$f" "$f.$ext"
    done
}; export -f rextension 1> /dev/null

# diffs and patches
alias diff-patch='diff -Naru '  # https://unix.stackexchange.com/questions/162131/is-this-a-good-way-to-create-a-patch

# OpenSSL / LibreSSL
alias systemssl='/usr/bin/openssl '
alias libressl='/usr/local/Cellar/libressl/3.3.3/bin/openssl '
# alias libressl='/usr/local/Cellar/libressl/3.2.2/bin/openssl '
# alias libressl='/usr/local/Cellar/libressl/2.9.2/bin/openssl '
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
alias s.='subl .'

### network
alias listnetworks='networksetup -listallhardwareports'

### notes
alias notes='cd ~/Documents/Notes'

### Wayback Machine / Archive.org
alias wayback='wayback_machine_downloader'

### cracking
alias hc='hashcat'
alias hch='hc --help'

### File archiving/compression
# files/folders
alias xzip='tar -Jcvf '  # FOO.tar.xz
alias bzip='tar -jcvf '  # FOO.tar.bz
# alias gzip  # taken, just use tar -zcvf
# images
alias pngcomp='pngcrush -rem alla -nofilecheck -reduce -m 7 '

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

### concatenation
concat-videos () {
    # Requires ffmpeg
    # Files must be .mp4
    # TODO(mcotton): This fails if framerates mismatch!
    vid1="$1"
    vid2="$2"

    vid1stem=`stem ${vid1}`
    vid2stem=`stem ${vid2}`
    outname="${vid1stem}_${vid2stem}.mp4"

    echo "[ ] Concatenating `basename $vid1` and `basename $vid2` ..."

    mkdir -p temp
    cp "${vid1}" temp
    cp "${vid2}" temp
    cd temp

    vid1stemwitheescapedspaces=${vid1stem//" "/"\\\\ "}
    vid2stemwitheescapedspaces=${vid2stem//" "/"\\\\ "}
    echo "file ${vid1stemwitheescapedspaces}.mp4" >> concat.txt
    echo "file ${vid2stemwitheescapedspaces}.mp4" >> concat.txt
    ffmpeg -f concat -safe 0 -i concat.txt -c copy "${outname}" -loglevel error
    rm concat.txt

    cd ..
    cp "temp/${outname}" .
    rm -r temp

    echo "[+] Wrote ${outname}"
}; export -f concat-videos 1> /dev/null


concat-all-videos () {
    # Requires ffmpeg
    # Files must be .mp4
    # TODO(mcotton): This fails if framerates mismatch!
    vids=($@)

    mkdir -p temp
    for vid in $vids; do
        cp "${vid}" temp
    done
    cd temp

    for vid in $vids; do
        vidstem=`stem ${vid}`
        vidstemwitheescapedspaces=${vidstem//" "/"\\\\ "}
        echo "file ${vidstemwitheescapedspaces}.mp4" >> concat.txt
    done

    outname="out.mp4"
    ffmpeg -f concat -safe 0 -i concat.txt -c copy "${outname}" -loglevel error

    cd ..
    cp "temp/${outname}" .
    rm -r temp

    echo "[+] Wrote ${outname}"
}; export -f concat-all-videos 1> /dev/null


concat-all-videos-sound-only () {
    # Requires ffmpeg
    # Files must be .mp4
    vids=($@)

    mkdir -p temp
    i=0
    for vid in $vids; do
        cp "${vid}" "temp/${i}.mp4"
        i=$((i+1))
    done

    i=0
    for vid in $vids; do
        # vidstem=`stem ${vid}`
        # vidstem=${vidstem//" "/"\\\\ "}  # Escape spaces
        # vidstem=${vidstem//"["/"\\["}  # Escape left brackets
        # vidstem=${vidstem//"]"/"\\]"}  # Escape left brackets
        echo "file ${i}.mp4" >> temp/concat.txt
        i=$((i+1))
    done

    outname="out.m4a"

    cd temp
    ffmpeg -f concat -safe 0 -i concat.txt -vn -c:a copy "${outname}" -loglevel error
    cd ..

    cp "temp/${outname}" .
    rm -r temp

    echo "[+] Wrote ${outname}"
}; export -f concat-all-videos-sound-only 1> /dev/null

concat-all-audio () {
    # Requires ffmpeg
    # Files must be .mp3
    # TODO(mcotton): This fails if framerates mismatch!
    vids=($@)

    mkdir -p temp
    for vid in $vids; do
        cp "${vid}" temp
    done
    cd temp

    for vid in $vids; do
        vidstem=`stem ${vid}`
        vidstemwitheescapedspaces=${vidstem//" "/"\\\\ "}
        echo "file ${vidstemwitheescapedspaces}.mp3" >> concat.txt
    done

    outname="out.mp3"
    ffmpeg -f concat -safe 0 -i concat.txt -c copy "${outname}" -loglevel error

    cd ..
    cp "temp/${outname}" .
    rm -r temp

    echo "[+] Wrote ${outname}"
}; export -f concat-all-audio 1> /dev/null


### screen capture
devices () { ffmpeg -f avfoundation -list_devices true -i ""; }; export -f devices 1> /dev/null
record-air () { record-macos "30" "1440" "900" "$1" "$2"; }; export -f record-air 1> /dev/null
record-macos () {
    ffmpeg -f avfoundation -r "$1" -video_size "$2x$3" -i "$4:$5" -pix_fmt yuv420p "rec.mov"
}; export -f record-macos 1> /dev/null
record-mini-video () {
    ffmpeg -nostdin -f avfoundation -r 30 -video_size "2160x1440" -i "0:none" -pix_fmt yuv420p "`date`.mov"
}; export -f record-mini-video 1> /dev/null
record-mini-audio () {
    ffmpeg -f avfoundation -i "none:0" "`date`.aiff"
}; export -f record-mini-video 1> /dev/null
record-mini () {
    # ffmpeg -nostdin -f avfoundation -r 10 -capture_cursor true -i "0:none" -s "720x480" -pix_fmt yuv420p "`date`.mov" 2>vid.log &
    ffmpeg -nostdin -f avfoundation -r 30 -i "0:none" -s "720x480" -c:v libx264 "`date`.m4v" 2>vid.log &
    ffmpeg -nostdin -f avfoundation -i "none:$1" "`date`.aiff" 2>aud.log &
}; export -f record-mini 1> /dev/null
stop-record-mini () {
    killall -INT ffmpeg
}; export -f stop-record-mini 1> /dev/null

## other ffmpeg
vid-to-gif () {
    ffmpeg -i "$1" \
    -filter_complex 'fps=30,scale=-1:-1:flags=lanczos,split [o1] [o2];[o1] palettegen [p]; [o2] fifo [o3];[o3] [p] paletteuse' \
    "$1.gif"
}; export -f vid-to-gif 1> /dev/null
vid-to-mp4 () { ffmpeg -i "$1" "$1.mp4"; }; export -f vid-to-mp4 1> /dev/null
gif-to-mp4 () { ffmpeg -i "$1" -movflags faststart -pix_fmt yuv420p -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" "$1.mp4"; }; export -f gif-to-mp4 1> /dev/null
# frames-to-sequence-lossless () {
#     # ffmpeg -framerate 10 -i %d.png -c:v copy output.mkv
#     # ffmpeg -i output.mkv %d.png
# }
frames-to-mp4 () {
    # ARG 1: 60
    # ARG 2: 256x256
    # ARG 3: "./dir/image%05d.png"
    fps="$1"
    WxH="$2"
    filenamePattern="$3"
    ffmpeg -r "$fps" -f image2 -s "$WxH" -i "$filenamePattern" -vcodec libx264 -crf 25 -pix_fmt yuv420p out.mp4
}; export -f frames-to-mp4 1> /dev/null
mux-video-audio () {
    ffmpeg -i "$1" -i "$2" -c:v copy -c:a aac -shortest "$1-mux.mp4"
}; export -f mux-video-audio 1> /dev/null
alias mux='mux-video-audio '
stabilize () {
    vid="$1"
    ffmpeg -i "$vid" -vf vidstabdetect=shakiness=10:accuracy=15 -f null - \
    && ffmpeg -i "$vid" -vf vidstabtransform=zoom=5:smoothing=30 -vcodec libx264 -preset slow -tune film -crf 20 -an "$vid-stabilized.mp4" \
    && rm transforms.trf
}; export -f stabilize 1> /dev/null
stabilize-gif () {
    gif="$1"
    gif-to-mp4 "$gif" \
    && stabilize "$gif.mp4" && rm "$gif.mp4" \
    && vid-to-gif "$gif.mp4-stabilized.mp4" && rm "$gif.mp4-stabilized.mp4"
}; export -f stabilize-gif 1> /dev/null
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
# alias p='python3.9 '
alias p='python '
pm () {
    p -m `_pm "$1"`
}; export -f pm 1> /dev/null
pim () {
    p -im `_pm "$1"`
}; export -f pim 1> /dev/null
_pm () {
    filepath="$1"
    without_common_root="${filepath#`pwd`/}"
    without_py="${without_common_root%.py}"
    with_dots="${without_py//\//.}"
    echo "$with_dots"
}; export -f _pm 1> /dev/null
alias pver='p --version'
alias pdoc='pydoc -w ./'
# (pip2 provided by brew-python2)
# (pip3 provided by brew-python3)
alias pipi2='pip2 install'
alias pipi3='pip3.9 install'
alias pipir2='pip2 install -r requirements.txt'
alias pipir3='pip3.9 install -r requirements.txt'
alias pipf2='pip2 freeze'
alias pipf3='pip3.9 freeze'
alias pipfr2='pip2 freeze > requirements.txt'
alias pipfr3='pip3.9 freeze > requirements.txt'
pipit2 () { PYTHONUSERBASE="$2" pip2 install "$1"; }; export -f pipit2 1> /dev/null  # "pipit = PIP Install Target"
pipit3 () { PYTHONUSERBASE="$2" pip3.9 install "$1"; }; export -f pipit3 1> /dev/null

# alias pip='pip3.9'  # <-- personal favorite
alias pipi='pipi3'  # <-- personal favorite
alias pipir='pipir3'  # <-- personal favorite
alias pipf='pipf3'  # <-- personal favorite
alias pipfr='pipfr3'  # <-- personal favorite
alias pipit='pipit3'  # <-- personal favorite

### PyPI
alias pypibuild='build'
alias pypireset='rm dist/*'

alias pypiuptest='twine upload --skip-existing --repository test dist/*'
alias pypibuptest='pypibuild && pypiuptest'

alias pypiuplive='twine upload --skip-existing --repository live dist/*'
alias pypiup='pypiuplive'
alias pypibuplive='pypibuild && pypiuplive'
alias pypibup='pypibuild && pypiup'

alias pipitest='pip install -i https://test.pypi.org/simple/ '

# (legacy)
# alias pypireg='python setup.py register -r'
# alias pypiup='python setup.py sdist upload -r'
# alias pypi='python setup.py register sdist upload -r'

alias sbpypi='subl ~/.pypirc'
alias sbpypirc='sbpypi'


#
alias unit='python -m unittest'
alias unitd='python -m unittest discover'
alias pysh=/Users/mcotton/Code/pysh/bin/pysh

_pslice () { python -c "import sys;a,b,c=[int(i) or None for i in sys.argv[1:]];print(sys.stdin.read().rstrip('\n')[slice(a,b,c)])" "$1" "$2" "$3"; }; export -f _pslice 1> /dev/null
pslice () { _pslice "${1:-0}" "${2:-0}" "${3:-0}"; }; export -f pslice 1> /dev/null

_psplit () { python -c "import sys;a,b=sys.argv[1:];a=a or None;b=int(b) or -1;print(' '.join(sys.stdin.read().rstrip('\n').split(a,b)))" "$1" "$2"; }; export -f _psplit 1> /dev/null
psplit () { _psplit "${1:-}" "${2:-0}"; }; export -f psplit 1> /dev/null

_preplace () { python -c "import sys;a,b,c=sys.argv[1:];c=int(c) or -1;print(sys.stdin.read().rstrip('\n').replace(a,b,c))" "$1" "$2" "$3"; }; export -f _preplace 1> /dev/null
preplace () { _preplace "${1:-}" "${2:-}" "${3:-0}"; }; export -f preplace 1> /dev/null

_pfilter () { python -c "import re,sys;a=sys.argv[1];print(re.sub('|'.join(re.escape(e) for e in a),'',sys.stdin.read().rstrip('\n')))" "$1"; }; export -f _pfilter 1> /dev/null
pfilter () { _pfilter "${1:-}"; }; export -f pfilter 1> /dev/null

_pbreak () { python -c "import re,sys;a=sys.argv[1];print(sys.stdin.read().rstrip('\n').replace(a, '\n'))" "$1"; }; export -f _pbreak 1> /dev/null
pbreak () { _pbreak "${1:-}"; }; export -f pbreak 1> /dev/null

_pbefore () { python -c "import sys;a=sys.argv[1];print(sys.stdin.read().split(a)[0])" "$1"; }; export -f _pbefore 1> /dev/null
pbefore () { _pbefore "${1:-}"; }; export -f pbefore 1> /dev/null

_pafter () { python -c "import sys;a=sys.argv[1];print(sys.stdin.read().split(a)[-1])" "$1"; }; export -f _pbefore 1> /dev/null
pafter () { _pafter "${1:-}"; }; export -f pafter 1> /dev/null

slugify () {
    echo "$@" | python "${HOME}/home/mine/slugify.py"
}; export -f slugify 1>/dev/null
alias slug="slugify "

# protip:  chain these ^ with "while read _ _ _"

alias pfirstn="head -n "
alias plastn="tail -n "
pbetween () { pfirstn "$2" | plastn $(($2 - $1)); }; export -f pbetween 1> /dev/null
paftern () { tail -n "+$((1+$1))" }; export -f paftern 1> /dev/null
pbeforen () { python -c "import collections,itertools,sys;b=int(sys.argv[1]);d=collections.deque(maxlen=b);[d.append(l.rstrip()) for l in itertools.islice(sys.stdin,b)];[(print(d.popleft()),d.append(l.rstrip())) for l in sys.stdin]" "$1" }; export -f pbeforen 1> /dev/null

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
alias virtualenv3='virtualenv -p p'
alias pvenv2='python2 -m venv'
alias pvenv='p -m venv'
alias venv='pvenv' # <-- personal favorite

alias vv='venv venv'
alias av='a venv'
alias dv='d'

### mac/darwin
alias shhh='pmset displaysleepnow'
alias deepsleep='pmset sleepnow'
alias show-hidden-files='defaults write com.apple.finder AppleShowAllFiles YES'
alias hide-hidden-files='defaults write com.apple.finder AppleShowAllFiles NO'

### mac + chrome
alias show-tabs="osascript -e{'set text item delimiters to linefeed','tell app\"google chrome\"to url of tabs of window 1 as text'}"
alias save-tabs="show-tabs | tee -a tabs.txt | wc -l | xargs printf '[+] Saved %s tabs to tabs.txt.\n' && echo "" >> tabs.txt"

### shortcuts
alias l='ls -al'
alias k='kill %-'
o () {
    if [ "$#" -eq 0 ]; then
        open .
    else
        open "$@"
    fi
}; export -f o 1> /dev/null
alias subl='open -a "Sublime Text"'
alias osaj='osascript -l JavaScript '
alias bin='xxd -b'
alias hex='hexdump -C'
alias hexf='open -a "Hex Fiend"'
alias json='python -m json.tool'
alias rmpyc='find . -name \*.pyc -delete'
alias encoding='file -I'
alias beep="echo -e '\a'"

totp () {
    if [ $# -eq 0 ]; then
        ~/home/mine/PyOTP/run
    else
        echo "$1" | base64 -d | ~/home/mine/PyOTP/run
    fi
}; export -f totp 1> /dev/null

### youtube
yt () {
    youtube-dl -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]" "$1" --no-check-certificate
}; export -f yt 1> /dev/null
yta () {
    youtube-dl -f "bestaudio[ext=m4a]" "$1" --no-check-certificate
}; export -f yta 1> /dev/null
yt1 () {
    filename=`youtube-dl --get-filename "$1"` && \
    youtube-dl -f "bestvideo+bestaudio" "$1" --no-check-certificate && \
    ffmpeg -i "$filename" "$filename.mp4" && \
    rm "$filename"
}; export -f yt1 1> /dev/null
ytd () {
    youtube-dl "$1" --no-check-certificate
}; export -f ytd 1> /dev/null
ytb () {
    youtube-dl -f "bestvideo+bestaudio" "$1" --no-check-certificate
}; export -f ytb 1> /dev/null

refreshanaconda () {
    ps ax | grep anaconda | grep jsonserver | awk '{print $1}' | \
    while read pid; do
        echo "Killing anaconda jsonserver: $pid"
        kill $pid
    done
}; export -f refreshanaconda 1> /dev/null

alias iwillfindyou='find / -name'
cdd () { cd "`dirname "$1"`"; }; export -f cdd 1> /dev/null
alias wgeta='wget --header="Accept: text/html" --user-agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:21.0) Gecko/20100101 Firefox/21.0"'
alias curlj='curl -H "Content-Type: application/json"'
g () {
    payload="{\"url\": \"$1\"}"
    curlj "http://10.0.1.11:11021/ytd" -d $payload
}; export -f g 1> /dev/null

### markdown
md () { markdown "$1" > "$1".html || echo "Must `brew install markdown`!"; }; export -f md 1> /dev/null
mdo () { md "$1" && open "$1".html; }; export -f mdo 1> /dev/null

### ssh stuff
alias sshno="ssh -i ~/.ssh/id_rsa_nopass "
addpub () { cat ~/.ssh/"$1.pub" | ssh "$2" "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"; }; export -f addpub 1> /dev/null

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
# alias gitb='git branch --list'  # git branch(es)
alias gitb="git for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:red)%(objectname:short)%(color:reset) - %(color:yellow)%(refname:short)%(color:reset) %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'"
alias gitba='git branch --list --all'
alias gitbl='git blame'
alias gitd='git diff'
alias gitds='git diff --staged'
alias gitdl='git diff HEAD~1 HEAD'  # git diff last
alias gits='git status'
alias gitsh='git show '
alias gitt='git tag --list'  # git tag(s)
alias gitw='git whatchanged'
alias git_current_branch='git rev-parse --abbrev-ref HEAD'
alias gdiff='git diff -U0 --word-diff --no-index -- '

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
alias gitlr='_gitlp --graph --remotes '  # remotes

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
gitforked () { parentBranch="$1"; currentBranch=`git rev-parse --abbrev-ref HEAD`; git merge-base $parentBranch $currentBranch }; export -f gitforked 1> /dev/null
gitsince () { parentBranch="$1"; currentBranch=`git rev-parse --abbrev-ref HEAD`; hash=`gitforked "$1"`; git diff --name-only "$1" $hash }; export -f gitsince 1> /dev/null
gitdsince () {
    newBranch="$1"
    oldBranch="$2"
    latestCommonAncestor=`git merge-base $oldBranch $newBranch`
    git diff $latestCommonAncestor $newBranch
}; export -f gitdsince 1>/dev/null
gitwhowrote () {
    string="$1"
    git log -S "${string}" --source --all
}; export -f gitwhowrote 1>/dev/null

# modify
alias gitaa='git add .'
alias gitau='git add -u'
alias gitbr='git branch'
alias gitcom='git commit'
alias gitcon='git commit --no-verify'
alias gitcoma='git commit --amend'
alias gitch='git checkout'
gitchi () { git checkout -b "$1" "origin/$1"; }; export -f gitchi 1> /dev/null
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
gitsuto () { git branch --set-upstream-to="origin/$1" "$2"; }; export -f gitsuto 1> /dev/null
alias ithinkibrokesomething='git reset --soft HEAD~1'
alias ijustbrokeeverything='git reset --hard origin/master && git pull origin master'
alias gitundo="git reset --soft HEAD@{1} "  # Great for undoing a `gitcoma`

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
alias gti='echo "Did you mean *git*?"; git '
alias gut='echo "Did you mean *git*?"; git '
alias gtu='echo "Now this is just a disgrace."'

# personal commands -- private ;)
alias nbpp='nano ~/.bash_profile_private'
alias sbpp='subl ~/.bash_profile_private'
alias nbpr='nano ~/.bash_profile_racap'
alias sbpr='subl ~/.bash_profile_racap'
alias nbpn='nano ~/.bash_profile_numerated'
alias sbpn='subl ~/.bash_profile_numerated'
alias nbprp='nano ~/.bash_profile_racap_personal'
alias sbprp='subl ~/.bash_profile_racap_personal'
FILE=~/.bash_profile_private && test -f $FILE && source $FILE && echo "[+] ~/.bash_profile_private"
FILE=~/.bash_profile_hubspot && test -f $FILE && source $FILE && echo "[+] ~/.bash_profile_hubspot"
FILE=~/.bash_profile_racap && test -f $FILE && source $FILE && echo "[+] ~/.bash_profile_racap"
FILE=~/.bash_profile_numerated && test -f $FILE && source $FILE && echo "[+] ~/.bash_profile_numerated"

# _gitkey () {
#     local key="$1"
#     shift 2  # remove the "git" from the now-expanded passed command
#     git -c core.sshCommand="ssh -i ~/.ssh/$key" $@
# }; export -f _gitkey 1> /dev/null

# _gitkeyexperiment () {
#     local key="$1"
#     local name="$2"
#     local email="$3"
#     shift 4  # remove the "git" from the now-expanded passed command
#     git -c core.sshCommand="ssh -i ~/.ssh/$key" -c user.name="$name" -c user.email="$email" $@
# }; export -f _gitkeyexperiment 1> /dev/null

# alias gitkey1='_gitkey id_rsa '
alias gitkey2='GIT_SSH_COMMAND="ssh -i ~/.ssh/id_rsa_mattccs_github -o IdentitiesOnly=yes" '

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
