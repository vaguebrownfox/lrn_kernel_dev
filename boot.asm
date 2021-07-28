ORG 0
BITS 16

_start: ; some bios look for this
	jmp short start
	nop

times 33 db 0x00 ; for boot parameters---some bios need that

start:
	jmp 0x07c0:main

main:
	cli ; clear interrupts - don't want any interrupts while running crucial setup
	mov ax, 0x07c0
	mov ds, ax ; setup ds, es segment registers
	mov es, ax
	mov ax, 0x0000
	mov ss, ax ; setup stack
	mov sp, 0x7c00
	sti ; enable interrupts

	mov si, message
	call print

	jmp $ ; halt: keep jumping to the same point

print:
	mov bx, 0
.loop:
	lodsb ; used DS:SI for absolute address
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

times 510-($ - $$) db 0

dw 0xAA55