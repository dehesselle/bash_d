include_guard

### includes ###################################################################

# Nothing here.

### variables ##################################################################

HISTSIZE=1000
HISTFILESIZE=10000
HISTIGNORE="*iterm2_shell_integration.bash"

### functions ##################################################################

# Nothing here.

### aliases ####################################################################

# Nothing here.

### main #######################################################################

if [ -d "$XDG_DATA_HOME" ]; then
  HISTFILE=$XDG_DATA_HOME/bash_history
else
  unset HISTFILE   # disable default ~/.bash_history
fi