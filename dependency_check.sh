include_guard

### description ################################################################

# This script provides a function to parse all other scripts for potential
# usage of programs installed via Homebrew or Macports and then checks if those
# programs are actually available. The intention is to get notified about
# missing dependencies as soon as possible, before the script requiring them
# is run.

### includes ###################################################################

include_file echo_.sh

### variables ##################################################################

# Nothing here.

### functions ##################################################################

function dependency_check
{
  if [ -z $HOMEBREW_ROOT ] || [ -z $MACPORTS_ROOT ]; then
    echo_e "HOMEBREW_ROOT and/or MACPORTS_ROOT not set"
    return -1
  fi

  while IFS= read -r line; do
    if [[ "$line" =~ ([^:]+):.+(($HOMEBREW_ROOT|\$HOMEBREW_ROOT|$MACPORTS_ROOT|\$MACPORTS_ROOT)/bin/[^ ]+)  ]]; then
      local file=${BASH_REMATCH[1]}
      local dependency=$(eval echo ${BASH_REMATCH[2]})
      if [ ! -f "$dependency" ]; then
        echo_e "$(basename $file): $dependency"
      fi
    else
      echo_w "malformed: $line"
    fi
  done < <(grep \
      --exclude=$(basename ${BASH_SOURCE[0]}) \
      -e "$HOMEBREW_ROOT/bin/" \
      -e "\$HOMEBREW_ROOT/bin/" \
      -e "$MACPORTS_ROOT/bin/" \
      -e "\$MACPORTS_ROOT/bin/" \
      $INCLUDE_DIR/*.sh \
      )
}

### aliases ####################################################################

# Nothing here.

### main #######################################################################

dependency_check