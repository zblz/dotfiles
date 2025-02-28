status -i; or exit

set fish_greeting

set -x ARCHFLAGS -arch (uname -m)
set -x EDITOR nvim
set -x DOCKER_DEFAULT_PLATFORM linux/amd64

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
        set -gx HOMEBREW_AUTO_UPDATE_SECS 7776000 # 90 days
        source (fnm env | psub)
        fish_add_path -a /opt/homebrew/Caskroom/miniforge/base/bin
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

set -U async_prompt_functions __fish_git_prompt
set -U async_prompt_inherit_variables \
        __fish_git_prompt_showupstream \
        __fish_git_prompt_describe_style \
        __fish_git_prompt_showcolorhints \
        __fish_git_prompt_show_informative_status \
        VIRTUAL_ENV \
        CONDA_DEFAULT_ENV \
        PATH \
        status SHLVL CMD_DURATION

# Better less
set -gx LESSOPEN "| highlight %s --out-format xterm256 --line-numbers --quiet --force --style zenburn"
set -gx LESS " -R"
alias less 'less -m -N -g -i -J --line-numbers --underline-special'
alias more less

# Aliases
abbr --add vi nvim
abbr --add vim nvim
abbr --add lt 'ls -lhtr'
abbr --add cdd 'cd ~/.dotfiles'

fish_add_path -a /usr/local/sbin
# Make sure this has priority over anything else
fish_add_path ~/.local/bin

# Add SDKMAN paths to PATH
for ITEM in $HOME/.sdkman/candidates/*
    fish_add_path -a $ITEM/current/bin
end

uv generate-shell-completion fish | source
abbr --add ipython 'uvx --from ipython --with pandas --with ibis-framework[duckdb] --with requests --with pydantic --with scipy ipython'
