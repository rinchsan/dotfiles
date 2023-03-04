######################
###  git / github  ###
######################
alias st='git status'
alias ad='git add'
alias ci='git commit'
alias di='git diff'
alias gr='git gr'
alias b='git branch'
alias co='git switch'
alias dic='git diff --cached'
alias diw='git diw'
alias g='gh'

################
###  docker  ###
################
alias dps='docker ps --format "table {{.Names}}\t{{.Command}}\t{{.Ports}}\t{{.Image}}"'

##############
###  misc  ###
##############
alias cat='bat'
alias c='cat'
alias ls='exa -F --icons'
alias l='ls'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias tree='exa -F --tree --icons'
alias o='open'
alias fd='fd --hidden'
alias rg='rg --hidden'
alias diff='colordiff'
alias cb='bd'
alias curls='curl -w "%{http_code}\n"'
alias gq='ghq'
alias gp='ghq_fzf_repo'
alias bcp='git_fzf_branch'
alias rei='restart_eikana'
alias ip='curl https://checkip.amazonaws.com/'
alias k='kubectl'
alias tmux='tmux -u'

function cd
    if test (count $argv) -gt 1
        printf "%s\n" (_ "Too many args for cd command")
        return 1
    end
    # Avoid set completions.
    set -l previous $PWD

    if test "$argv" = "-"
        if test "$__fish_cd_direction" = "next"
            nextd
        else
            prevd
        end
        return $status
    end
    builtin cd $argv
    set -l cd_status $status
    # Log history
    if test $cd_status -eq 0 -a "$PWD" != "$previous"
        set -q dirprev[$MAX_DIR_HIST]
        and set -e dirprev[1]
        set -g dirprev $dirprev $previous
        set -e dirnext
        set -g __fish_cd_direction prev
    end

    if test $cd_status -ne 0
        return 1
    end
    ls
    return $status
end
