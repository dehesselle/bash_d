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

if [ -z "$INI_FILE" ]; then
  INI_FILE=
fi

### functions ##################################################################

function ini_get__
{
  local file=$1
  local section=$2
  local key=$3
  local value_default=$4

  if ! git config -f "$file" --get "$section"."$key" 2>/dev/null; then
    if [ -n "$value_default" ]; then
      ini_set__ "$file" "$section" "$key" "$value_default"
      echo "$value_default"
    else
      return 1
    fi
  fi
}

function ini_set__
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

function ini_del__
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

  alias ${name}_del="ini_del__ $file"
  alias ${name}_get="ini_get__ $file"
  alias ${name}_set="ini_set__ $file"
}

### aliases ####################################################################

alias ini_del='ini_del__ $INI_FILE'
alias ini_get='ini_get__ $INI_FILE'
alias ini_set='ini_set__ $INI_FILE'

### main #######################################################################

# Nothing here.
