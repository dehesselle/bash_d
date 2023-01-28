# SPDX-FileCopyrightText: 2021 René de Hesselle <dehesselle@web.de>
#
# SPDX-License-Identifier: GPL-2.0-or-later

### description ################################################################

# Provide convenience functions to set and get passwords from the keychain.
# We use the default keychain (i.e. login keychain) for convenience as it gets
# unlocked on login.

### shellcheck #################################################################

# shellcheck shell=bash # no shebang as this file is intended to be sourced

### dependencies ###############################################################

assert_darwin

bash_d_include echo

### variables ##################################################################

# This acts as a scope limiter: it makes our items easily identifiable and
# limits our access to them.
KEYCHAIN_ITEM_COMMENT=${KEYCHAIN_ITEM_COMMENT:-bash_d}

### functions ##################################################################

function keychain_get_list
{
  local keychains

  while IFS= read -r keychain; do
    keychains="$keychains$keychain "
  done < <(security list-keychains | awk '{ gsub(/"/, "", $1); print $1 }')

  echo "${keychains%?}"
}

function keychain_set_password
{
  local service=$1
  local user=$2
  local password=$3

  security add-generic-password -j "$KEYCHAIN_ITEM_COMMENT" \
    -s "$service" -a "$user" -w "$password"
}

function keychain_get_password
{
  local service=$1
  local user=$2

  security find-generic-password -j "$KEYCHAIN_ITEM_COMMENT" \
    -s "$service" -a "$user" -w
}

### aliases ####################################################################

# Nothing here.

### main #######################################################################

# Nothing here.
