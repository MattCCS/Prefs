Improving Anaconda error messages
=================================
This patch fixes the issue of Anaconda's native Python linting system
annoyingly notifying you of `PEP8` errors (phantom or otherwise) when
there is a `SyntaxError` somewhere in the source file that takes priority.

The simplest way to test this bad behavior (and this fix) is to place
an open list bracket (`[`) somewhere in the Python source file.  This causes
the `PEP8` linter to light the file up like a Christmas tree, burying the
much more important `pyflakes` `SyntaxError` notification in the process.

Required Packages
-----------------
`Anaconda`
`MagicPython`

Sublime Syntax
--------------
`MagicPython` (installed)

Anaconda Settings (my preference)
---------------------------------
`"python_interpreter": "/usr/local/bin/python3",`
`"anaconda_gutter_theme": "hard",`
`"anaconda_linting_behaviour": "load-save",`
`"anaconda_linter_phantoms": true,`

File Changes
------------
Note:  all files are in the Sublime packages directory here:
`~/Library/Application Support/Sublime Text 3/Packages`

0. In `./Anaconda/anaconda_lib/linting/pycodestyle.py`:
    1. Line 289 change: "too" -> "toooo"
    2. Confirm that the `refreshanaconda` command works
    3. Confirm new error message can appear in a Python script
    4. Line 289 revert
    5. Run `refreshanaconda` again
    6. Confirm that the error changed back
1. In `./Anaconda/anaconda_lib/linting/anaconda_pyflakes.py`:
    1. Line 43 insert: `syntax_error = False`
    2. Line 45 change: `(syntax_error, check_errors) = self.check(code, filename, pyflakes_ignore)`
    3. Line 46 change: `errors.extend(check_errors)`
    4. Line 48 change: `return (syntax_error, self.parse(errors, explicit_ignore))`
    5. Line 64 change: `return (True, self._handle_syntactic_error(code, filename))`
    6. Line 66 change: `return (False, [PyFlakesError(filename, FakeLoc(), 'E', error.args[0]), []])`
    7. Line 71 change: `return (False, w.messages)`
2. In `./Anaconda/anaconda_server/commands/pyflakes.py`:
    1. Line 21 insert: `self.syntax_error = False`
    2. Line 29 insert: `(self.syntax_error, errors) = self.linter().lint(self.settings, self.code, self.filename)`
    3. Line 32 change: `'errors': errors,`
1. In `./Anaconda/anaconda_server/handlers/python_lint_handler.py`:
    1. Line 50 insert block: (see below)
    2. Line 84 change: `lint = PyFlakesLinter`
    3. Line 85 change: `pyflakes = PyFlakes(`
    4. Line 87 change: `return pyflakes.syntax_error`

(Block)

    # run pyflakes first and check for SyntaxError to
    # prevent PEP8 from showing cascading style errors
    if self._linters['pyflakes']:
        syntax_error = self.pyflakes(settings, code, filename)
        if syntax_error:
            self._linters['pep8'] = False
        self._linters['pyflakes'] = False
