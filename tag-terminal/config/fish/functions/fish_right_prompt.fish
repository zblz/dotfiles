function fish_right_prompt -d "Write out the right prompt"
    if set -q VIRTUAL_ENV
		echo -n -s (set_color brblue) "(" (basename "$VIRTUAL_ENV") "|" (python --version | cut -f 2 -d ' ') ")" (set_color normal) " "
	end
end
