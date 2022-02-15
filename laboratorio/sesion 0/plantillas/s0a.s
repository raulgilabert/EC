	.data
V:	.word -1, -2, -3, -4, -5, -6, -7, -8, -9, -10  # vector d'enters

	.text
	.globl main
main:
	li	$t0, 0		# $t0 = 0 (variable suma)
	li	$t1, 0		# $t1 = 0 (comptador del bucle i)
	li	$t2, 10		# $t2 = 10 (límit del comptatge)
bucle:
	slt	$t3, $t1, $t2
	beq	$t3, $zero, fibucle	# Després de 10 voltes acaba
	la	$t3, V		# $t3 = Adreça inicial de V
	sll	$t4, $t1, 2	# $t4 = 4*i (cada element ocupa 4 bytes)
	addu	$t3, $t3, $t4	# @V[i] = @V + 4*i
	lw	$t3, 0($t3)	# Llegim un element $t3 = V[i]
	addu	$t0, $t0, $t3	# Acumulem. suma = suma + V[i]
	addiu	$t1, $t1, 1	# i++
	b bucle			# salt incondicional                   
fibucle:
	jr	$ra		# Retorna


