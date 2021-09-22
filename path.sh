# SPDX-License-Identifier: GPL-2.0-or-later
# https://github.com/dehesselle/bash_d

### includes ###################################################################

# Nothing here.

### variables ##################################################################

# Nothing here.

### functions ##################################################################

function path_remove
{ # https://stackoverflow.com/q/370047
  local to_be_removed=$1

  export PATH=$(echo -n $PATH |
                awk -v RS=: -v ORS=: '$0 != "'$to_be_removed'"' |
                sed 's/:$//')
}

### aliases ####################################################################

# Nothing here.

### main #######################################################################

# Nothing here.