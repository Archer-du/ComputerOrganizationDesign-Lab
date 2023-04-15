.data
data:	.space 200			#values of F(0)...F(N)
ASC:	.word 0 0			#receive ASCII code of N
R_data:	.word 0x00007f04		#receiver data register addr
R_ctrl:	.word 0x00007f00		#receiver control register addr
T_data: .word 0x00007f0c		#transmitter data register addr
T_ctrl:	.word 0x00007f08		#transmitter control register addr
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
	la	t0, data		#read pointer
	jal	ra, trans
	li 	a7, 10
	ecall
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
#subroutine-transmitter: input read pointer(t0) & N(a0), display
trans:	lw	t1, 0(t0)
	li	t4, 8			#counter
pre:	li	t3, 0xf0000000		#mask
	and	t2, t1, t3
	srli	t2, t2, 28		#get top 4 bits
	bne	zero, t2, ctn		#if t2 == 0, continue
	slli	t1, t1, 4
	addi	t4, t4, -1
	jal	zero, pre
output:	li	t3, 0xf0000000
	and	t2, t1, t3
	srli	t2, t2, 28
ctn:	li	t3, 10
	blt	t2, t3, num		#if t2 < 10, hexplay type: "number"
	addi	t2, t2, 39		#else hexplay type: "letter"
num:	addi	t2, t2, 48
loop1:	lw	t3, 0(s6)		#polling until transmitter control ready
	beq	zero, t3, loop1
	sw	t2, 0(s5)
done1:	slli	t1, t1, 4		#get next 4 bits
	addi	t4, t4, -1		#32 bits number needs 8 transmission at most
	blt	zero, t4, output	#if cnt > 0 continue
	li 	t2, 10			#else print "\n"
loop2:	lw	t3, 0(s6)
	beq	zero, t3, loop2		#polling
	sw	t2, 0(s5)
	addi	t0, t0, 4		#read next data
	addi	a0, a0, -1
	bge	a0, zero, trans
	ret

#subroutine-polling: keyboard input N, return decimal N(a0)
poll:	la	t1, ASC
rec:	lw	t0, 0(s4)
	beq	zero, t0, rec		#polling until receive control ready
	lw	a0, 0(s3)
	li 	t0, ':'	
	beq	a0, t0, conv		#if receive data == ":" , terminate 
	sw	a0, 0(t1)		#else write to memory
	addi	t1, t1, 4
	jal	zero, rec
	#transfer
conv:	la	t1, ASC	
	lw	t2, 0(t1)		#ones/tens
	lw	t0, 4(t1)		#ones/null
	addi	t2, t2,	-48
	beq	t0, zero, exit3		#if t0 == null, N is 1 digit, exit directly
	addi	t0, t0, -48		#else N is 2 digit
	li	t1, 10
	mul	t2, t2, t1		#build decimal N
exit3:	add 	a0, t2, t0
	ret
	
	
	
	

	
	
	
	
