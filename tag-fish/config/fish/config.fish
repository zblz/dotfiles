set fish_greeting

set -x ARCHFLAGS "-arch x86_64"
set -x EDITOR nvim
set -x LC_ALL en_US.UTF-8

# Python variables

# set -x PIP_REQUIRE_VIRTUALENV "true"
set -x PIP_USE_WHEEL "true"
set -x PIP_CACHE_DIR "$HOME/.cache/pip"
set -x PIP_WHEEL_DIR "$PIP_CACHE_DIR/wheels"
set -x PIP_FIND_LINKS "$PIP_WHEEL_DIR"
set -x PIP_TIMEOUT 15
set -x PIP_ALLOW_ALL_EXTERNAL "false"
set -x PIP_NO_ALLOW_INSECURE "false"


path_prepend ~/.local/bin
set -g fish_user_paths "/usr/local/sbin" $fish_user_paths

switch (uname)
    case Darwin
        if test -d ~/miniconda3
            path_prepend ~/miniconda3/bin
            source (conda info --root)/etc/fish/conf.d/conda.fish
            alias workon 'conda activate'
            complete -f -c workon -a '(__fish_conda_envs)'
        end
    case '*'
        if test -d ~/anaconda
            path_prepend ~/anaconda/bin
            source (conda info --root)/etc/fish/conf.d/conda.fish
            alias workon 'conda activate'
            complete -f -c workon -a '(__fish_conda_envs)'
            workon Python3
        else
            # Set up virtualfish
            set -x WORKON_HOME "$HOME/virtualenvs"
            set -x PROJECT_HOME "$HOME/projects"
            set -g VIRTUALFISH_HOME $WORKON_HOME
            set -g VIRTUALFISH_COMPAT_ALIASES "True"
            eval (python -m virtualfish compat_aliases auto_activation global_requirements)
        end
end

set __fish_git_prompt_show_informative_status true
set -g __fish_git_prompt_showupstream         auto
set -g __fish_git_prompt_describe_style       branch
set -g __fish_git_prompt_showcolorhints       true

# Better less
set -gx LESSOPEN "| highlight %s --out-format xterm256 --line-numbers --quiet --force --style zenburn"
set -gx LESS " -R"
alias less 'less -m -N -g -i -J --line-numbers --underline-special'
alias more 'less'
# alias cat "highlight $1 --out-format xterm256 --line-numbers --quiet --force --style zenburn"

# Aliases
alias vi 'nvim'
alias vim 'nvim'
alias lt 'ls -lhtr'

alias start_conda 'source (conda info --root)/etc/fish/conf.d/conda.fish'

alias tmux 'tmux -2'

alias cdd 'cd ~/.dotfiles'
