function ghq_peco_repo
  set selected_repository (ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_repository" ]
    cd $selected_repository
    commandline -f repaint
  end
end
