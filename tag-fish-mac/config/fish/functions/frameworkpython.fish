function frameworkpython
   if set -q VIRTUAL_ENV
        begin
            set -lx PYTHONHOME $VIRTUAL_ENV
            /usr/local/bin/python3 $argv
        end
    else
        /usr/local/bin/python3 $argv
    end
end
