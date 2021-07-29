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

	call read_sector

	jmp $ ; halt: keep jumping to the same point

read_sector:
	mov ah, 02h ; Read sector command
	mov al, 01h ; Read only one sector
	mov ch, 00h ; Cylinder low 8bits
	mov cl, 02h ; Read sector 2 --- starts from 1
	mov dh, 00h ; Head number: ? --- dl is already set to disk number by bios
	mov bx, buffer ; Set data buffer: uses ES:BX for absolute address
	int 13h ; invoke interrupt 13h with command 02h
	jc error ; Jump if carry flag is set---set by the interrupt routine 13h if there is error
	call success ; print success message and the buffer
	ret

; Handle print: put message address to SI
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
; ----------------------------------------

; Handle success: print success message
success:
	mov si, success_msg
	call print
	mov si, buffer
	call print
	ret

; Handle error: print error message
error:
	mov si, error_msg
	call print
	jmp $

success_msg: db 'Sucessfully loaded sector from memory', 0
error_msg: db 'Failed to load sector from memory', 0


times 510-($ - $$) db 0
dw 0xAA55 ; indicate bios that this 512b segment is bootloader

buffer:
	; can't define data here because the bios only loads 512b into the memory; but the address can be referenced tho
