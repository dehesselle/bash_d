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

alias assert_darwin='[ "$(uname)" = "Darwin" ] && true || (echo_e "Darwin required" && return 1)'
alias assert_linux='[ "$(unamne)" = "Linux"] && true || (echo_e "Linux required" && return 1)'

alias assert_bash4_and_above='[ ${BASH_VERSINFO[0]} -ge 4 ] && true || (echo_e "bash 4.x or above required" && return 1)'

### main #######################################################################

# Nothing here.
