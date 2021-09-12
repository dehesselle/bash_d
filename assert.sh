# SPDX-FileCopyrightText: 2021 René de Hesselle <dehesselle@web.de>
#
# SPDX-License-Identifier: GPL-2.0-or-later

### description ################################################################

# This file provides a mechanism to restrict sourcing a script to specific
# platforms.

### shellcheck #################################################################

# shellcheck shell=bash # no shebang as this file is intended to be sourced

### includes ###################################################################

include_guard
include_file echo

### variables ##################################################################

# Nothing here.

### functions ##################################################################

# Nothing here.

### aliases ####################################################################

# Bash version
alias assert_bash4_and_above='[ ${BASH_VERSINFO[0]} -lt 4 ] && echo_e "bash 4.x or above required" && return 1 || true'

# Unix platforms
alias assert_darwin='[ "$(uname)" != "Darwin" ] && echo_e "Darwin required" && return 1 || true'
alias assert_linux='[ "$(uname)" != "Linux" ] && echo_e "Linux required" && return 1 || true'

### main #######################################################################

# Nothing here.
