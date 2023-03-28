# 《数字电路》实验报告

==姓名：杜朋澈 学号：PB21050988==							==完成日期：2022.11.9==

---

### 实验题目

使用 vivado 进行仿真

### 实验目的

- 熟悉 Vivado 软件的下载、安装及使用

- 学习使用 Verilog 编写仿真文件

- 学习使用 Verilog 进行仿真，查看并分析波形文件

### 实验环境

Vivado (Vs Code)

### 题目

==T1(Q)==

请编写 Verilog 仿真文件，生成如下图所示的波形，并在 Vivado 中进行仿真。

<img src="C:\Users\Archer\AppData\Roaming\Typora\typora-user-images\image-20221110084719509.png" alt="image-20221110084719509" style="zoom:50%;" />

==T1(A)==

###### 仿真文件编写:

```verilog
module test_bench1();
reg a,b;
initial
    begin
        a=1;
        #200 a=0;
    end
initial
    begin
        b=0;
        #100 b=1;
        #175 b=0;
        #75 b=1;
    end
endmodule
```

###### 运行结果:

<img src="C:\Users\Archer\AppData\Roaming\Typora\typora-user-images\image-20221110085247990.png" alt="image-20221110085247990" style="zoom:50%;" />

==T2(Q)==

请编写 Verilog 仿真文件，生成如下图所示的波形，并在 Vivado 中进行仿真。

<img src="C:\Users\Archer\AppData\Roaming\Typora\typora-user-images\image-20221110085507355.png" alt="image-20221110085507355" style="zoom:50%;" />

==T2(A)==

###### 仿真文件编写:

```verilog
module test_bench2();
    reg CLK,RST_N,D;
    initial CLK=0;
    always #5 CLK=~CLK;
    initial
        begin
            RST_N=0;
            #27 RST_N=1;
        end
    initial
        begin
            D=0;
            #13 D=1;
            #24 D=0;
        end
endmodule
```

###### 运行结果:

<img src="C:\Users\Archer\AppData\Roaming\Typora\typora-user-images\image-20221110085801648.png" alt="image-20221110085801648" style="zoom:50%;" />

==T3(A)==

利用==T2==中的信号作为以下代码的输入，在 Vivado 中对其仿真，并观察仿真波形。

```verilog
module d_ff_r(
input clk,rst_n,d,
output reg q
);
always@(posedge clk)
begin
    if(rst_n==0)
    q<=0;
    else
    q<=d;
end
endmodule
```

==T3(A)==

####### 仿真文件编写:

```verilog
module test_bench3();
    reg CLK,RST_N,D;
    lab05_T3 d_ff_r(.clk(CLK),.rst_n(RST_N),.d(D));
    initial CLK=0;
    always #5 CLK=~CLK;
    initial
        begin
            RST_N=0;
            #27 RST_N=1;
        end
    initial
        begin
            D=0;
            #13 D=1;
            #24 D=0;
        end
endmodule
```

###### 运行结果:

<img src="C:\Users\Archer\AppData\Roaming\Typora\typora-user-images\image-20221110090415864.png" alt="image-20221110090415864" style="zoom:50%;" />

> 题目提供代码描述的结构为**<u>拥有同步清零功能的D触发器</u>**，其在第一个时钟上升沿之前的输出是不确定值 X。

==T4(Q)==

设计一个3-8译码器，编写仿真测试文件，在 Vivado 中对其进行仿真。要求仿真时遍历所有的输入情况组合，给出源代码和仿真截图。

==T4(A)==

###### 3-8译码器设计：

```verilog
module lab05_T4(
input En,[2:0]A,
output reg [7:0]Y
);
integer k;
always @(A,En)
begin
    Y=8'b1111_1111;
    for(k=0;k<8;k=k+1)
    begin
        if(En==1&&k==A)
        Y[k]=0;
        else
        Y[k]=1;
    end
end
endmodule
```

> 通过行为级建模对3-8线译码器进行描述。调用变量k在for语句的8次循环中实现不同的子电路，更新输出内容。

###### 仿真文件编写:

```verilog
module test_bench4();
reg En;
reg [2:0]A;
lab05_T4 decoder(.A(A),.En(En));
integer k;
initial
begin
    for(k=0;k<40;k=k+1)
    begin
        A=k%8;#10;
    end
end
initial En=0;
always #5 En=~En;
endmodule
```

> 变量k在0~7间以10ns为间隔循环计数，并赋值给输入端口A；En设置为以10ns为周期时钟脉冲型波形，这样可以遍历全部16种输入情况

###### 运行结果:

<img src="C:\Users\Archer\AppData\Roaming\Typora\typora-user-images\image-20221110111954123.png" alt="image-20221110111954123" style="zoom:40%;" />