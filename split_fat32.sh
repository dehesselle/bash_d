# SPDX-License-Identifier: GPL-2.0-or-later
# https://github.com/dehesselle/bash_d

### includes ###################################################################

# Nothing here.

### variables ##################################################################

# Nothing here.

### functions ##################################################################

function split_fat32
{
  local file=$1

  split -b4095m $file $file.
}

### aliases ####################################################################

# Nothing here.

### main #######################################################################

# Nothing here.