get_current_branch() {
  git rev-parse --abbrev-ref HEAD
}

get_merged_branches() {
  local branch=$1
  git branch --merged $branch | sed 's/^[ *]*//'
}

list_unique_merged_branches() {
  current_branch=$(get_current_branch)
  echo "Current branch: $current_branch"

  merged_into_current=($(get_merged_branches $current_branch))
  merged_into_main=($(get_merged_branches main))

  # Find branches merged into current branch but not into main or the current branch itself
  unique_branches=()
  for branch in $merged_into_current; do
    if [[ ! " ${merged_into_main[@]} " =~ " ${branch} " ]] && [[ $branch != $current_branch ]]; then
      unique_branches+=($branch)
    fi
  done

  echo "Branches merged into $current_branch but not into main:"
  for branch in $unique_branches; do
    echo $branch
  done
}

alias merged_branches="list_unique_merged_branches"
