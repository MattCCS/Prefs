"""
Script to dynamically form the format specification for:
    git log --pretty=format:<FORMAT>
"""

# standard
import sys

RESET = "%Creset%s"

VALUES = {
    "h": "%C(yellow)%h",
    "d": "%Cred%ad",
    "a": "%Cblue%an",
    "b": "%Cgreen%d",
    "s": "%Creset%s",
}


def form(args):
    return ' '.join(VALUES[arg] for arg in args if arg in VALUES)

if __name__ == '__main__':
    sys.stdout.write(form(sys.argv[1]))
    sys.stdout.flush()
