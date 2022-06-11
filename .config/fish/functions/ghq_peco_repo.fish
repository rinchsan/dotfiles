function ghq_peco_repo
  set selected_repository (ghq list | peco --query "$LBUFFER")
  if [ -n "$selected_repository" ]
    cd (ghq root)/$selected_repository
    commandline -f repaint
  end
end
