# SPDX-License-Identifier: GPL-2.0-or-later
# https://github.com/dehesselle/bash_d

include_guard

### includes ###################################################################

include_file echo_.sh

### variables ##################################################################

# Nothing here.

### functions ##################################################################

function exit_if_file_missing
{
  local file=$1

  if [ ! -f "$file" ]; then
    echo_e "$file"
    exit 1
  fi
}

### aliases ####################################################################

# Nothing here.

### main #######################################################################

# Nothing here.