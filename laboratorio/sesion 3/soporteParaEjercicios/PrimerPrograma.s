.data
	.align 2
mat1:	.space 120
mat4:	.word 2, 3, 1
	.word 2, 4, 3
col:	.word 2

.text
	.globl main
main:
	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	
	# Primera llamada
	
	la $a0, mat4 # $a0 <- mat
	addiu $t0, $a0, 8 # &mat[0][2]
	lw $a1, 0($t0) # $a1 <- mat[0][2]
	la $t0, col
	lw $a2, 0($t0) # $a2 <- col
	
	jal subr
	
	la $t0, mat1
	addiu $t0, $t0, 108 # mat[4][3]
	sw $v0, 0($t0)
	
	# Segunda llamada
	
	la $a0, mat4 # $a0 <- mat
	li $a1, 1 # $a1 <- 1
	li $a2, 1 # $a2 <- 1
	
	jal subr
	
	la $t0, mat1
	sw $v0, 0($t0)
	
	lw $ra, 0($sp)
	addiu $sp, $sp, 4
	jr $ra
	
subr:
	# i*3
	li $t0, 3
	mult $a1, $t0
	mflo $t0
	
	addu $t0, $t0, $a2 # [i][j]
	sll $t0, $t0, 2 # Pasado a int
	addu $t0, $t0, $a0 # x[i][j]
		
	# j*6
	li $t2, 6
	mult $a2, $t2
	mflo $t2
	
	addiu $t2, $t2, 5 # [j][5]
	sll $t2, $t2, 2 # Pasado a int
	
	la $t1, mat1
	addu $t2, $t2, $t1 # mat1[j][5]

	lw $t0, 0($t0)
	sw $t0, 0($t2)
	move $v0, $a1
	jr $ra