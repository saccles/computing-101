start
break *main+709
commands
    silent
    set $random_value = *(unsigned long long*)($rbp-0x18)
    printf "Secret value: %llx\n", $random_value
    continue
end

