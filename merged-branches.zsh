function get_current_branch() {
  git rev-parse --abbrev-ref HEAD
}

function get_merged_branches() {
  local branch=$1
  git branch --merged $branch | sed 's/^[ *]*//'
}

function list_unique_merged_branches() {
  git fetch --all --prune --quiet

  current_branch=$(get_current_branch)
  echo "Current branch: $current_branch"

  merged_into_current=($(git branch -r --merged origin/$current_branch | sed 's|origin/||g' | sed 's/^[ *]*//'))
  merged_into_main=($(git branch -r --merged origin/main | sed 's|origin/||g' | sed 's/^[ *]*//'))

  unique_branches=()
  for branch in "${merged_into_current[@]}"; do
    if [[ ! " ${merged_into_main[*]} " =~ " ${branch} " ]] && [[ $branch != $current_branch ]]; then
      unique_branches+=($branch)
    fi
  done

  echo "Branches merged into $current_branch but not into main:"
  for branch in "${unique_branches[@]}"; do
    echo $branch
  done
}

# Add alias for easy use
alias mb="list_unique_merged_branches"

