# SPDX-License-Identifier: GPL-2.0-or-later
# https://github.com/dehesselle/bash_d

include_guard

### includes ###################################################################

include_file echo_.sh

### variables ##################################################################

# Nothing here.

### functions ##################################################################

function _function_mandatory_args
{
  local func_name=$1
  local func_args_provided_count=$2
  local func_args_provided=("${@:3:$func_args_provided_count}")
  local func_args_required=("${@:$func_args_provided_count+3}")

  if [ ${#func_args_provided[@]} -lt ${#func_args_required[@]} ]; then
    echo_e "calling $func_name() with ${#func_args_provided[@]} of ${#func_args_required[@]} mandatory arguments"
    exit 1
  fi

  local count=0
  for arg in "${func_args_provided[@]}"; do
    export ${func_args_required[$count]}="${arg}"
    ((count++))
  done
}

### aliases ####################################################################

alias function_mandatory_args='_function_mandatory_args $FUNCNAME $# "${@}"'

### main #######################################################################

# Nothing here.