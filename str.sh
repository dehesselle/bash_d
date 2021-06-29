# SPDX-FileCopyrightText: 2021 René de Hesselle <dehesselle@web.de>
#
# SPDX-License-Identifier: GPL-2.0-or-later

### description ################################################################

# Provide string-related convenience functions.

### shellcheck #################################################################

# shellcheck shell=bash # no shebang as this file is intended to be sourced

### includes ###################################################################

include_guard

### variables ##################################################################

# Nothing here.

### functions ##################################################################

function str_get_token
{
  local string=$1
  local separator=$2
  declare -i token_no=$3

  # The easier way would be to loop using the IFS, but that would lose
  # trailing whitespaces if there were more than one.

  declare -i start_pos=0
  declare -i count=0
  local token=

  for ((i=0; i<${#string}; i++)); do
    if [ "${string:i:1}" = "$separator" ]; then
      token=${string:start_pos:i-start_pos}
      start_pos=$((i+1))
      count=$((count+1))

      if [ $count -eq "$token_no" ]; then
        break
      fi
    fi
  done

  if [ $count -ne "$token_no" ]; then
    token=${string:start_pos}
  fi

  echo "$token"
}

### aliases ####################################################################

# Nothing here.

### main #######################################################################

# Nothing here.
