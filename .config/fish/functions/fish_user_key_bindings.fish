function fish_user_key_bindings
    bind \cd 'if test (commandline | string length) -eq 0; exit; else; commandline -f delete-char; end'
end
