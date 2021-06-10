org 0x7c00
jmp 0x0000:start

msg db 'Malu eh uma otima monitora', 13, 10, 0
temp times 30 db 0

video_mode:
    mov ax, 0013h ;muda para o modo gráfico
    mov bh, 0 ;página de vídeo 0
    mov bl, 13 ;cor da fonte
    int 10h ;interrupção de vídeo
    ret

putc:
    mov ah, 0x0e ;número da chamada para mostrar na tela um caractere que está em al
    int 10h ;interrupção de vídeo
    ret

getc:
    mov ah, 0x00 ;número da chamada para ler um caractere do buffer do teclado e remover ele de lá
    int 16h ;interrupção do teclado
    ret ;após a execução dessa interrupção int 16h o caractere lido estará armazenado em al

delc:
    mov al, 0x08
    call putc
    mov al, ''
    call putc
    mov al, 0x08
    call putc
    ret

endl:
    mov al, 0x0a
    call putc
    mov al, 0x0d
    call putc
    ret

prints:
    .loop:
        lodsb ;carrega uma letra de si em al
        cmp al, 0 ;checa se chegou no final da string (equivalente a um '\0')
        je .endloop 
        call putc 
        jmp .loop
    .endloop:
    ret

gets:
    xor cx, cx
    .loop:
        call getc
        cmp al, 0x08
        je .backspace
        cmp al, 0x0d
        je .done
        cmp cl, 50
        je .loop
        stosb
        inc cl
        call putc
        jmp .loop
        .backspace:
            cmp cl, 0
            je .loop
            dec di
            dec cl
            mov byte[di], 0
            call delc
            jmp .loop
        .done:
            mov al, 0
            stosb
            call endl
        ret

stoi:
    xor cx, cx
    xor ax, ax
    .loop:
        push ax
        lodsb
        mov cl, al
        pop ax
        cmp cl, 0
        je .endloop

        sub cl, 48
        mov bx, 10
        mul bx
        add ax, cx
        jmp .loop
    .endloop:
        ret

start:
    xor ax, ax
    mov cx, ax
    mov dx, ax

    call video_mode

    mov di, temp
    call gets

    mov si, temp
    call stoi
    
    mov [temp], al

    mov ax, 0013h ;muda para o modo gráfico
    ;mov bh, 0 ;página de vídeo 0
    mov bl, [temp] ;cor da fonte
    int 10h ;interrupção de vídeo
    
    mov si, msg
    call prints
    
times 510-($-$$) db 0
dw 0xaa55