# SPDX-FileCopyrightText: 2021 René de Hesselle <dehesselle@web.de>
#
# SPDX-License-Identifier: GPL-2.0-or-later

### description ################################################################

# Provide an include guard to be used in every script to protect them from
# being sourced multiple times.

### shellcheck #################################################################

# shellcheck shell=bash # no shebang as this file is intended to be sourced

### includes ###################################################################

# All of these need to be "or true" because they fail on the first run.

include_guard 2>/dev/null || true

include_file echo.sh 2>/dev/null || true
include_file assert.sh 2>/dev/null || true

### variables ##################################################################

if [ -z "$INCLUDE_DIR" ]; then
  INCLUDE_DIR=$XDG_CONFIG_HOME/bash.d  # default repository location
fi

### functions ##################################################################

function include_file__
{
  local from=$1
  local file=$2

  file=${file/.sh}.sh  # make sure filename has suffix

  if [ -f "$file" ]; then
    # shellcheck disable=SC1090 # this include is dynamic on purpose
    if ! source "$INCLUDE_DIR/$file"; then  # assertion stopped the include
      if alias | grep "echo_e" >/dev/null; then  # safeguard against missing echo_e
        echo_e "$(basename $from) depends on $(basename $file)"
      else
        >&2 echo "error: $(basename $from) depends on $(basename $file) [$FUNCNAME]"
      fi
      exit 1
    fi
  else
    if alias | grep "echo_e" >/dev/null; then  # safeguard against missing echo_e
      echo_e "file not found: $file"
    else
      >&2 echo "error: file not found: $file [$FUNCNAME]"
    fi
    exit 1
  fi
}

### aliases ####################################################################

alias include_guard=\
'declare -a INCLUDE_FILES; '\
'if [[ " ${INCLUDE_FILES[@]} " =~ " ${BASH_SOURCE[0]} " ]]; then '\
'  return; '\
'else '\
'  INCLUDE_FILES+=("${BASH_SOURCE[0]}"); '\
'fi '

alias include_file='include_file__ ${BASH_SOURCE[0]}'

### main #######################################################################

if [ ! -d "$INCLUDE_DIR" ]; then  # this can happen if XDG_CONFIG_HOME isn't set
  echo "error: INCLUDE_DIR invalid [${BASH_SOURCE[0]}]"
  exit 1
fi

shopt -s expand_aliases
# shellcheck disable=SC1090 # this include is dynamic on purpose
source "${BASH_SOURCE[0]}"  # because include_guard wasn't available on first run
