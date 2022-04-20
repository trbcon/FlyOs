start:
    mov ax,0002h    
    int 10h
        xor dx,dx
        call SetCursorPos   
                                 
        mov bp, msg
        mov cx, 4
        call PrintMes 
         
        mov dl,0
        mov dh,1
        call SetCursorPos
        mov bp, helper
        mov cx,54
        call PrintMes     
         
Option:                    
        mov ah,10h
        int 16h
        cmp ah, 3Bh         
        jz Load_text
        cmp al, 1Ch         
        jz Print_text
    jmp Option
         
Load_text:                 
    mov ax,0000h
        mov es,ax
        mov bx,string         
        mov ch,0            
        mov cl,4            
        mov dh,0            
        mov dl,80h          
        mov al,01h          
        mov ah,02h
        int 13h
        xor dl,dl
        mov dh,3
        call SetCursorPos
        mov bp, string
        mov cx, 256
        call PrintMes
        mov si,255
        add dl, 15          
        add dh,3
        call SetCursorPos
        jmp cmd
         
Print_text:
        xor dx,dx
        add dh,3
        call SetCursorPos  
        mov si,0            
cmd: 
    mov ah,10h
        int 16h
        cmp al, 1Bh     
        jz Esc
        cmp al, 1Ch     
        jz Caret
        cmp ah, 0Eh     
        jz Delete_sym
        cmp ah, 3Ch     
        jz Save_text
        cmp si, 256
        jz cmd
        mov [string + si],al
        inc si
        mov ah,09h
        mov bx,0004h
        mov cx,1
        int 10h
        add dl,1
        call SetCursorPos
    jmp cmd
         
Caret:  
    add dh,1
    xor dl,dl
        call SetCursorPos
        jmp cmd
         
Save_text:  
    mov ax,0000h
        mov es,ax
    mov ah, 03h
    mov al,1
    mov ch,0
    mov cl,4
    mov dh,0
    mov dl,80h
    mov bx, string
    int 13h
    jmp cmd
         
Delete_sym: 
    cmp dl,0
    jne Delete
    cmp dh,3
    jz cmd
    sub dh,1
    mov dl,79
    jmp Cursor_Pos
Delete:     sub dl,1            
Cursor_Pos: 
    call SetCursorPos
    mov al,20h          
    mov [string + si],al 
    mov ah,09h
        mov bx,0004h
        mov cx,1
        int 10h
        cmp si,0
        jz cmd
        dec si              
    jmp cmd
Esc:     
    jmp input
