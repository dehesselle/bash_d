# SPDX-FileCopyrightText: 2021 René de Hesselle <dehesselle@web.de>
#
# SPDX-License-Identifier: GPL-2.0-or-later

### description ################################################################

# Conveneince handling for developer information.

### shellcheck #################################################################

# shellcheck shell=bash # no shebang as this file is intended to be sourced

### dependencies ###############################################################

bash_d_include plist
bash_d_include xdg

### variables ##################################################################

DEVELOPER_SETTINGS=${DEVELOPER_SETTINGS:-$XDG_CONFIG_HOME/apple_developer.plist}

### functions ##################################################################

# Nothing here.

### aliases ####################################################################

# create developer_settings_* aliases
plist_instantiate "$DEVELOPER_SETTINGS" developer_settings

# for convenience
alias developer_get_id='developer_settings_get developer id'
alias developer_get_username='developer_settings_get developer username'

### main #######################################################################

# Nothing here.
