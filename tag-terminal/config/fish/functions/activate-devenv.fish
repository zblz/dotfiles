function activate-devenv
  set -l poetry_venv (poetry env info --path)
  if test -n "$poetry_venv"
    echo "Activating virtual environment from poetry"
    source $poetry_venv/bin/activate.fish
  else if test -d venv
    echo "Activating virtual environment from ./venv"
    source venv/bin/activate.fish
  else
    echo "No virtual environment found"
  end
end
