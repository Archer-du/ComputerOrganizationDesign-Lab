# 《数字电路》实验报告

==姓名：杜朋澈 学号：PB21050988==							

==完成日期：2022.11.30==

---

### 实验题目

**信号处理及有限状态机**

### 实验目的

- 进一步熟悉 FPGA 开发的整体流程
- 掌握几种常见的信号处理技巧
- 掌握有限状态机的设计方法
- 能够使用有限状态机设计功能电路

### 实验环境

- VLAB：vlab.ustc.eud.cn
- FPGAOL:fpgaol.ustc.edu.cn
- Logisim
- Vivado

### 题目

==T1(Q)==

> 在不改变电路功能和行为的前提下，将前面 Step5(如下)中的代码改写成三段式有限状态机的形式，写出完整的 Verilog 代码。
>
> ```verilog
> module test(
> input clk,rst,
> output led);
> reg [1:0] cnt;
> always@(posedge clk or posedge rst_n)
> begin
> if(rst)
> cnt <= 2'b0;
> else
> cnt <= cnt + 1'b1;
> end
> assign led = (cnt==2'b11) ? 1'b1 : 1'b0;
> endmodule
> ```

==T1(A)==

**结果**

- 代码实现

  ```verilog
  module moduleName (
      input clk,rst,
      output led
  );
  reg[1:0]cnt;
  reg [1:0]curS,nexS;
  //part.1
  always@(*)begin
      nexS<=curS+1;
  end
  //part.2
  always@(posedge clk or posedge rst)begin
      if(rst)
      nexS<=0;
      else
      curS<=nexS;
  end
  //part.3
  assign led=(curS==2'b11)?1'b1:1'b0;
  endmodule
  ```


==T2(Q)==

> 请在 Logisim 中设计一个 4bit 位宽的计数器电路，如下图所示，clk 信号为计数器时钟，复位时（rst==1）计数值为 0，在输入信号 sw 电平发生变化时，计数值 cnt 加 1，即在 sw 信号上升沿时刻和下降沿时刻各触发一次计数操作，其余时刻计数器保持不变。
>
> <img src="C:\Users\Archer\AppData\Roaming\Typora\typora-user-images\image-20221130140630073.png" alt="image-20221130140630073" style="zoom:50%;" />

==T2(A)==

**分析**

没有用到clk信号。

**结果**

- 电路搭建

  <img src="C:\Users\Archer\AppData\Roaming\Typora\typora-user-images\image-20221130195658741.png" alt="image-20221130195658741" style="zoom:50%;" />

==T3(Q)==

> 设计一个8位的十六进制计数器，时钟采用板载的 100MHz 时钟，通过 sw[0]控制计数模式，开关为1时为累加模式，为0时为 递减模式，按键控制计数，按下的瞬间根据开关的状态进行累加或递 减计数。计数值用数码管显示，其复位值为“1F”。

==T3(A)==

**结果**

- 设计文件

  ```verilog
  module T_3(
      input clk,button,
      input [1:0]sw,//sw[0]增减控制，sw[1]复位信号
      output reg[2:0]an,
      output reg[3:0]hex
  );
  reg [3:0]freq=0;
  reg b_r1,b_r2;
  reg [7:0]num;
  reg rev=0;
  wire pulse;
  always@(posedge clk)begin
      if(freq==4'b1001)begin
          freq=0;
          rev=~rev;
          an=rev?3'b001:3'b000;//时钟信号降频调制片选信号
          hex=an[0]?num[7:4]:num[3:0];
      end
      else begin
          freq=freq+1;
      end
  end//16进制数码管分时复用
  always@(posedge clk)
      b_r1<=button;
  always@(posedge clk)
      b_r2<=b_r1;
  assign pulse=b_r1&(~b_r2);
  //双寄存器实现button的单周期短脉冲信号pulse
  always@(posedge clk)begin
      if(sw[1])
      num=8'h1f;
      else begin
          if(sw[0])begin
              if(pulse)
              num<=num+1;
              else
              num<=num;
          end//sw[0]==1累加模式
          else begin
              if(pulse)
              num<=num-1;
              else
              num<=num;
          end//sw[0]==0递减模式
      end
  end
  endmodule
  ```

