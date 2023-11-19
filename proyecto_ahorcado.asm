; Juego del ahorcado
macro imprimeM msj
    lea dx, msj
    mov ah, 9
    int 21h
endm

data segment
    ; add your data here!
    enter db 10, 13, "$"
    espacio db "_$"
    espacio2 db " $"
   limpiaLinea db 13, "                                   ", 13, "$"
    bienvenida db "Bienvenido al juego del ahorcado :D", 10, 13, "$"
    msj1 db "Ingrese la palabra a buscar: $"
    msj2 db "Ingrese una pista: $"
    msj3 db "PISTA: ", 10, 13, "$"
    msj4 db "Ingrese una letra: $"
    msj5 db "     letra: $"
    gano    db "      GANADOR      "
            db "        :D        $"
    termino db "     GAME OVER     "
            db "        :C        $"
    
    bloqueBlanco db 10, 13, "                                   "
                 db "                                   "
                 db "                                   "
                 db "                                   "
                 db "                                   $"
    contadorP dw 0
    intentos dw 0
    pista db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "$"
    palabra  db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "$"
    palabraB db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "$"
    
    
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax
    ; ===== INICIO ===== ;
    
; * Bienvenida
    imprimeM bienvenida
    imprimeM msj1
    mov si, offset palabra
    mov cx, 0
   lectura:
    mov ah, 1
    int 21h
    
    cmp al, 13
    jz finLectura
    mov [si], al
    inc si
    inc cx
    jmp Lectura
   finLectura:
    mov contadorP, cx ; Guardamos la cantidad
                      ; de palabras
   
    imprimeM enter ; enter
; * Pista
    imprimeM msj2
    mov si, offset pista
    lectura2:
    mov ah, 1
    int 21h
    
    cmp al, 13
    jz finLectura2
    mov [si], al
    inc si
    jmp Lectura2
   finLectura2:
    
   
; * Preguntamos    
    ; modo de video (720x400)
    mov ax, 12h
    int 10h
    
    ; Pistas
    imprimeM bienvenida
    imprimeM enter
    imprimeM msj3
    imprimeM enter
    imprimeM enter
    imprimeM enter
    imprimeM pista
    imprimeM enter
    imprimeM enter
    imprimeM enter
    imprimeM enter
    imprimeM msj4
    imprimeM enter
    imprimeM enter
    imprimeM enter
    imprimeM enter
   
; * ===== Empieza el juego ===== *

; 1. Verifica cuantas palabras tiene    
   verifica:    
    imprimeM limpiaLinea ; Limpia linea
    mov si, offset palabraB ; PalabraB = palabra que forma el usuario
    mov cx, contadorP
   cuenta:
    imprimeM espacio2
    mov bx, 0
    mov bl, [si]
    cmp bl, 0
    jz imprimeEspacio
    
    ; Imprime el valor del vector
    mov dx, bx
    mov ah, 2
    int 21h
    jmp sigCuenta
   imprimeEspacio:
    imprimeM espacio
    
    sigCuenta:
    inc si
    loop cuenta


; * Verifica si ya encontro la palabra
    mov si, offset palabra  ; palabra a encontrar
    mov di, offset palabraB ; palabra del usuario
    mov cx, contadorP
   verificarPalabra:
    mov ax, 0
    mov bx, 0
    mov al, [si]
    mov bl, [di]
    
    cmp al, bl
    jz sigVerificar
    jmp digiteLetra ; si no es igual que siga buscando
    
    ; Verifica cada caracter
    sigVerificar:
     inc si
     inc di
   loop verificarPalabra
   ; A ganado :D
    imprimeM enter
    imprimeM enter
    imprimeM bloqueBlanco
    imprimeM gano
    jmp sigFinal
    
