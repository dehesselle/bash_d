include_guard

### description ################################################################

# This file provides a mechanism to restrict sourcing a script to specific
# platforms.

### includes ###################################################################

# Nothing here.

### variables ##################################################################

[ "$(uname)" = "Darwin" ] && PLATFORM_DARWIN=true || PLATFORM_DARWIN=false
[ "$(uname)" = "Linux"  ] && PLATFORM_LINUX=true  || PLATFORM_LINUX=false

### functions ##################################################################

# Nothing here.

### aliases ####################################################################

alias platform_darwin_only='$PLATFORM_DARWIN && true || return'
alias platform_linux_only='$PLATFORM_LINUX && true || return'

### main #######################################################################

# Nothing here.