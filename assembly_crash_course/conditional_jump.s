.intel_syntax noprefix
.global _start

_start:
    # assume edi = x, esi is temporary storage, and eax is output

    mov esi, [edi]

    cmp esi, 0x7f454c46
    jne not_0x7f454c46
    # if esi = 0x7f454c46, esi = [edi+4] + [edi+8] + [edi+12]
    mov esi, [edi+4]
    add esi, [edi+8]
    add esi, [edi+12]
    jmp done

not_0x7f454c46:
    cmp esi, 0x00005A4D
    jne not_0x7f454c46_or_0x00005A4D
    # otherwise, if esi = 0x00005A4D, esi = [edi+4] - [edi+8] - [edi+12]
    mov esi, [edi+4]
    sub esi, [edi+8]
    sub esi, [edi+12]
    jmp done

not_0x7f454c46_or_0x00005A4D:
    # otherwise, esi = [edi+4] * [edi+8] * [edi+12]
    mov esi, [edi+4]
    imul esi, [edi+8]
    imul esi, [edi+12]

done:
    mov eax, esi

