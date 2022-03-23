status -i; or exit

set fish_greeting

set -x ARCHFLAGS -arch (uname -m)
set -x EDITOR nvim

# Python variables

# set -x PIP_REQUIRE_VIRTUALENV "true"
set -x PIP_USE_WHEEL true
set -x PIP_CACHE_DIR "$HOME/.cache/pip"
set -x PIP_WHEEL_DIR "$PIP_CACHE_DIR/wheels"
set -x PIP_FIND_LINKS "$PIP_WHEEL_DIR"
set -x PIP_TIMEOUT 15
set -x PIP_ALLOW_ALL_EXTERNAL false
set -x PIP_NO_ALLOW_INSECURE false

switch (uname)
    case Darwin
        fish_add_path /opt/homebrew/bin
        fish_add_path /opt/homebrew/sbin
        status is-login; and pyenv init --path | source
        status is-interactive; and pyenv init - | source
        source (fnm env | psub)
        source (conda shell.fish hook | grep -v "conda activate base" | psub)
    case '*'
        if test -d /opt/anaconda
            fish_add_path /opt/anaconda/bin
            source /opt/anaconda/etc/fish/conf.d/conda.fish
            alias workon 'conda activate'
            complete -f -c workon -a '(__fish_conda_envs)'
            workon Python3
        end
end

# Source any files matching /etc/profile.d/*.fish
for file in /etc/profile.d/*.fish
    source $file
end

set __fish_git_prompt_show_informative_status true
set -g __fish_git_prompt_showupstream auto
set -g __fish_git_prompt_describe_style branch
set -g __fish_git_prompt_showcolorhints true

# Better less
set -gx LESSOPEN "| highlight %s --out-format xterm256 --line-numbers --quiet --force --style zenburn"
set -gx LESS " -R"
alias less 'less -m -N -g -i -J --line-numbers --underline-special'
alias more less

# Aliases
abbr --add vi nvim
abbr --add vim nvim
abbr --add lt 'ls -lhtr'

alias start_conda 'source (conda info --root)/etc/fish/conf.d/conda.fish'

alias tmux 'tmux -2'

abbr --add cdd 'cd ~/.dotfiles'

fish_add_path -a /usr/local/sbin
# Make sure this has priority over anything else
fish_add_path ~/.local/bin

# Add SDKMAN paths to PATH
for ITEM in $HOME/.sdkman/candidates/*
    fish_add_path -a $ITEM/current/bin
end
