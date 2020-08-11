# SPDX-License-Identifier: GPL-2.0-or-later
# https://github.com/dehesselle/bash_d

include_guard

### description ################################################################

# This files provides convenience functions for working with strings.

### includes ###################################################################

# Nothing here.

### variables ##################################################################

# Nothing here.

### functions ##################################################################

function str_is_empty
{
  local string=$1

  if [ ${#string} -eq 0 ]; then
    echo true
  else
    echo false
  fi
}

### aliases ####################################################################

# Nothing here.

### main #######################################################################

# Nothing here.
