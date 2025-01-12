start
break *main+625
commands
    silent
    jump *main+686
    set $rdx = *(unsigned long long*)($rbp-0x18)
    printf "Secret value: %llx\n", $rdx
    continue
end

