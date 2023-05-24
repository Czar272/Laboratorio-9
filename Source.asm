;Universidad del Valle de Guatemala
;Cesar Lopez 22535, Diego Garcia 22484
;Descripcion: Laboratorio 9
;Fecha de Entrega: 24/05/2023

includelib libcmt.lib
includelib libvcruntime.lib
includelib libucrt.lib
includelib legacy_stdio_definitions.lib
extrn printf:near
extrn scanf:near
extrn exit:near


.386
.model flat, stdcall, c
.stack 4096
ExitProcess proto,dwExitCode:dword

.data

mesi    BYTE 1                                           ;contador de mes
contArr DWORD 0                                          ;Contador para cambiar de montos de facturacion
sumando DWORD 0                                          ;Suma total de montos
entr    BYTE " ",0Ah,0                                   ;Enter 
abajo   DWORD 100d                                       ;Dividir /100
arriba  DWORD 5d                                         ;Multiplicar *5

msg1 BYTE "fecha:          %d,   2022",0Ah,0                      ;Formato de vista 
msg2 BYTE "Cliente:          Pablito Pablon Pablun",0Ah,0
msg3 BYTE "NIT:          2769967-2",0Ah,0
msg4 BYTE "Monto Facturado:          %d.00",0Ah,0
msg5 BYTE "IVA:          %d.00",0Ah,0
msg6 BYTE "Monto de facturacion anual:  %d",0Ah,0
msg7 BYTE "press any key to continue", 0Ah,0
msg8 BYTE "������AVISO!!!!!! Debe actualizar su R�gimen tributario a IVA General",0Ah,0
msg9 BYTE "Puede continuar como pequenio contribuyente",0Ah,0
msg10 BYTE "Coloque el monto a facturar del mes %d:  ",0

montoMes DWORD 0
montoF DWORD 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0          ;Array para montos
IVAarr DWORD 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0                                            ;Array para IVA
format db "%d", 0

.code

public main
main    proc
    push ebp
    mov ebp, esp
        
    mov edx, 0                                              ;Para Dividir

    Repetir:
                                                            ;Contador array
        mov ebx, 4
        imul ebx, contArr

        push offset mesi
        push offset msg10 		                            ; Imprimir mensaje
        call printf
        add esp, 8

        lea  eax, montoMes 		                            ; Obtener direcci�n del buffer
        push eax 				                            ; Empujar direcci�n a la pila
        push offset format 		                            ; Empujar formato a la pila
        call scanf 				                            ; Leer cadena desde la entrada est�ndar
        add esp, 8

        mov [montoF+ebx], eax                               ;Agrega el monto dado al array de montos
                                                            
        push offset mesi                                    ;Mes, a�o, nit, Monto Facturado
        push offset msg1
        call printf
        add esp, 8

        push offset msg2
        call printf
        add esp, 4

        push offset msg3
        call printf
        add esp, 4

        push [montoF+ebx]
        push offset msg4
        call printf
        add esp, 8
                                                            
        mov eax, [montoF+ebx]
        mul arriba                                          ;Operacion IVA
        div abajo
        mov [IVAarr+ebx], eax                               ;Guardo el iva respectivo del mes en su array

        push eax
        push offset msg5    
        call printf                                         ;Muestra IVA
        add esp, 8                  

        push offset entr                                    ;Espacios 
        call printf
        add esp, 4   
        push offset entr
        call printf
        add esp, 4  
        push offset entr
        call printf
        add esp, 4                           
        									

        cmp contArr, 0                                      ;Compara Arr
        je empiezaArr
        jne sigueArr

    empiezaArr:
        mov eax, [montoF+ebx]
        mov sumando, eax
        jmp siguiente

    sigueArr:
        mov eax, sumando
        add eax, [montoF+ebx]
        mov sumando, eax
        jmp siguiente

   siguiente:

        cmp contArr, 11
        je termino
                                                            ;Comparador
        cmp mesi, 12                                        ;Para mostrar solo 12 veces
        je lp1
        jne lp2

    lp1:                                                        ;Si llega a 12 se reinicia el No. Mes
        mov mesi, 1        
        jmp Repetir

    lp2:                                                        ;Si no se suma uno a mes y contArr
        inc mesi
        inc contArr
        jmp Repetir


    termino:

        push offset sumando                                     ;Monto Final anual
        push offset msg6
        call printf
        add esp, 8                                          
        mov eax, sumando
                                                                
        cmp sumando, 150000                                     ;monto>150000 -> mediano contribuyente
        jg mayor                                                ;monto<150000 -> peque�o contribuyente
        jl menor
        je menor

           
    mayor:
        push offset msg8
        call printf
        add esp, 4
        jmp fin

    menor:
        push offset msg9
        call printf
        add esp, 4
        jmp fin

    fin:
        push offset msg7
        call printf
        add esp, 4
        
    mov esp, ebp
    pop ebp
    
	push 0
    call exit  

main    endp
         end  