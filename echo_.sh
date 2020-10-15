# SPDX-License-Identifier: GPL-2.0-or-later
# https://github.com/dehesselle/bash_d

include_guard

### includes ###################################################################

include_file ANSI_.sh

### variables ##################################################################

ECHO_ANSI_ENABLE=true       # allow ANSI escape sequences for e.g. colors...
ECHO_ANSI_TERM_ONLY=true    # ...but only when running in a terminal

### functions ##################################################################

function _echo_message
{
  local name=$1   # can be empty
  local type=$2
  local color=$3
  local args=${@:4}

  if $ECHO_ANSI_ENABLE; then
    local color_reset=$ANSI_FG_RESET

    # Disable colors if not running in terminal unless explicitly allowed
    # by ECHO_ANSI_TERM_ONLY=false.
    if [ ! -t 1 ] && $ECHO_ANSI_TERM_ONLY; then
        color=""
        color_reset=""
    fi
  fi

  if [ ! -z $name ]; then
    name=":$name"
  fi

  echo -e "$color[$type$name] $color_reset$args"
}

### aliases ####################################################################

alias echo_e='>&2 _echo_message "$FUNCNAME" "error" "$ANSI_FG_RED_BOLD"'
alias echo_i='>&2 _echo_message "$FUNCNAME" "info" "$ANSI_FG_BLUE_BOLD"'
alias echo_o='>&2 _echo_message "$FUNCNAME" "ok" "$ANSI_FG_GREEN_BOLD"'
alias echo_w='>&2 _echo_message "$FUNCNAME" "warning" "$ANSI_FG_YELLOW_BOLD"'

### main #######################################################################

# Nothing here.