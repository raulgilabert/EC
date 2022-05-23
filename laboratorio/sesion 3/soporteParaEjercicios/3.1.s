.data
mat:	.word 0, 0, 2, 0, 0, 0
	.word 0, 0, 4, 0, 0, 0
	.word 0, 0, 6, 0, 0, 0
	.word 0, 0, 8, 0, 0, 0
resultat:
	.space 4

.text
	.globl main
main:	
	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	
	la $a0, mat
	jal suma_col
	
	la $t1, resultat
	sw $v0, 0($t1)
	
	lw $ra, 0($sp)
	addiu $sp, $sp, 4
										
	jr $ra
	
suma_col:
	li $t0, 4
	
	move $t1, $zero # $t1 = suma
	addiu $t2, $a0, 8 # $t2 <- &m[0][2]
	
	# for loop
	ble $t0, $zero, end
	
loop:	lw $t3, 0($t2)
	addu $t1, $t1, $t3 # suma += *p
	addiu $t2, $t2, 24 # p += 6
	
	addiu $t0, $t0, -1
	bgt $t0, $zero, loop
end:
	move $v0, $t1
	jr $ra