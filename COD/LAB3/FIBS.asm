.data
value:	.word 0 0
R_data:	.word 0x00007f04
R_ctrl:	.word 0x00007f00
T_data: .word 0x00007f0c
T_ctrl:	.word 0x00007f08
data:	.space 200			#F(0) F(1)
.text
main:	la	s3, R_data
	la	s4, R_ctrl
	la	s5, T_data
	la	s6, T_ctrl
	lw	s3, 0(s3)
	lw	s4, 0(s4)
	lw	s5, 0(s5)
	lw	s6, 0(s6)
	jal	ra, poll
	jal	ra, Fibs
	li 	a7, 10
	ecall
#subroutine:a3=int Fibs(int a0)
Fibs:	la    	t0, data		#write pointer
	addi 	t0, t0, 4
	li	a1, 1			#F(n-2)
	li	a2, 1			#F(n-1)
	sw	a1, -4(t0)
	sw	a2, 0(t0)
	li    	t1, 2			#cnt
	li	t2, 4			#offset==4
	li    	a3, 1			#init result to 1
loop1:	add	t0, t0, t2
	blt   	a0, t1, exit1
	add   	a3, a1, a2
	sw	a3, 0(t0)
	mv    	a1, a2
	mv    	a2, a3
	addi  	t1, t1, 1
	jal   	zero, loop1
exit1:	ret

#transfer
trans:	la	t0, data		#read pointer
	lw	t1, 0(t0)
loop3:	li	t3, 0xf0000000		#t3:tmp
	and	t2, t1, t3
	srli	t2, t2, 28
	beq	zero, t2, done1
	li	t3, 10
	blt	t2, t3, num		#if t2<10,num
	addi	t2, t2, 39
num:	addi	t2, t2, 48
loop2:	lw	t3, 0(s6)
	beq	zero, t3, loop2
	sw	t2, 0(s5)
done1:	slli	t1, t1, 4
	jal	zero, loop3

#subroutine:polling (return 3<=a0<=40)
poll:	la	t1, value
loop3:	lw	t0, 0(s4)
	beq	zero, t0, loop3
	lw	a0, 0(s3)
	li 	t0, ':'
	beq	a0, t0, done2
	sw	a0, 0(t1)
	addi	t1, t1, 4
	jal	zero, loop3
done2:	la	t1, value
	lw	t2, 0(t1)		#ones or tens
	lw	t0, 4(t1)		#ones or null
	addi	t2, t2,	-48
	beq	t0, zero, exit3
	addi	t0, t0, -48
	li	t1, 10
	mul	t2, t2, t1
exit3:	add 	a0, t2, t0
	ret
	
	
	
	

	
	
	
	
