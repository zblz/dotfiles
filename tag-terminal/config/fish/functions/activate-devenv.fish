function activate-devenv
  set -l poetry_venv (poetry env info --path 2> /dev/null)
  if test -d venv
    echo "Activating local virtual environment `./venv`"
    source venv/bin/activate.fish
  else if test -d .venv
    echo "Activating local virtual environment `./.venv`"
    source .venv/bin/activate.fish
  else if test -n "$poetry_venv"
    echo "Activating poetry virtual environment"
    source $poetry_venv/bin/activate.fish
  else
    echo "No virtual environment found"
  end
end
