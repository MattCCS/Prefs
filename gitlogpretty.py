"""
Script to dynamically form the format specification for:
    git log --pretty=format:<FORMAT>
"""

# standard
import sys

RESET = "%Creset%s"

AUTHOR = "%Cblue%an"

VALUES = {
    "h": "%C(yellow)%h",
    "d": "%Cred%ad",
    "a": AUTHOR,
    "b": "%Cgreen%d",
    "s": "%Creset%s",
}


def form(args):
    pretty = ' '.join(VALUES[arg] for arg in args if arg in VALUES)

    # fix weird name having a space issue...
    pretty = pretty.replace(AUTHOR + ' ', AUTHOR)

    return pretty


if __name__ == '__main__':
    sys.stdout.write(form(sys.argv[1]))
    sys.stdout.flush()
