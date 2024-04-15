echo "[+] ~/.zprofile"

# Stop moving files around, Apple.
FILE=~/.bash_profile && test -f $FILE && source $FILE && echo "[+] ${FILE}"
