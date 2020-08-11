# SPDX-License-Identifier: GPL-2.0-or-later
# https://github.com/dehesselle/bash_d

include_guard

### includes ###################################################################

# Nothing here.

### variables ##################################################################

# Nothing here.

### functions ##################################################################

# Nothing here.

### aliases ####################################################################

# install YCM as usually required after an update
alias youcompleteme_install='MY_DIR=$(pwd); cd $HOME/.vim/plugged/youcompleteme; python3 install.py --clang-completer; cd $MY_DIR; unset MY_DIR'

### main #######################################################################

# Nothing here.