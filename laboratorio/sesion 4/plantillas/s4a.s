	.data
signe:		.word 0
exponent:	.word 0
mantissa:	.word 0
cfixa:		.word 0x87D18A00
cflotant:	.float 0.0

	.text
	.globl main
main:
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)

	la	$t0, cfixa
	lw	$a0, 0($t0)
	la	$a1, signe
	la	$a2, exponent
	la	$a3, mantissa
	jal	descompon

	la	$a0, signe
	lw	$a0,0($a0)
	la	$a1, exponent
	lw	$a1,0($a1)
	la	$a2, mantissa
	lw	$a2,0($a2)
	jal	compon

	la	$t0, cflotant
	swc1	$f0, 0($t0)

	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra


descompon:
	slt	$t0, $a0, $zero		# cf < 0
	sw	$t0, 0($a1)		# *s = (cf < 0)
	sll	$t0, $a0, 1		# cf = cf << 1
	bne	$t0, $zero, else	# if (c == 0)
	move	$t1, $zero		# exp <- $t1
	b	end
else:
	li 	$t1, 18			# exp = 18
whilestart:
	blt	$t0, $zero, whileend	# while (cf >= 0)
	sll	$t0, $t0, 1		# cf = cf << 1
	addiu	$t1, $t1, -1		# exp--
	b	whilestart
whileend:
	srl	$t0, $t0, 8		# cf >> 8
	li	$t2, 0x7FFFFF		# 0x7FFFFF
	and	$t0, $t0, $t2		# cf = (cf >> 8) & 0x7FFFFF
	addi	$t1, $t1, 127		# exp = exp + 127
end:
	sw	$t1, 0($a2)		# *e = exp
	sw	$t0, 0($a3)		# *m = cf
	jr	$ra

compon:
	sll	$t0, $a0, 31		# signe << 31
	sll	$t1, $a1, 23		# exponent << 23
	or	$t0, $t0, $t1		# (signe << 31) | (exponent << 23)
	or	$t0, $t0, $a2		# (signe << 31) | (exponent << 23) | mantissa
	mtc1	$t0, $f0		# mueve a C1
	jr	$ra

