# 《数字电路》实验报告

==姓名：杜朋澈 学号：PB21050988==							

==完成日期：2022.11.9==

---

### 实验题目

**FGPA 原理及 vivado 综合**

### 实验目的

- 了解 FGPA 原理
- 了解 Verilog 文件和约束文件在 FPGA 开发中的作用
- 学会使用 Vivado 进行 FPGA 开发的完整流程

### 实验环境

- FPGAOL 实验平台：fpgaol.ustc.edu.cn
- Logisim
- Vivado

### 题目

==T1(Q)==

>请通过实验中给出的可编程逻辑单元、交叉互连矩阵及IOB电路图，实现如下代码，并将其输出到引脚B上。给出配置数据和电路截图。
>
>```verilog
>module test(input clk,output reg a);
>always@(posedge clk)
>a < = a ^ 1’b1;
>endmodule
>```
>
>

==T1(A)==

**分析：**

根据异或门的逻辑特性，无论a初始值为何值，a不断与1'b1异或并赋值给自身的结果只可能是……01010101……的序列，依照FGPA的时序编辑方式，易得如下电路。

**结果：**

<img src="C:\Users\Archer\AppData\Roaming\Typora\typora-user-images\image-20221116194234339.png" alt="image-20221116194234339" style="zoom:50%;" />

其中b输入端常态为0，RAM的输出端D只会反复输出地址00与01处的内容。

==T2(Q)==

>实验中的开关和LED的对应关系是相反的，即最左侧的开关控制最右侧的LED，最右侧的开关控制最左侧的LED，请修改实验中给出的XDC文件，使开关和LED一一对应（最左侧的开关控制最左侧的LED），如下图所示。
>
><img src="C:\Users\Archer\AppData\Roaming\Typora\typora-user-images\image-20221116194759793.png" alt="image-20221116194759793" style="zoom:50%;" />

==T2(A)==

**分析**：

将实验手册给出的.xdc文件中，sw[i]与sw[7-i]对应的led输出引脚互换即可。$(i\in[0,3],i\in Z)$

**结果**

- 实验手册中的约束文件：

  ```verilog
  set_property -dict { PACKAGE_PIN E3  IOSTANDARD LVCMOS33} [get_ports { clk }];
  set_property -dict { PACKAGE_PIN B18  IOSTANDARD LVCMOS33} [get_ports { rst }];
  set_property -dict { PACKAGE_PIN C17  IOSTANDARD LVCMOS33} [get_ports { led[0] }];
  set_property -dict { PACKAGE_PIN D18  IOSTANDARD LVCMOS33} [get_ports { led[1] }];
  set_property -dict { PACKAGE_PIN E18  IOSTANDARD LVCMOS33} [get_ports { led[2] }];
  set_property -dict { PACKAGE_PIN G17  IOSTANDARD LVCMOS33} [get_ports { led[3] }];
  set_property -dict { PACKAGE_PIN D17  IOSTANDARD LVCMOS33} [get_ports { led[4] }];
  set_property -dict { PACKAGE_PIN E17  IOSTANDARD LVCMOS33} [get_ports { led[5] }];
  set_property -dict { PACKAGE_PIN F18  IOSTANDARD LVCMOS33} [get_ports { led[6] }];
  set_property -dict { PACKAGE_PIN G18  IOSTANDARD LVCMOS33} [get_ports { led[7] }];
  set_property -dict { PACKAGE_PIN D14  IOSTANDARD LVCMOS33} [get_ports { sw[0] }];
  set_property -dict { PACKAGE_PIN F16  IOSTANDARD LVCMOS33} [get_ports { sw[1] }];
  set_property -dict { PACKAGE_PIN G16  IOSTANDARD LVCMOS33} [get_ports { sw[2] }];
  set_property -dict { PACKAGE_PIN H14  IOSTANDARD LVCMOS33} [get_ports { sw[3] }];
  set_property -dict { PACKAGE_PIN E16  IOSTANDARD LVCMOS33} [get_ports { sw[4] }];
  set_property -dict { PACKAGE_PIN F13  IOSTANDARD LVCMOS33} [get_ports { sw[5] }];
  set_property -dict { PACKAGE_PIN G13  IOSTANDARD LVCMOS33} [get_ports { sw[6] }];
  set_property -dict { PACKAGE_PIN H16  IOSTANDARD LVCMOS33} [get_ports { sw[7] }]; 
  ```

