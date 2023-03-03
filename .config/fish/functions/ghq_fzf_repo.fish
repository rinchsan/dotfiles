function ghq_fzf_repo
  set selected_repository (ghq list | fzf --query "$LBUFFER")
  if [ -n "$selected_repository" ]
    cd (ghq root)/$selected_repository
    commandline -f repaint
  end
end