; * Digite una letra
   digiteLetra:
    imprimeM msj5
    mov ah, 1
    int 21h
    
    ; Verificamos si esta caracter se
    ; encuentra en la cadena
    mov si, offset palabra
    mov di, offset palabraB
    mov cx, contadorP
    mov dx, 0   ; Bandera para verificar si acerto
   busca:
    mov bx, 0
    mov bl, [si]
    cmp al, bl
    jz  colocaLetra
    jmp sigB
    
    ; coloca el caracter a la palabra usuario
   colocaLetra:
    mov [di], al
    mov dx, 1
    
    
   sigB:
    inc si
    inc di
   loop busca
   
   ; Verificando si la letra estaba
   ; en la palabra
   cmp dx, 1
   jz correcto
  ;incorrecto:
   mov cx, intentos
   inc cx
   mov intentos, cx
   cmp cx, 1
   jz primerIntento
   cmp cx, 2
   jz segundoIntento
   cmp cx, 3
   jz tercerIntento
   cmp cx, 4
   jz cuartoIntento
   cmp cx, 5
   jz quintoIntento
   cmp cx, 6
   jz sextoIntento 
  ;cmp cx, 7
   jmp septimoIntento
   primerIntento:
    mov bx, 0
    mov cx, 50
    mov dx, 200
    call pendientePosi
    
    mov bx, 0
    mov cx, 60
    mov dx, 190
    call pendienteNega
    
    mov bx, 0
    mov cx, 60
    mov dx, 190
    call rectaV
   jmp sigIncorrecto
   
   segundoIntento:
    mov bx, 0
    mov cx, 60
    mov dx, 140
    call rectaH
   jmp sigIncorrecto
   
   tercerIntento:
    mov bx, 40
    mov cx, 90
    mov dx, 150 
    call rectaV
   jmp sigIncorrecto
   
   cuartoIntento:
    mov bx, 22
    mov cx, 87
    mov dx, 150
    call rectaH
    
    mov bx, 22
    mov cx, 87
    mov dx, 158
    call rectaH
    
    mov bx, 42
    mov cx, 87
    mov dx, 158
    call rectaV
    
    mov bx, 42
    mov cx, 95
    mov dx, 158
    call rectaV
   jmp sigIncorrecto
   
   quintoIntento:
    mov bx, 35
    mov cx, 90
    mov dx, 173 
    call rectaV
   jmp sigIncorrecto
    
   sextoIntento:
    mov bx, 6
    mov cx, 86
    mov dx, 167 
    call pendientePosi
    mov bx, 6
    mov cx, 91
    mov dx, 163
    call pendienteNega
   jmp sigIncorrecto
    
   septimoIntento:
    mov bx, 6
    mov cx, 86
    mov dx, 177 
    call pendientePosi
    mov bx, 6
    mov cx, 91
    mov dx, 173
    call pendienteNega
   jmp sigIncorrecto
   sigIncorrecto:
   
    correcto:
   
; * Verifica si tiene mas intentos
    mov cx, intentos
    cmp cx, 7
    jz gameOver
    jmp verifica
   
   
   ; A perdido :c
   gameOver:
    imprimeM enter
    imprimeM bloqueBlanco
    imprimeM termino
   
   sigFinal:
    ; ===== FIN ===== ;
    mov ax, 4C00h
    int 21h
ends

proc pendientePosi
    mov ax, 0A000h
    mov es, ax
   lineaPP:
    mov ah, 0ch
    mov al, 09h
    int 10h
    
    inc cx
    dec dx
    inc bx
    cmp bx, 10
    jz finPP
    jmp lineaPP
   finPP:
    ret
endp

proc pendienteNega
    mov ax, 0A000h
    mov es, ax
   lineaPN:
    mov ah, 0ch
    mov al, 09h
    int 10h   
    
    inc cx
    inc dx
    inc bx
    cmp bx, 10
    jz finPN
    jmp lineaPN
   finPN:
    ret
endp

proc rectaV
    mov ax, 0A000h
    mov es, ax
   lineaRV:
    mov ah, 0ch
    mov al, 09h
    int 10h
    
    dec dx
    inc bx
    cmp bx, 50
    jz finRV
    jmp lineaRV
   finRV:
    ret
endp

proc rectaH
    mov ax, 0A000h
    mov es, ax
   lineaRH:
    mov ah, 0ch
    mov al, 09h
    int 10h
    
    inc cx
    inc bx
    cmp bx, 30
    jz finRH
    jmp lineaRH
   finRH:
    ret
endp