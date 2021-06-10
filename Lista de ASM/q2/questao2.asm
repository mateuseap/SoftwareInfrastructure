org 0x7c00
jmp 0x0000:start

string times 30 db 0 ;declara 30 bytes com o valor 0
endl db ' ', 13, 10, 0

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

readc:
    mov ah, 0x00 ;número da chamada para ler um caractere do buffer do teclado e remover ele de lá
    int 16h ;interrupção do teclado
    ret ;após a execução dessa interrupção int 16h o caractere lido estará armazenado em al

prints:
    .loop:
        lodsb ;carrega uma letra de si em al
        cmp al, 0 ;checa se chegou no final da string (equivalente a um '\0')
        je .endloop 
        call putc 
        jmp .loop
    .endloop:
    ret

reverse:
    mov di, si
    xor cx, cx ;zerar o contador
    .loop: ;colocando a string na pilha
        lodsb ;carrega uma letra de si em al e passa para o próximo caractere
        cmp al, 0 ;checa se já chegou ao final da string (equivalente a um '\0')
        je .endloop
        inc cl ;incrementa o contador
        push ax ;adiciona o valor de ax na pilha
        jmp .loop
    .endloop:
    .loop1: ;removendo a string da pilha
        cmp cl, 0 ;checa se o contador igual a zero, caso seja sabemos que a string já foi removida da pilha
        je .endloop1
        dec cl ;decrementa o contador
        pop ax ;remove o valor de ax da pilha
        stosb ;guarda o que está em al
        jmp .loop1

        .endloop1
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
    call reverse
    mov si, string
    call prints

times 510-($-$$) db 0
dw 0xaa55