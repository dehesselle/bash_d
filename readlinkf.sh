# SPDX-License-Identifier: GPL-2.0-or-later
# https://github.com/dehesselle/bash_d

### description ################################################################

# This is a replacement for 'readlink -f' as '-f' is not available on macOS.
# (Install coreutils via Homebrew to get GNU readlink which supports '-f'.)

### includes ###################################################################

# Nothing here.

### variables ##################################################################

# Nothing here.

### functions ##################################################################

function readlinkf
{
  # 'readlink -f' replacement: https://stackoverflow.com/a/1116890
  # 'do while' replacement: https://stackoverflow.com/a/16491478

  local file=$1

  # iterate down a (possible) chain of symlinks
  while
      [ ! -z $(readlink $file) ] && file=$(readlink $file)
      cd $(dirname $file)
      file=$(basename $file)
      [ -L "$file" ]
      do
    :
  done

  # Compute the canonicalized name by finding the physical path
  # for the directory we're in and appending the target file.
  echo $(pwd -P)/$file
}

### aliases ####################################################################

# Nothing here.

### main #######################################################################

# Nothing here.