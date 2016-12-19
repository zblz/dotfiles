function ipython
    switch (uname)
        case Darwin
            frameworkpython -m IPython $argv
        case '*'
            ipython $argv
    end
end