- 仿真文件

  ```verilog
  module testbench();
  reg clk,button;
  reg [1:0]sw;
  wire [2:0]an;
  wire [3:0]hex;
  T_3 T_3(clk,button,sw,an,hex);
  initial clk=0;
  always #1 clk=~clk;
  initial button=0;
  always #100 button=~button;
  initial sw=2'b01;
  always #1000 sw<=sw+1;
  endmodule
  ```

  - 仿真测试波形

    <img src="C:\Users\Archer\AppData\Roaming\Typora\typora-user-images\image-20221130194600913.png" alt="image-20221130194600913" style="zoom:50%;" />

- 管脚约束文件

  ```verilog
  ## Clock signal & button
  set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { clk }]; 
  set_property -dict { PACKAGE_PIN B18    IOSTANDARD LVCMOS33 } [get_ports { button }]; 
  ## FPGAOL SWITCH
  set_property -dict { PACKAGE_PIN D14   IOSTANDARD LVCMOS33 } [get_ports { sw[0] }];
  set_property -dict { PACKAGE_PIN F16   IOSTANDARD LVCMOS33 } [get_ports { sw[1] }];
  ## FPGAOL HEXPLAY
  set_property -dict { PACKAGE_PIN A14   IOSTANDARD LVCMOS33 } [get_ports { hex[0] }];
  set_property -dict { PACKAGE_PIN A13   IOSTANDARD LVCMOS33 } [get_ports { hex[1] }];
  set_property -dict { PACKAGE_PIN A16   IOSTANDARD LVCMOS33 } [get_ports { hex[2] }];
  set_property -dict { PACKAGE_PIN A15   IOSTANDARD LVCMOS33 } [get_ports { hex[3] }];
  set_property -dict { PACKAGE_PIN B17   IOSTANDARD LVCMOS33 } [get_ports { an[0] }];
  set_property -dict { PACKAGE_PIN B16   IOSTANDARD LVCMOS33 } [get_ports { an[1] }];
  set_property -dict { PACKAGE_PIN A18   IOSTANDARD LVCMOS33 } [get_ports { an[2] }];
  ```

- FPGA烧写结果

  <img src="C:\Users\Archer\AppData\Roaming\Typora\typora-user-images\image-20221130195833765.png" alt="image-20221130195833765" style="zoom:33%;" />

==T4(Q)==

> 使用有限状态机设计一个序列检测电路，并进行计数，当检测到输入序列为“1100”时，计数器加一，用一个数码管显示当前状 态编码，一个数码管显示检测到目标序列的个数，用4个数码管显示 最近输入的4个数值，用sw[0]进行数据的串行输入，按键每按下一次将输入一次开关状态，时钟采用板载的100MHz时钟。
>
> 要求画出状态跳转图，并在 FPGA 开发板上实现电路，例如当输入 “0011001110011”时，目标序列个数应为2，最近输入数值显示“0011”， 状态机编码则与具体实现有关。

==T4(A)==

**分析**

**结果**

- 状态转换图

  ```mermaid
  graph LR
  A(Init)-->|1|B(a)
  A-->|0|A
  B-->|0|A
  B-->|1|C(b)
  C-->|0|D(c)
  C-->|1|C
  D-->|0/num++|E(d)
  D-->|1|B
  E-->|0|A
  E-->|1|B
  ```

  - 状态说明
    - a:读取字符"1"
    - b:读取字符"11"
    - c:读取字符"110"
    - d:读取字符"1100"
    - Init:初始状态

  注意到Init和d拥有相同的状态转换方式，故化简后得到的状态图为：

  ```mermaid
  graph LR
  A(d/Init)-->|1|B(a)
  A-->|0|A
  B-->|0|A
  B-->|1|C(b)
  C-->|0|D(c)
  C-->|1|C
  D-->|0/num++|A
  D-->|1|B
  ```

  将d/Init,a,b,c依次编码为：2'b00,2'b01,2'b11,2'b10.

