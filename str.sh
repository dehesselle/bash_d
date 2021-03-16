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

function str_get_token
{
  local string=$1
  local separator=$2
  local token_no=$3

  local start_pos=0
  local token=
  local count=0

  # The easier way would be to loop using the IFS, but that would lose
  # trailing whitespaces if there were more than one.

  for ((i=0; i<${#string}; i++)); do
    if [ "${string:i:1}" = "$separator" ]; then
      token=${string:start_pos:i-start_pos}
      start_pos=$((i+1))
      count=$((count+1))

      if [ $count -eq $token_no ]; then
        break
      fi
    fi
  done

  if [ $count -ne $token_no ]; then
    token=${string:start_pos}
  fi

  echo $token
}

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
