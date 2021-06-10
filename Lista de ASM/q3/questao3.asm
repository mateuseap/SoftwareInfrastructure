org 0x7c00
jmp 0x0000:start

string times 30 db 0 ;declara 30 bytes com o valor 0
endl db ' ', 13, 10, 0

video_mode:
    mov ax, 0013h ;muda para o modo gráfico
    mov bh, 0 ;página de vídeo 0
    mov bl, 2 ;cor da fonte
    int 10h ;interrupção de vídeo
    ret

putc:
    mov ah, 0x0e ;número da chamada para mostrar na tela um caractere que está em al
    int 10h ;interrupção de vídeo
    ret

readc:
    mov ah, 0x00 ;número da chamada para ler um caractere do buffer do teclado e remover ele de lá
    int 16h ;interrupção do teclado
    ret ;após a execução dessa interrupção int 16h o caractere lido estará armazenado em al

prints:
    .loop:
        lodsb ;carrega uma letra de si em al
        cmp al, 0 ;checa se chegou no final da string (equivalente a um '\0)
        je .endloop 
        call putc 
        jmp .loop
    .endloop:
    ret

gets:
    mov al, 0
    .for:
        call readc
        stosb ;guarda o que está em al
        cmp al, 13
        je .fim
        call putc
        jmp .for
     .fim:
    dec di
    mov al, 0
    stosb
    mov si, endl
    call prints
    ret
        
start:
    xor ax, ax
    mov cx, ax
    mov dx, ax

    call video_mode

    mov di, string 
    call gets
    mov si, string
    call prints
    mov si, endl
    call prints

times 510-($-$$) db 0
dw 0xaa55