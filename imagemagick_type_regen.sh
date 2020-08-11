# SPDX-License-Identifier: GPL-2.0-or-later
# https://github.com/dehesselle/bash_d

platform_darwin_only
include_guard

### includes ###################################################################

# Nothing here.

### variables ##################################################################

# Nothing here.

### functions ##################################################################

# Nothing here.

### aliases ####################################################################

# generate type.xml for ImageMagick to see fonts in ~/Library/Fonts
alias imagemagick_type_regen='find $HOME/Library/Fonts -type f -name '\''*.ttf'\'' | imagemagick_type_gen -f - > $HOME/Library/Fonts/type.xml'

### main #######################################################################

# Nothing here.