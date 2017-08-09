# ADD TO BASH PROFILE:
# export PYTHONSTARTUP="$HOME/Prefs/pythonstartup.py"

try:
    import readline
except ImportError:
    print("Module readline not available.")
else:
    import rlcompleter
    readline.parse_and_bind("tab: complete")
