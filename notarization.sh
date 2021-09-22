# SPDX-License-Identifier: GPL-2.0-or-later
# https://github.com/dehesselle/bash_d

assert_darwin

### includes ###################################################################

bash_d_include developer.sh

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
    --username "$DEVELOPER_USERNAME" \
    --file $app
}

### aliases ####################################################################

alias notarization_info='xcrun altool --username "$DEVELOPER_USERNAME" --notarization-info'
alias notarization_staple='xcrun stapler staple'

### main #######################################################################

# Nothing here.