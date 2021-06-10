org 0x7c00
jmp 0x0000:start

numX db 0 ;criando variáveis
numY db 0
numZ db 0
numW db 0
xy db 0
zw db 0
xz db 0
temp db 0

video_mode:
    mov ax, 0013h ;muda para o modo gráfico
    mov bh, 0 ;página de vídeo 0
    mov bl, 13 ;cor da fonte
    int 10h ;interrupção de vídeo
    ret

readc:
    mov ah, 0x00 ;número da chamada para ler um caractere do buffer do teclado e remover ele de lá
    int 16h ;interrupção do teclado
    sub al, 48 ;transformando 'al' de char para int
    mov [numX], al ;salvando 'al' em numX
    mov ah, 0x00 ;a partir daqui repetimos os mesmos passos acimas para calcular os valores de y, z e w
    int 16h
    sub al, 48
    mov [numY], al
    mov ah, 0x00
    int 16h
    sub al, 48
    mov [numZ], al
    mov ah, 0x00
    int 16h
    sub al, 48
    mov [numW], al
    ret

putc:
    mov cl, [numX] ;colocando o valor de numX em 'cl'
    mov ax, 0 ;zerando 'ax'
    .loop: ;aqui basicamente somamos o numY numX vezes
        cmp cl, 0 ;comparamos se 'cl' igual a zero, para checar se terminamos a multiplicação
        je .end
        add ax, [numY] ;adicionamos o valor de numY a ax
        dec cl ;decrementamos cl, isso indica que temos menos uma soma a ser feita
        jmp .loop
    .end:
    mov [xy], ax ;atribuimos a variável 'xy' o resultado da multiplicação de x*y
    mov cl, [numZ] ;a partir daqui repetimos os mesmos passos acimas para calcular os termos restantes, z*w e x*z
    mov ax, 0 
    .loop1:
        cmp cl, 0
        je .end1
        add ax, [numW]
        dec cl
        jmp .loop1
    .end1:
    mov [zw], ax
    mov cl, [numX]
    mov ax, 0
    .loop2:
        cmp cx, 0
        je .end2
        add ax, [numZ]
        dec cl
        jmp .loop2
    .end2:
    mov [xz], ax
    mov ax, 0
    
    add ax, [xy] 
    add ax, [zw]
    sub ax, [xz] ;aqui obtemos o resultado final da fórmula da questão, "(x*y)+(z*w)-(x*z)"
    
    mov ah, 0 ;zeramos 'ah', pois vai ser utilizado para armazenar o resto da divisão de ax/cl
    mov cl, 10 ;atribuimos um valor para 'cl' que será o nosso divisor, 'ax' sera dividido por 'cl'
    div cl ;divide o valor de 'ax' por 'cl', 'al = ax/cl' e 'ah = ax%cl'

    add ah, '0' ;converte o 'ah' para char
    mov [temp], ah ;salva o valor do 'ah' em char em temp
    sub ah, '0' ;converte o 'ah' para inteiro

    add al, '0' ;printa o resultado da divisão 'al'
    mov ah, 0x0e
    int 10h

    mov al, [temp] ;printa o resto da divisão 'ah'
    mov ah, 0x0e
    int 10h
    
    ret

start:
    xor ax, ax ;zerando os registradores
    mov cx, ax
    mov dx, ax

    call video_mode
    call readc
    call putc

times 510-($-$$) db 0
dw 0xaa55