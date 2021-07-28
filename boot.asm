ORG 0
BITS 16

_start: ; some bios look for this
	jmp short start
	nop

times 33 db 0x00 ; for boot parameters---some bios need that

start:
	jmp 0x07c0:main

handle_zero:
	mov si, error_msg
	call print
	iret

handle_done:
	mov si, done_msg
	call print
	iret

main:
	cli ; clear interrupts - don't want any interrupts while running crucial setup
	mov ax, 0x07c0
	mov ds, ax ; setup ds, es segment registers
	mov es, ax
	mov ax, 0x0000
	mov ss, ax ; setup stack
	mov sp, 0x7c00
	sti ; enable interrupts

	; setup custom interrupt at start of IVT
	mov word[ss:0x00], handle_zero ; offset
	mov word[ss:0x02], ds ; segment 

	mov word[ss:0x04], handle_done ; offset
	mov word[ss:0x06], ds ; segment
	
	; int 0 ; invole interrupt 0

	mov si, message
	call print

	int 1 ; invole interrupt 1

	xor ax, ax
	div ax ; divide by zero exception: invokes interrupt 0

	jmp $ ; halt: keep jumping to the same point

print:
	mov bx, 0
.loop:
	lodsb ; used DS:SI for absolute address --- copies byte from mem addr to al register
	cmp al, 0
	je .done
	call print_char
	jmp .loop
.done:
	ret

print_char:
	mov ah, 0eh
	dw 0x10CD ; same as instruction: int 0x10 - op code
	ret

message: db 'Henlo mate!', 0
done_msg: db 'Done!', 0
error_msg: db 'Error!', 0

times 510-($ - $$) db 0

dw 0xAA55 ; indicate bios that this 512b segment is bootloader