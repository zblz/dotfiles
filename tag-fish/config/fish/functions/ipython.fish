function ipython
    switch (uname)
        case Darwin
            frameworkpython -m IPython $argv
        case '*'
            python -m IPython $argv
    end
end

