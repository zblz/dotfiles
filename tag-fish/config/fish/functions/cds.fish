# ~/.config/fish/functions/cds.fish

function cds -d 'Change directory to a source code repository'
    if count $argv > /dev/null
        git ls-repos | grep -i $argv[1] | read -g result
    else
        git ls-repos | fzy | read -g result
    end
    cd ~/src/$result
end
