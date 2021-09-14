# SPDX-FileCopyrightText: 2021 René de Hesselle <dehesselle@web.de>
#
# SPDX-License-Identifier: GPL-2.0-or-later

### description ################################################################

# Provide an include guard to be used in every script to protect them from
# being sourced multiple times.

### shellcheck #################################################################

# shellcheck shell=bash # no shebang as this file is intended to be sourced

### dependencies ###############################################################

# All of these need to be "or true" because they fail on the first run.

bash_d_include_guard 2>/dev/null || true
bash_d_include echo.sh 2>/dev/null || true
bash_d_include assert 2>/dev/null || true

### variables ##################################################################

if [ -z "$BASH_D_DIR" ]; then
  BASH_D_DIR=$(dirname "${BASH_SOURCE[0]}")
fi

if [ -z "$BASH_D_FAIL_ON_INCLUDE_ERROR" ]; then
  BASH_D_FAIL_ON_INCLUDE_ERROR=true
fi

### functions ##################################################################

function bash_d_include_absolute
{
  local source_file=$1
  local source_file_line_no=$2
  local target_file=$3

  source_file=$(basename $source_file)
  target_file=$BASH_D_DIR/${target_file/.sh}.sh  # make sure filename has suffix

  if [ -f "$target_file" ]; then
    # shellcheck disable=SC1090 # this include is dynamic on purpose
    if ! source "$target_file"; then
      if alias | grep "echo_e" >/dev/null; then  # safeguard against missing echo_e
        echo_e "$source_file will be unavailable (depends on $(basename $target_file))"
      else
        >&2 echo "error: $source_file will be unavailable (depends on $(basename $target_file)) [$FUNCNAME]"
      fi
      if $BASH_D_FAIL_ON_INCLUDE_ERROR; then
        exit $source_file_line_no
      else
        return $source_file_line_no
      fi
    fi
  else
    if alias | grep "echo_e" >/dev/null; then  # safeguard against missing echo_e
      echo_e "file not found: $target_file"
    else
      >&2 echo "error: file not found: $target_file [$FUNCNAME]"
    fi
    exit $source_file_line_no
  fi
}

function bash_d_include_all
{
  for file in "$BASH_D_DIR"/*.sh; do
    BASH_D_FAIL_ON_INCLUDE_ERROR=false \
      bash_d_include_absolute $FUNCNAME $LINENO $(basename $file)
  done
}

function bash_d_include_relative
{
  local source_file=$1
  local source_file_line_no=$2

  local target_file
  target_file=$(sed -n "${source_file_line_no}"p "$source_file" |
                awk '{ print $2 }')

  bash_d_include_absolute $source_file $source_file_line_no $target_file
}

function bash_d_is_included
{
  local file=$1

  return [[ " ${BASH_D_FILES[@]} " =~ " $file " ]]
}
### aliases ####################################################################

alias bash_d_include_guard=\
'declare -a BASH_D_FILES; '\
'if [[ " ${BASH_D_FILES[@]} " =~ " ${BASH_SOURCE[0]} " ]]; then '\
'  return; '\
'else '\
'  BASH_D_FILES+=("${BASH_SOURCE[0]}"); '\
'fi '

alias bash_d_include='bash_d_include_relative ${BASH_SOURCE[0]} $LINENO; BASH_D_RC=$?; [ $BASH_D_RC -ne 0 ] && return $BASH_D_RC || true #'

alias bash_d_include_try='BASH_D_FAIL_ON_INCLUDE_ERROR=false bash_d_include_absolute ${BASH_SOURCE[0]} $LINENO'

### main #######################################################################

if [ ! -d "$BASH_D_DIR" ]; then
  echo "error: BASH_D_DIR=$BASH_D_DIR is invalid [${BASH_SOURCE[0]}]"
  exit 1
fi

shopt -s expand_aliases
# shellcheck disable=SC1090 # dynamic include
source "${BASH_SOURCE[0]}"  # because bash_d_include_guard wasn't available
                            # on the first run