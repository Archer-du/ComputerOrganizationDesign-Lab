.data
#len:	.word	19
src:	.string "PB21050988dupengche"
msg1:	.string "unsorted list:"
msg2:	.string "sorted list:  "

.text
main:
		la	a1,	src
		jal ra, output1
		jal ra, getlen
#		lw  t0, len
#		bne t0, a0, term
		jal	ra,	bubblesort
		jal ra, output2
term:	li	a7,	10
		ecall

getlen:
		mv 	 a0, zero
		mv	 t0, a1
next:	lb	 t1, 0(t0)
		beq  t1, zero, done1
		addi a0, a0, 1
		addi t0, t0, 1
		jal  x0, next
done1:	ret

bubblesort:
# a1 stores the unsorted list, a0 contains the length of it
		addi t0, zero, 1	#build const 1
		bge	 t0, a0, done2
sort:	bge	 t0, a0, sorted
		mv	 t1, a1
		add	 t1, t1, t0
		addi t0, t0, 1
		lb	 t2, -1(t1)
		lb 	 t3, 0(t1)
		bge	 t2, t3, sort
		sb   t2, 0(t1)
		sb   t3, -1(t1)
		jal  x0, sort
sorted: addi a0, a0 ,-1
		jal  x0, bubblesort
done2:	ret

output1:	
		la	a0, msg1
		li  a7, 4
		ecall
		la	a0,	src
		li	a7,	4
		ecall
		li  a0, 10
		li	a7, 11
		ecall
		ret
output2:
		la	a0, msg2
		li  a7, 4
		ecall
		la	a0,	src
		li	a7,	4
		ecall
		li  a0, 10
		li	a7, 11
		ecall
		ret
		
