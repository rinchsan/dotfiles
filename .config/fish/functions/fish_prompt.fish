function fish_prompt
    # Main
    echo ''
    echo (set_color white)(date '+%Y/%m/%d %T') (set_color FFA400)(pwd)
    echo -n (set_color red)'❯'(set_color yellow)'❯'(set_color green)'❯'

	# Git
    set_color normal
	set last_status $status
    printf '%s ' (__fish_git_prompt)
end
