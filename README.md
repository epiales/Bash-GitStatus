Bash-GitStatus
==============

A simple script for bash that outputs a git repository's status information in a simple manner.

How to use:
-----------

Download the file using ``wget`` or ``curl``:

```
wget https://raw.github.com/epiales/Bash-GitStatus/master/gitStatus.bash
curl -OL https://raw.github.com/epiales/Bash-GitStatus/master/gitStatus.bash
```

Edit your .bash_profile or .bashrc to include the script and include the output in the prompt (assumes script is located in home directory)

```
source ~/gitStatus.bash

PS1="\n\n\u@\h \w $(gitStatus)> "
```

which gives the following output (while in a git repository):
```


user@host /current/working/directory/ [master(+2) +3 ~4 -1 !]> 
```


If not in a git repository, the output becomes:
```
user@host /current/working/directory/ >
```
  
  
The structure of the status output is:
* ``master(+2)``  the current branch (and any additional commits ahead of remote tracking branch, if any)
* ``+3``          added (staged) file count, if any
* ``~4``          modified file count, if any
* ``-1``          deleted file count, if any
* ``!``          untracked files present
