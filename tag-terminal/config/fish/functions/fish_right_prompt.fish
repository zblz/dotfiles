function fish_right_prompt -d "Write out the right prompt"
        if test -n "$CONDA_DEFAULT_ENV"
                set __fish_python_env "$CONDA_DEFAULT_ENV|conda"
        else if test -n "$VIRTUAL_ENV"
                set __fish_python_env "$VIRTUAL_ENV|venv"
        end

        if test -n "$__fish_python_env"
                echo -n -s (set_color brblue) "(" (basename "$__fish_python_env") "|" (python --version | cut -f 2 -d ' ') ")" (set_color normal) " "
        end
end
