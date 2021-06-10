org 0x7c00
jmp 0x0000:start

imagem db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 7, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 8, 7, 8, 8, 8, 8, 0, 0, 0, 0, 8, 8, 0, 0, 0, 0, 8, 8, 8, 8, 3, 1, 8, 8, 8, 8, 1, 8, 0, 0, 0, 0, 0, 0, 8, 8, 1, 3, 9, 9, 8, 1, 9, 8, 0, 0, 0, 0, 0, 0, 8, 8, 9, 9, 15, 15, 9, 9, 9, 8, 0, 0, 0, 0, 8, 0, 8, 9, 9, 9, 9, 3, 9, 9, 9, 1, 0, 0, 0, 0, 8, 8, 8, 9, 15, 15, 15, 3, 9, 9, 9, 1, 0, 0, 0, 0, 8, 0, 8, 9, 9, 9, 15, 15, 9, 9, 3, 8, 0, 0, 0, 0, 8, 8, 8, 8, 8, 9, 9, 9, 9, 8, 8, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 8, 1, 9, 9, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ;reserva espaço na memória para a string (declara a bandeirola)

initVideo:
	mov ah, 0	;function code 0 (é pra setar o video mode)
	mov al, 13h ;parâmetro da função
	int 16		;interrupção 16, ou 10h é quem vai prover serviços de video (printar na tela e etc)
	ret			;retorna pra o ponto anterior

 start:
    xor ax, ax  ;zera ax, xor é mais rápido que mov (usado pra receber resultado de calculos)
    mov cx, ax  ;zera cx (counter register, usado para contar repetições e em loops)
    mov dx, ax  ;zera dx (Usado em operações de entrada e saída por portas físicas para armazenar o dado )

    call initVideo ;vai para a "função initVideo"

    mov si,imagem					;move a variável imagem para o registrador de string DS:SI

    .for1:
  		cmp dx, 16    				;comparador=for do C
  		je .endfor1					;je é como se fosse um if, se atender à comparação, pula pra "parte" assinalada
  		mov cx, 0 					;coluna
  		.for2:
  			cmp cx, 16
  			je .endfor2
        lodsb						;loadString (carrega a string do si no registrador al)
        mov ah,0ch					;vai setar o ah pra escrever pixels gráficos
        int 10h						;interrupção do sistema pra processos em video
  			inc cx 				;incrementador de cx
  			jmp .for2
  		.endfor2:
  		inc dx					;incrementador de dx
  		jmp .for1
  	.endfor1:
      jmp end

end:
    jmp $


times 510 - ($ - $$) db 0
dw 0xaa55