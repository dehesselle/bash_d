include_guard 2>/dev/null || true  # special treatment for the first run

### description ################################################################

# This file provides an include guard to be used in every script to protect
# them being sourced multiple times.

### includes ###################################################################

# Nothing here.

### variables ##################################################################

INCLUDE_DIR=$XDG_CONFIG_HOME/bash.d  # this is where all scripts are to be found

### functions ##################################################################

function include_file
{
  local file=$1
  source $INCLUDE_DIR/$file
}

### aliases ####################################################################

alias include_guard='declare -a INCLUDE_FILES; [[ " ${INCLUDE_FILES[@]} " =~ " ${BASH_SOURCE[0]} " ]] && return || INCLUDE_FILES+=("${BASH_SOURCE[0]}")'

### main #######################################################################

if [ ! -d $INCLUDE_DIR ]; then  # this can happen if XDG_CONFIG_HOME isn't set
  echo "error: INCLUDE_DIR invalid"
  exit 1
fi

shopt -s expand_aliases
source ${BASH_SOURCE[0]}  # because include_guard wasn't available on first run
