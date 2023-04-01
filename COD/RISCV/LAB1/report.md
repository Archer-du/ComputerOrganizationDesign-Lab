# lab1 report

---

## 实验内容

​	利用ripes工具实现通过RISC-V32I/M指令集实现对指定内存段未知数量个数据的冒泡排序，并通过console输出信息。

## 实现思路

​	共设置三个子例程协同完成工作: output, getlen, bubblesort。

- output: output1和output2通过系统调用分别输出排序前和排序后的数据段和提示信息。
- getlen: 获取内存中指定数据段长度(以字节为单位)。
- bubblesort：对指定数据段进行冒泡排序，排序结果覆写原数据段。

## 核心代码

下面列出代码核心部分的解释和必要注释。

### output：

​	通过系统调用输出msg位置的提示信息和src位置的字符串，并在末尾输出\n(ASCII code = 10).

```assembly
output:
		la	a0, msg
		li  a7, 4
		ecall
		la	a0,	src
		li	a7,	4
		ecall
		li  a0, 10
		li	a7, 11
		ecall
		ret
```

### getlen:

​	该例程为bubblesort例程服务。

​	函数接口为：a0存储返回值(数据段长度)，a1存储数据段起始地址。函数内部使用t0作为游标，依次指向数据段各个数据。

```assembly
getlen:
		mv 	 a0, zero
		mv	 t0, a1
next:	lb	 t1, 0(t0)
		beq  t1, zero, done1	#check if read x00(end of string)
		addi a0, a0, 1
		addi t0, t0, 1
		jal  x0, next
done:	ret
```

### bubblesort:

​	函数接口：a0,a1为函数参数，应分别存储数据段长度和数据段起始地址。

​	按照冒泡排序的思想，例程共执行两重循环。由于每次外层循环后待排序元素数量都会减少，故每一轮将a0的值减一，结束条件为 a0<=1 (实际不会出现<1的情况)，a0等于1说明上轮循环仅对一个元素进行排序，即排序完成。

​	内层循环每次读取a1+t0-1,a1+t0处的两个元素进行比较，若不满足降序，则互换存储位置。

```assembly
bubblesort:
		addi t0, zero, 1	#build const 1
		bge	 t0, a0, done	#if a0<=1, done
sort:	bge	 t0, a0, sorted
		mv	 t1, a1
		add	 t1, t1, t0
		addi t0, t0, 1
		lb	 t2, -1(t1)
		lb 	 t3, 0(t1)		#read 2 elements
		bge	 t2, t3, sort	#if the former >= the latter, continue
		sb   t2, 0(t1)
		sb   t3, -1(t1)		#else, swap
		jal  x0, sort
sorted: addi a0, a0 ,-1
		jal  x0, bubblesort
done:	ret
```

## 实验过程

### 内存段映像

程序执行前：

![image-20230331181324822](C:\Users\Archer\AppData\Roaming\Typora\typora-user-images\image-20230331181324822.png)

<img src="C:\Users\Archer\AppData\Roaming\Typora\typora-user-images\image-20230331181348225.png" alt="image-20230331181348225" style="zoom: 67%;" />

程序执行后：

![image-20230331181518746](C:\Users\Archer\AppData\Roaming\Typora\typora-user-images\image-20230331181518746.png)

<img src="C:\Users\Archer\AppData\Roaming\Typora\typora-user-images\image-20230331181537903.png" alt="image-20230331181537903" style="zoom:67%;" />

### 控制台输出

<img src="C:\Users\Archer\AppData\Roaming\Typora\typora-user-images\image-20230331181646908.png" alt="image-20230331181646908" style="zoom:67%;" />

## 源码

```assembly
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
```

## debug过程

​	算法与代码实现较为简单，无值得记录的debug内容。