- 修改后的约束文件：

  ```verilog
  set_property -dict { PACKAGE_PIN E3  IOSTANDARD LVCMOS33} [get_ports { clk }];
  set_property -dict { PACKAGE_PIN B18  IOSTANDARD LVCMOS33} [get_ports { rst }];
  set_property -dict { PACKAGE_PIN G18  IOSTANDARD LVCMOS33} [get_ports { led[0] }];
  set_property -dict { PACKAGE_PIN F18  IOSTANDARD LVCMOS33} [get_ports { led[1] }];
  set_property -dict { PACKAGE_PIN E17  IOSTANDARD LVCMOS33} [get_ports { led[2] }];
  set_property -dict { PACKAGE_PIN D17  IOSTANDARD LVCMOS33} [get_ports { led[3] }];
  set_property -dict { PACKAGE_PIN G17  IOSTANDARD LVCMOS33} [get_ports { led[4] }];
  set_property -dict { PACKAGE_PIN E18  IOSTANDARD LVCMOS33} [get_ports { led[5] }];
  set_property -dict { PACKAGE_PIN D18  IOSTANDARD LVCMOS33} [get_ports { led[6] }];
  set_property -dict { PACKAGE_PIN C17  IOSTANDARD LVCMOS33} [get_ports { led[7] }];
  set_property -dict { PACKAGE_PIN D14  IOSTANDARD LVCMOS33} [get_ports { sw[0] }];
  set_property -dict { PACKAGE_PIN F16  IOSTANDARD LVCMOS33} [get_ports { sw[1] }];
  set_property -dict { PACKAGE_PIN G16  IOSTANDARD LVCMOS33} [get_ports { sw[2] }];
  set_property -dict { PACKAGE_PIN H14  IOSTANDARD LVCMOS33} [get_ports { sw[3] }];
  set_property -dict { PACKAGE_PIN E16  IOSTANDARD LVCMOS33} [get_ports { sw[4] }];
  set_property -dict { PACKAGE_PIN F13  IOSTANDARD LVCMOS33} [get_ports { sw[5] }];
  set_property -dict { PACKAGE_PIN G13  IOSTANDARD LVCMOS33} [get_ports { sw[6] }];
  set_property -dict { PACKAGE_PIN H16  IOSTANDARD LVCMOS33} [get_ports { sw[7] }]; 
  ```

- FGPAOL平台烧写结果：

  <img src="C:\Users\Archer\AppData\Roaming\Typora\typora-user-images\image-20221116203347740.png" alt="image-20221116203347740" style="zoom:50%;" />

==T3(Q)==

>设计一个30位计数器，每个时钟周期加1，用右侧的8个LED表示计数器的高8位，观察实际运行结果。将该计数器改成32位，将高8位输出到LED，与前面的运行结果进行对比，分析结果及时钟信号在其中所起的作用。

**分析**：注意将实际结果用寄存器类型存储，并将所需要的数据赋给相应位数的输出端口led。

**结果：**

- 30位计数器源码：

  ```verilog
  module counter(
      input clk,rst,
      output reg [7:0] led
  );
  reg [29:0] Q;
  always@(posedge clk,posedge rst)
  begin
      if(rst)begin
          Q<=30'b0;
          led<=Q[29:22];
      end
      else begin
          Q<=Q+1'b1;
          led<=Q[29:22];
      end
  end
  endmodule
  ```

- 32位计数器源码：

  ```verilog
  module counter(
      input clk,rst,
      output reg [7:0] led
  );
      reg [31:0] Q;
  always@(posedge clk,posedge rst)
  begin
      if(rst)begin
          Q<=32'b0;
          led<=Q[29:22];
      end
      else begin
          Q<=Q+1'b1;
          led<=Q[31:24];
      end
  end
  endmodule
  ```

- 30位计数器FGPA烧写结果：

  <img src="C:\Users\Archer\AppData\Roaming\Typora\typora-user-images\image-20221116224636425.png" alt="image-20221116224636425" style="zoom:50%;" />

- 32位计数器FGPA烧写结果：

  <img src="C:\Users\Archer\AppData\Roaming\Typora\typora-user-images\image-20221116225103493.png" alt="image-20221116225103493" style="zoom:50%;" />

  32位计数器的led变化速度是30位计数器的led变化速度的0.25倍。
