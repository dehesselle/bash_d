# SPDX-FileCopyrightText: 2022 René de Hesselle <dehesselle@web.de>
#
# SPDX-License-Identifier: GPL-2.0-or-later

### description ################################################################

# (Re-)Try to run a command a couple of times.

### shellcheck #################################################################

# shellcheck shell=bash # no shebang as this file is intended to be sourced

### dependencies ###############################################################

bash_d_include echo

### variables ##################################################################

# Nothing here.

### functions ##################################################################

function try
{
  local command=$1
  local retry=$2
  local interval=$3

  retry=${retry:-10}
  interval=${interval:-5}

  while (! $command) && [ "$retry" -gt 0 ]; do
    ((retry--))
    if [ $retry -le 3 ]; then
      echo_w "$retry retries left: $command"
    fi
    sleep "$interval"
  done

  if [ "$retry" -eq 0 ]; then
    return 1
  else
    return 0
  fi
}

### aliases ####################################################################

# Nothing here.

### main #######################################################################

# Nothing here.
