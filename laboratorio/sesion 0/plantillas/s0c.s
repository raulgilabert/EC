	.data
V:	.word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10  # vector d'enters

	.text
	.globl main
main:
	li	$t0, 0		# Posem $t0 a 0 (variable suma)                    
	li	$t1, 0		# Posem $t1 a 0 (comptador del bucle i)
	li	$t2, 10		# $t2 = L�mit del comptatge
bucle:
	slt	$t3, $t1, $t2
	beq	$t3, $zero, fibucle # Despr�s de 10 voltes acaba
	la	$t3, V 		# $t3 = Adre�a inicial de V
	sll	$t4, $t1, 2	# $t4 = 4*i (cada element ocupa 4 bytes)
	addu	$t3, $t3, $t4	# @V[i]
	lw	$t3, 0($t3)	# Llegim un element $t3 = V[i]
	addu	$t0, $t0, $t3	# Acumulem. suma = suma + V[i]
	addiu	$t1, $t1, 1	# i++
	b	bucle		# salt incondicional                   
fibucle:

	li	$t3, 0		# Posem $t3 a 0 (quocient suma/i)  
bucle2:
	slt	$t4, $t0, $t1
	bne	$t4, $zero, fibucle2
	subu	$t0, $t0, $t1
	addiu	$t3, $t3, 1
	b	bucle2
fibucle2:
	jr	$ra		# Retorna


