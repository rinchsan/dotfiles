function git_fzf_branch
  set branch (git branch | fzf --query "$LBUFFER")
  if [ -n "$branch" ]
    echo -n (string replace '* ' '' $branch) | pbcopy
    commandline -f repaint
  end
end

