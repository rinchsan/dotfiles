function restart_eikana
  pgrep -f ⌘英かな | xargs kill
  open /Applications/⌘英かな.app
end
