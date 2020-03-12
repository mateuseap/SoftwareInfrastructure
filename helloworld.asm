org 0x7c00
jmp 0x0000:start

hello db 'Hello, World!', 13, 10, 0

start:
    xor ax, ax
    mov ds, ax
    mov es, ax

    mov si, hello
    call print_string

    jmp end

print_string:
    lodsb  
    cmp al, 0
    je .done

    mov ah, 0eh
    int 10h
    jmp print_string
    .done:
        ret

end: 
    jmp $

times 510-($-$$) db 0
dw 0xaa55