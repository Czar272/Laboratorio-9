;Universidad del Valle de Guatemala
;Cesar Lopez 22535, Diego Garcia 22484
;Descripcion: Laboratorio 9
;Fecha de Entrega: 24/05/2023

includelib libcmt.lib
includelib libvcruntime.lib
includelib libucrt.lib
includelib legacy_stdio_definitions.lib

.386
.model flat, c
.stack 4096

printf proto c : vararg
scanf proto c : vararg

.data

mesi    BYTE 1                                           ;contador de mes
contArr DWORD 0                                          ;Contador para cambiar de montos de facturacion
sumando DWORD 0                                          ;Suma total de montos
entr    BYTE " ",0Ah,0                                   ;Enter 
abajo   DWORD 100d                                       ;Dividir /100
arriba  DWORD 5d                                         ;Multiplicar *5

msg1 BYTE "Mes:          %d   Anio:          2022",0Ah,0                      ;Formato de vista 
msg2 BYTE "Cliente:          Pablito Pablon Pablun",0Ah,0
msg3 BYTE "NIT:          2769967-2",0Ah,0
msg4 BYTE "Monto Facturado:          %d",0Ah,0
msg5 BYTE "IVA:          %d",0Ah,0
msg6 BYTE "Monto de facturacion anual:  %d",0Ah,0
msg7 BYTE "press any key to continue", 0Ah,0
msg8 BYTE "¡¡¡¡¡¡AVISO!!!!!! Debe actualizar su Régimen tributario a IVA General",0Ah,0
msg9 BYTE "Puede continuar como pequenio contribuyente",0Ah,0

montoF     DWORD 1000,2000,3000,4000,5000, 6000, 7000, 8000,9000, 10000, 20000, 30000          ;Array para montos
IVAarr     DWORD 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0                                            ;Array para IVA
.code


main    proc
        
        mov edx, 0                                          ;Para Dividir

Repetir:
                                                            ;Contador array
        mov ebx, 4
        imul ebx, contArr
                                                            ;Mes, año, nit, Monto Facturado
        invoke printf,addr msg1, mesi
        invoke printf,addr msg2
        invoke printf, addr msg3
        invoke printf, addr msg4, [montoF+ebx]
                                                            ;Operacion IVA
        mov eax, [montoF+ebx]
        mul arriba
        div abajo
        mov [IVAarr+ebx], eax                               ;Guardo el iva respectivo del mes en su array

        
        invoke printf, addr msg5, eax                       ;Muestra IVA
        invoke printf, addr entr                            ;Espacios 
        invoke printf, addr entr
        invoke printf, addr entr                           
        									

        cmp contArr, 0                                      ;Comparamos Arr
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

        invoke printf, addr msg6, sumando                   ;Monto Final anual
        mov eax, sumando
                                                            ;monto>150000 -> mediano contribuyente 
                                                            ;monto<150000 pequeño contribuyente
        cmp sumando, 150000
        jg mayor
        jl menor
        je menor

           
mayor:
        invoke printf, addr msg8
        jmp fin

menor:
        invoke printf, addr msg9
        jmp fin
fin:

        invoke printf, addr msg7
        invoke scanf       
        

main    endp
         end  