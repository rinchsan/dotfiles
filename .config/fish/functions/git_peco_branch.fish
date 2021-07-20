function git_peco_branch
  set branch (git branch | peco --query "$LBUFFER")
  if [ -n "$branch" ]
    echo -n (string replace '* ' '' $branch) | pbcopy
    commandline -f repaint
  end
end

