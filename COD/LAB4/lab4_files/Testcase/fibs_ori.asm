# win: 0x3008 ~ 0x3020
.data
data:	.space 168			#values of F(0)...F(N)
.text
main:	li	a0, 40
	jal	ra, Fibs
WIN:	lui 	x7 7
	addi 	x7 x7 0x700
	addi	x7 x7 0x700
	addi 	x7 x7 0x100		# x7 = 7f00
	addi 	x8 x0 1
	sw 	x8 12(x7)		# led[0] = 0
	beq 	x0, x0, WIN
	
#subroutine-Fibs: input N(a0), write F(0)...F(N) to memory
Fibs:	la    	t0, data		#write pointer
	addi 	t0, t0, 4
	li	a1, 1			#F(n-2)
	li	a2, 1			#F(n-1)
	sw	a1, -4(t0)		#write F(0)
	sw	a2, 0(t0)		#write F(1)
	li    	t1, 2			#init counter to 2
	li	t2, 4			#offset == 4
	li    	a3, 1			#init result to 1
iter:	add	t0, t0, t2		#update write pointer
	blt   	a0, t1, exit1		#if counter> N, exit
	add   	a3, a1, a2		#F(n)=F(n-2)+f(n-1)
	sw	a3, 0(t0)		#store f(n)
	mv    	a1, a2			#iterate
	mv    	a2, a3
	addi  	t1, t1, 1		#update counter
	jal   	zero, iter
exit1:	ret
