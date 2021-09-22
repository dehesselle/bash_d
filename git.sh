# SPDX-License-Identifier: GPL-2.0-or-later
# https://github.com/dehesselle/bash_d

### includes ###################################################################

bash_d_include echo.sh

### variables ##################################################################

# Nothing here.

### functions ##################################################################

function git_delete_current_commit
{
  echo -e "$(git --no-pager log -1)\n\n"
  echo -n "Delete this (yes/NO): "
  local response
  read response

  if [ "$response" = "yes" ]; then
    git reset --hard HEAD~1
  else
    echo "cancelled"
  fi
}

### aliases ####################################################################

# Nothing here.

### main #######################################################################

# Nothing here.