- 设计文件

  ```verilog
  module T_4(
      input clk,
      input sw,
      input button,
      output reg [2:0]an,//2~5数码管显示最近输入四位数据，0数码管记录目标序列个数
      output reg [3:0]hex
  );
  reg [3:0]freq=0;
  reg b_r1,b_r2;
  reg [1:0]curS=2'b00;
  reg [15:0]prev=16'hffff;
  reg [3:0]num=0;//寄存目标序列个数
  reg [2:0]cnt=0;
  wire pulse;
  //时钟信号降频调制片选信号
  always@(posedge clk)begin
      if(freq==4'b1001)begin
          freq=0;
          cnt=cnt+1;
          case(cnt)
              3'b000:begin
                  an<=3'b000;
                  hex<=num;
                  end
              3'b010:begin
                  an<=3'b010;
                  hex<=prev[3:0];
              end
              3'b011:begin
                  an<=3'b011;
                  hex<=prev[7:4];
              end
              3'b100:begin
                  an<=3'b100;
                  hex<=prev[11:8];
              end
              3'b101:begin
                  an<=3'b101;
                  hex<=prev[15:12];
              end
              default:begin
                  an<=3'b000;
                  hex<=num;
              end
          endcase
      end
      else begin
          freq=freq+1;
      end
  end
  //双寄存器实现button的单周期短脉冲信号pulse
  always@(posedge clk)
      b_r1<=button;
  always@(posedge clk)
      b_r2<=b_r1;
  assign pulse=b_r1&(~b_r2);
  //存储最近输入数值的模块
  always@(posedge clk)begin
      if(pulse)begin
          prev=prev*16;
          if(sw)begin
              prev[3:0]=4'b0001;
              case(curS)
              2'b00:curS<=2'b01;
              2'b01:curS<=2'b11;
              2'b11:curS<=2'b11;
              2'b10:curS<=2'b01;
              endcase
          end
          else begin
              prev[3:0]=4'b0000;
              case(curS)
              2'b00:curS<=2'b00;
              2'b01:curS<=2'b00;
              2'b11:curS<=2'b10;
              2'b10:begin
                  curS<=2'b00;
                  num<=num+1;
              end    
              endcase
          end    
      end
      else prev=prev;
  end
  endmodule
  ```

- 仿真文件

  ```verilog
  module testbench();
  reg clk;
  reg sw;
  reg button;
  wire [2:0]an;
  wire [3:0]hex;
  T_4 T_4(clk,sw,button,an,hex);
  initial clk=0;
  always #1 clk=~clk;
  initial button=0;
  always #100 button=~button;
  initial sw=0;
  always #75 sw=sw+1;
  endmodule
  ```

  - 仿真测试波形

    <img src="C:\Users\Archer\AppData\Roaming\Typora\typora-user-images\image-20221130230803320.png" alt="image-20221130230803320" style="zoom:50%;" />

- 管脚约束文件

  ```verilog
  ## Clock signal & button
  set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { clk }]; 
  set_property -dict { PACKAGE_PIN B18    IOSTANDARD LVCMOS33 } [get_ports { button }]; 
  ## FPGAOL SWITCH
  set_property -dict { PACKAGE_PIN D14   IOSTANDARD LVCMOS33 } [get_ports { sw }];
  ## FPGAOL HEXPLAY
  set_property -dict { PACKAGE_PIN A14   IOSTANDARD LVCMOS33 } [get_ports { hex[0] }];
  set_property -dict { PACKAGE_PIN A13   IOSTANDARD LVCMOS33 } [get_ports { hex[1] }];
  set_property -dict { PACKAGE_PIN A16   IOSTANDARD LVCMOS33 } [get_ports { hex[2] }];
  set_property -dict { PACKAGE_PIN A15   IOSTANDARD LVCMOS33 } [get_ports { hex[3] }];
  set_property -dict { PACKAGE_PIN B17   IOSTANDARD LVCMOS33 } [get_ports { an[0] }];
  set_property -dict { PACKAGE_PIN B16   IOSTANDARD LVCMOS33 } [get_ports { an[1] }];
  set_property -dict { PACKAGE_PIN A18   IOSTANDARD LVCMOS33 } [get_ports { an[2] }];
  ```

- FPGA烧写结果

  <img src="C:\Users\Archer\AppData\Roaming\Typora\typora-user-images\image-20221130233358371.png" alt="image-20221130233358371" style="zoom:33%;" />