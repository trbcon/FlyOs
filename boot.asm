org 7c00h

message:
	
	cli            
    xor ax,ax      
    mov ds,ax    
    mov es,ax   
    mov ss,ax    
    mov sp,07C00h
    sti
	
	loados:
		mov ax, 0002h
			int 10h
			 
		mov dx,0h
        call SetCursorPos
         
        mov bp,los             
        mov cx, 14
        call PrintMes
         
        add dh,1
        call SetCursorPos
        mov bp, ldos        
        mov cx, 11
        call PrintMes
		
		add dh,2
		call SetCursorPos
		mov si,0
                 
         mov ah,10h
         int 16h
			jz input
	
	input:
		mov ax, 0002h
			int 10h
			 
		mov dx,0h
		call SetCursorPos
			mov bp, msge
			mov cx, 29
			mov bl,04h                  
			xor bh,bh
			mov ax,1301h
			int 10h
			 
			add dh,2
			call SetCursorPos
			mov si,0

main:       
	Command: 
		mov ah,10h
			int 16h
			cmp ah, 0Eh
			jz Delete_symbol
			cmp ah, 1Ch 
			jz Input_Command
			mov [string+si],al
			inc si
			mov ah,09h
			mov bx,0004h
			mov cx,1
			int 10h
			add dl,1
		call SetCursorPos
		jmp Command
			 
	Input_Command:
		mov ax,cs
		mov ds,ax
		mov es,ax
		mov di,string
		push si
		mov si,abt
		mov cx,5
		rep cmpsb 
		je wrt
		pop si
		
		mov ax,cs
		mov ds,ax
		mov es,ax
		mov di,string
		push si   
		mov si,goback
		mov cx,4
		rep cmpsb 
		je mn
		pop si
		
		mov ax,cs
		mov ds,ax
		mov es,ax
		mov di,string
		push si   
		mov si,writercall
		mov cx,5
		rep cmpsb 
		je write
		pop si
		
		mov ax,cs
		mov ds,ax
		mov es,ax
		mov di,string
		push si     
		mov si,off
		mov cx,3
		rep cmpsb 
		je off_pc
		pop si
		
		mov ax,cs
		mov ds,ax
		mov es,ax
		mov di,string
		push si     
		mov si,help
		mov cx,3
		rep cmpsb 
		je helpdef
		pop si
			 
	Delete_symbol:
		cmp dl,0
		jz Command
		sub dl,1       
		call SetCursorPos
		mov al,20h     
		mov [string + si],al 
		mov ah,09h
		mov bx,0004h
			mov cx,1
			int 10h
			dec si
		jmp Command
	
	
	wrt:
		mov ax,0000h
			mov es,ax
			mov bx,700h         
			mov ch,0 
			mov cl,03h
			mov dh,0      
			mov dl,80h 
			mov al,01h   
			mov ah,02h
			int 13h
		jmp about
	
	mn:
		mov ax,0000h
			mov es,ax
			mov bx,700h         
			mov ch,0  
			mov cl,03h      
			mov dh,0     
			mov dl,80h    
			mov al,01h          
			mov ah,02h
			int 13h
		jmp input
		
	write:
		mov ax,0000h
			mov es,ax
			mov bx,700h         
			mov ch,0      
			mov cl,03h      
			mov dh,0         
			mov dl,80h        
			mov al,01h          
			mov ah,02h
			int 13h
		jmp writer
		
	helpdef:
		mov ax,0000h
			mov es,ax
			mov bx,700h         
			mov ch,0     
			mov cl,03h    
			mov dh,0         
			mov dl,80h    
			mov al,01h   
			mov ah,02h
			int 13h
		jmp helpmsge
	
	SetCursorPos:       
			mov ah,2h
			xor bh,bh
			int 10h 
			ret

PrintMes:                  
        mov bl,04h        
        mov ax,1301h
        int 10h
        ret     


writer:
	include 'hello.asm'

about:
	mov ax, 0002h 
	int 10h

	mov dx,0h
	call SetCursorPos
		mov bp, Con
		mov cx, 10
		call PrintMes
		add dh,2            
		call SetCursorPos
		mov si,0
	jz main

off_pc:
	mov     ah,0Dh
	int     21h
	mov     ax,5300h
	xor     bx,bx
	int     15h
	jb      Ext
	mov     ax,5301h
	xor     bx,bx
	int     15h
	mov     ax,5308h
	mov     bx,0FFFFh
	mov     cx,0001h
	int     15h
	mov     ax,5307h
	mov     bx,0001h
	mov     cx,0003h
	int     15h
	Ext:int     20h
	
helpmsge:
	mov ax, 0002h  
	int 10h

	mov dx,0h
	call SetCursorPos
		mov bp, helpmsg
		mov cx, 103
		call PrintMes
		add dh,2            
		call SetCursorPos
		mov si,0
	jz main
	
include 'variables.txt'
string db 256 dup(?) 

