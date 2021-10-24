# SPDX-FileCopyrightText: 2021 René de Hesselle <dehesselle@web.de>
#
# SPDX-License-Identifier: GPL-2.0-or-later

### description ################################################################

# Simplified acces to property lists as a macOS-specific way to read/write
# configuration files.

### shellcheck #################################################################

# shellcheck shell=bash # no shebang as this file is intended to be sourced

### dependencies ###############################################################

assert_darwin
bash_d_include echo

### variables ##################################################################

PLIST_FILE=${PLIST_FILE:-}   # defined here for interface visibility

### functions ##################################################################

function plist_get__
{
  local file=$1
  local dict=$2
  local key=$3
  local value_default=$4

  if ! /usr/libexec/PlistBuddy -c "Print $dict:$key" "$file" 2>/dev/null; then
    if [ -n "$value_default" ]; then
      plist_set__ "$file" "$dict" "$key" "$value_default"
      echo "$value_default"
    else
      return 1
    fi
  fi
}

function plist_set__
{
  local file=$1
  local dict=$2
  local key=$3
  local value=$4
  local type=$5   # optional, defaults to string

  if [ -z "$type" ]; then
    type=string
  fi

  if ! /usr/libexec/PlistBuddy \
      -c "Set '$dict:$key' '$value'" "$file" 2>/dev/null; then
    if ! /usr/libexec/PlistBuddy \
        -c "Add '$dict:$key' '$type' '$value'" "$file" 2>/dev/null; then
      echo_e "unable to set $dict:$key"
      return 1
    fi
  fi
}

function plist_del__
{
  local file=$1
  local dict=$2
  local key=$3

  if ! /usr/libexec/PlistBuddy \
      -c "Delete '$dict:$key'" "$PLIST_FILE" 2>/dev/null; then
    echo_e "unable to delete $dict:$key"
    return 1
  fi
}

# shellcheck disable=SC2086,SC2139,SC2140 # expansion on definition is ok
function plist_instantiate
{
  local file=$1
  local name=$2

  alias ${name}_del="plist_del__ $file"
  alias ${name}_get="plist_get__ $file"
  alias ${name}_set="plist_set__ $file"
}

### aliases ####################################################################

alias plist_del='plist_del__ $PLIST_FILE'
alias plist_get='plist_get__ $PLIST_FILE'
alias plist_set='plist_set__ $PLIST_FILE'

### main #######################################################################

# Nothing here.
