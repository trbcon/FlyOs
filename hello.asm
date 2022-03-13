start:
    mov ax,0002h    
    int 10h
        xor dx,dx
        call SetCu   
                                 
        mov bp, msg
        mov cx, 24
        call Pri  
         
        mov dl,0
        mov dh,1
        call SetCu  
        mov bp, helper
        mov cx,77
        call Pri     
         
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
        call SetCu
        mov bp, string
        mov cx, 256
        call Pri
        mov si,255
        add dl, 15          
        add dh,3
        call SetCu
        jmp cmd
         
Print_text:
        xor dx,dx
        add dh,3
        call SetCu   
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
        call SetCu
    jmp cmd
         
Caret:  
    add dh,1
    xor dl,dl
        call SetCu
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
    call SetCu
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
         
  Pri:               
        mov bl,04h          
        mov ax,1301h
        int 10h
        ret
        SetCu:        
			mov ah,2h
			xor bh,bh
			int 10h 
			ret
        msg db 'This is a text writer...',0 
        helper db 'To print text - press Enter, to load text - press F1, to save text - press F2',0