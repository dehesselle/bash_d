platform_darwin_only
include_guard

### includes ###################################################################

include_file echo_.sh
include_file ini_.sh
include_file str_.sh

### variables ##################################################################

NOTARIZATION_USERNAME=
NOTARIZATION_APPLE_DEVELOPER=$XDG_CONFIG_HOME/apple_developer

### functions ##################################################################

# Nothing here.

### aliases ####################################################################

alias notarization_info='xcrun altool --username "$NOTARIZATION_USERNAME" --notarization-info'
alias notarization_staple='xcrun stapler staple'

### main #######################################################################

if [ -f $NOTARIZATION_APPLE_DEVELOPER ]; then
  ini_read $NOTARIZATION_APPLE_DEVELOPER
  NOTARIZATION_USERNAME=$(ini_get username)

  if $(str_is_empty $NOTARIZATION_USERNAME); then
    echo_e "unable to get 'username' from $NOTARIZATION_APPLE_DEVELOPER"
  fi
else
  echo_e "file not found: $NOTARIZATION_APPLE_DEVELOPER"
fi