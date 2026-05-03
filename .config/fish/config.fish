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

string match -q "$TERM_PROGRAM" "kiro" and . (kiro --locate-shell-integration-path fish)

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
