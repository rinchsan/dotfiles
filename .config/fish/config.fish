source ~/.config/fish/env.fish
source ~/.config/fish/eval.fish
source ~/.config/fish/alias.fish
source ~/.config/fish/git.fish
if test -e ~/.env
  source ~/.env
end
if test -e ~/.config/fish/ignored.fish
  source ~/.config/fish/ignored.fish
end
