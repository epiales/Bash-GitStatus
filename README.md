Bash-GitStatus
==============

A simple script for bash that outputs a git repository's status information in a simple manner.

How to use:
-----------

Download the file using ``wget`` or ``curl`` or clone the repository:

```
wget https://raw.github.com/epiales/Bash-GitStatus/master/gitStatus.pl
curl -OL https://raw.github.com/epiales/Bash-GitStatus/master/gitStatus.pl
```

Edit your .bash_profile or .bashrc to include the script and include the output in the prompt (assumes script is located in home directory)

```
alias gst="perl ~/gitStatus.pl"

PS1="\n\n\u@\h \w $(gst)\n> "
```

which gives the following output (while in a git repository) for a branch 2 commits ahead of master, 3 new staged files, 4 modified staged files, and one unstaged deleted file:
```


user@host /current/working/directory/ [ master+2 | +3 ~4 | -1 ]> 
```

Notice the pipe characters seperate the branch name from staged status as well as unstaged status.


If not in a git repository, the output becomes:
```
user@host /current/working/directory/ >
```

## Gotchas

In order for the color support to properly work, it is highly recommended that you include a newline character at the end of the prompt. Terminal has issues with wrapping a prompt that contains colors. You can see the `\n` character in the example above with `$(gst)\n>`.
