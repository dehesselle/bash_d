include_guard

### includes ###################################################################

include_file echo_.sh

### variables ##################################################################

# Nothing here.

### functions ##################################################################

function git_delete_current_commit
{
  echo -e "$(git --no-pager log -1)\n\n"
  echo -n "Delete this (yes/NO): "
  local response
  read response

  if [ "$response" = "yes" ]; then
    git reset --hard HEAD~1
  else
    echo "cancelled"
  fi
}

### aliases ####################################################################

alias git_delete_remote_ref='git push origin --delete' # branch or tag
alias git_ignore_changes_add='git update-index --skip-worktree'
alias git_ignore_changes_del='git update-index --no-skip-worktree'
alias git_ignore_changes_list='git ls-files -v . | grep ^S'

### main #######################################################################

# Nothing here.