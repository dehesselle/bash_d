# SPDX-FileCopyrightText: 2021 René de Hesselle <dehesselle@web.de>
#
# SPDX-License-Identifier: GPL-2.0-or-later

### description ################################################################

# Convenience functions to notarize software.

### shellcheck #################################################################

# shellcheck shell=bash # no shebang as this file is intended to be sourced

### dependencies ###############################################################

bash_d_include developer

### variables ##################################################################

# Nothing here.

### functions ##################################################################

function notarization_request
{
  local app=$1
  local bundle_id=$2

  # Since '--password' is missing, it will prompt for it.
  xcrun altool \
    --notarize-app \
    --primary-bundle-id "$bundle_id" \
    --username "$(developer_get_username)" \
    --file $app
}

### aliases ####################################################################

alias notarization_info='xcrun altool --username "$(developer_get_username)" --notarization-info'
alias notarization_staple='xcrun stapler staple'

### main #######################################################################

# Nothing here.