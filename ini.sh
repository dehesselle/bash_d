# SPDX-FileCopyrightText: 2021 René de Hesselle <dehesselle@web.de>
#
# SPDX-License-Identifier: GPL-2.0-or-later

### description ################################################################

# This file provides functions to read and write *.ini files. The inspiration
# to abuse git as general-purpose ini parser came from
# https://serverfault.com/a/985355a - neat!

### shellcheck #################################################################

# shellcheck shell=bash # no shebang as this file is intended to be sourced

### dependencies ###############################################################

assert_git
bash_d_include echo

### variables ##################################################################

INI_FILE=${INI_FILE:-}   # defined here for interface visibility

### functions ##################################################################

function _ini_get
{
  local file=$1
  local section=$2
  local key=$3
  local value_default=$4

  if ! git config -f "$file" --get "$section"."$key" 2>/dev/null; then
    if [ -n "$value_default" ]; then
      _ini_set "$file" "$section" "$key" "$value_default"
      echo "$value_default"
    else
      return 1
    fi
  fi
}

function _ini_set
{
  local file=$1
  local section=$2
  local key=$3
  local value=$4
  local type=$5   # optional, defaults to "no type" which will be string

  if [ -n "$type" ]; then
    type="--type $type"
  fi

  # shellcheck disable=SC2086 # need word splitting for '$type'
  if ! git config -f "$file" $type "$section"."$key" "$value" 2>/dev/null; then
    echo_e "unable to set $section:$key"
    return 1
  fi
}

function _ini_del
{
  local file=$1
  local section=$2
  local key=$3

  if ! git config -f "$file" --unset "$section"."$key" 2>/dev/null; then
    echo_e "unable to delete $section:$key"
    return 1
  fi
}

# shellcheck disable=SC2086,SC2139,SC2140 # expansion on definition is ok
function ini_instantiate
{
  local file=$1
  local name=$2

  alias ${name}_del="_ini_del $file"
  alias ${name}_get="_ini_get $file"
  alias ${name}_set="_ini_set $file"
}

### aliases ####################################################################

alias ini_del='_ini_del $INI_FILE'
alias ini_get='_ini_get $INI_FILE'
alias ini_set='_ini_set $INI_FILE'

### main #######################################################################

# Nothing here.
