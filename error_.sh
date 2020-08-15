# SPDX-License-Identifier: GPL-2.0-or-later
# https://github.com/dehesselle/bash_d

include_guard

### includes ###################################################################

include_file ANSI_.sh
include_file echo_.sh

### variables ##################################################################

ERROR_COUNT=0

### functions ##################################################################

function error_catch
{
  local file=$1
  local line=$2
  local func=$3
  local command=$4
  local rc=$5

  [ -z $func ] && func="main" || true

  ((ERROR_COUNT++))

  case $ERROR_COUNT in
    1) echo_e "($file:$line) $func failed with rc=$rc"
       echo_e "              $ANSI_FG_YELLOW_BRIGHT$command$ANSI_FG_RESET"
       ;;
    *) echo_e "($file:$line) <- $func"
       ;;
  esac
}

### aliases ####################################################################

alias error_trace_enable='set -e -o errtrace; trap'\'' error_catch "${BASH_SOURCE[0]}" "$LINENO" "$FUNCNAME" "${BASH_COMMAND}" "${?}"'\'' ERR'

### main #######################################################################

# Nothing here.