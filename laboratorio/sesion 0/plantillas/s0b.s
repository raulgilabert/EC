	.data
V:	.word -1, -2, -3, -4, -5, -6, -7, -8, -9, -10 # vector d'enters

	.text
	.globl main
main:
	li	$t0, 0		# Posem $t0 a 0 (variable suma)                    
	li	$t1, 10		# Posem $t1 a 9 (comptador del bucle i)
	la	$t3, V		# $t3 = Adre�a inicial de V
bucle:
	addiu	$t1, $t1, -1	# i--
	sll	$t4, $t1, 2	# $t4 = 4*i (cada element ocupa 4 bytes)
	addu	$t4, $t3, $t4	# @V[i]
	lw	$t4, 0($t4)	# Llegim un element $t4 = V[i]
	addu	$t0, $t0, $t4	# Acumulem suma = suma + V[i]
	bne	$t1, $zero, bucle
fibucle:
	jr	$ra		# Retorna


