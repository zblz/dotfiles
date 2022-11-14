# ~/.config/fish/functions/cds.fish

function cds -d 'Change directory to a source code repository'
    if count $argv > /dev/null
        git find-repos $HOME/src | grep -i $argv[1] | read -g result
    else
        git find-repos $HOME/src | fzf | read -g result
    end
    cd ~/src/$result
end
