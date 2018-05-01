.org $7efc
.word $7f00
.word end_of_code-$7f00
                lda #<v_nmi
                sta $fffa
                lda #>v_nmi
                sta $fffb
                lda #<v_reset
                sta $fffc
                lda #>v_reset
                sta $fffd
                lda #<v_irq
                sta $fffe
                lda #>v_irq
                sta $ffff
                jmp kernel_init

.require "taliforth.asm"
.alias IO_BASE $C000
.alias UART_STATUS IO_BASE+$8
.alias UART_DATA IO_BASE+$9

v_nmi:
v_reset:
v_irq:
kernel_init:
        ; """Initialize the hardware. This is called with a JMP and not
        ; a JSR because we don't have anything set up for that yet.
	; -- At the end, we JMP back to the label forth to start the 
        ; Forth system.
        ; """
.scope
                ; We've successfully set everything up, so print the kernel
                ; string
                ldx #0
*               lda s_kernel_id,x
                beq _done
                jsr kernel_putc
                inx
                bra -
_done:
                jmp forth
.scend

kernel_getc:
        ; """Get a single character from the keyboard.
        ; """
.scope
_loop:		bit UART_STATUS
		bvc _loop
		lda UART_DATA
		rts
.scend
 

kernel_putc:
        ; """Print a single character to the console.
        ; """
.scope
_loop:		bit UART_STATUS
		bmi _loop
		sta UART_DATA
	        rts
.scend	

; Leave the following string as the last entry in the kernel routine so it
; is easier to see where the kernel ends in hex dumps. This string is
; displayed after a successful boot
s_kernel_id: 
        .byte "Tali Forth 2 kernel for CHOCHI E (01. May 2018)", AscLF, 0

end_of_code:
; END
