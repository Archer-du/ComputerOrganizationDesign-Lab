# 《数字电路》实验报告

==姓名：杜朋澈 学号：PB21050988==							

==完成日期：2022.11.24==

---

### 实验题目

**FPGA 实验平台及 IP 核使用**

### 实验目的

- 熟悉 FPGAOL 在线实验平台结构及使用
- 掌握 FPGA 开发各关键环节
- 学会使用 IP 核（知识产权核）

### 实验环境

- FPGAOL 实验平台：fpgaol.ustc.edu.cn
- Logisim
- Vivado

### 题目

==T1(Q)==

> 例化一个 16*8bit 的 ROM，并对其进行初始化，输入端口由 4 个开关控制，输出端口连接到七段数码管上（七段数码管与LED 复用相同的一组管脚），控制数码管显示与开关相对应的十六进制数字，例如四个开关输入全为零时，数码管显示“0”，输入全为 1 时，数码管显示“F”。

==T1(A)==

**分析**

首先调用IP核（ROM）根据数码管不同示数对应的8位二进制数编写初始化文件，然后在设计文件中调用IP核，简单编写仿真文件测试数据正确性，最后烧写FPGA即可.

**结果**

- ROM例化设置

  <img src="C:\Users\Archer\AppData\Roaming\Typora\typora-user-images\image-20221124215519194.png" alt="image-20221124215519194" style="zoom:33%;" />

- .coe文件

  ```verilog
  memory_initialization_radix=16;
  memory_initialization_vector=
  fc 60 da f2 66 b6 be e0 fe f6 ee fe 9c fc 9e 8e
  ```

- 设计文件

  ```verilog
  module t_1(
      input [3:0]sw,
      output [7:0]led
      );
      dist_mem_gen_0 dist_mem_gen_0(.a(sw),.spo(led));
  endmodule
  ```

- 仿真文件

  ```verilog
  module testbench();
  reg [3:0]sw;
  wire [7:0]led;
  t_1 T_1(.sw(sw),.led(led));
  initial begin
      sw=4'b0;
      while(sw<15)begin
          #10 sw=sw+1;
      end
  end
  endmodule
  ```

  - 输入端口sw从0至15遍历本题所有输入情况。

    - 仿真波形:

  
    <img src="C:\Users\Archer\AppData\Roaming\Typora\typora-user-images\image-20221124215841654.png" alt="image-20221124215841654" style="zoom:33%;" />
  
- 约束文件

  ```verilog
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
  ```

- FPGA烧写结果

  <img src="C:\Users\Archer\AppData\Roaming\Typora\typora-user-images\image-20221124220819172.png" alt="image-20221124220819172" style="zoom:50%;" />

  <img src="C:\Users\Archer\AppData\Roaming\Typora\typora-user-images\image-20221124220841118.png" alt="image-20221124220841118" style="zoom:50%;" />

==T2(Q)==

> 采用 8 个开关作为输入，两个十六进制数码管作为输出，采用分时复用的方式将开关的十六进制数值在两个数码管上显示出来，例如高四位全为 1，低四位全为 0 时，数码管显示“F0”。

**分析**

为了使FPGA芯片的两个十六进制数码管“同时”示数，需要以较高频率分时将sw低四位内容和高四位内容输送至相应数码管。

**错误记录**

在初次实现过程中,编写的设计文件直接调用了默认时钟脉冲信号(100MHz)作为分时依据输送相应数据进入数码管。这在FPGA开发板上会产生很大的问题：100MHz的时钟信号每0.00001ms就会刷新一次，这对于开发板来说频率过高，数码管显示将发生异常，具体表现为片选信号失效，只有低位或高位的内容在单个数码管上显示。为了避免这种问题，改进后的设计文件采用计数方式对时钟进行降频。

**结果**

- 设计文件

  ```verilog
  module T_2 (
      input [7:0]sw,
      input clk,
      output reg[2:0]an,
      output reg[3:0]hex
  );
  reg counter=0;
  reg [3:0]cnt=0;
  always@(posedge clk) begin
      if(cnt<4'b1001)begin
          cnt<=cnt+1;
          if(cnt==4'b1000)begin
              counter=~counter;
              an=counter?3'b001:3'b000;
              if(an)
              hex<=sw[7:4];
              else
              hex<=sw[3:0];
          end
      end
      else cnt=0;
  end
  endmodule
  ```

  将时钟信号频率降至原来的1/10

- 仿真文件

  ```verilog
  module testbench();
  reg clk;
  reg [7:0]sw;
  wire [2:0]an;
  wire [3:0]hex;
  T_2 T_2(.sw(sw),.clk(clk),.an(an),.hex(hex));
  initial clk=0;
  always #1 clk=~clk;
  initial begin
      sw=8'h00;
      while(sw<8'hff)begin
          #100 sw=sw+1;
      end
  end
  endmodule
  ```

  - sw信号从0至ff遍历所有输入情况

    - 仿真波形

      <img src="C:\Users\Archer\AppData\Roaming\Typora\typora-user-images\image-20221125132512470.png" alt="image-20221125132512470" style="zoom:50%;" />

- 约束文件

  ```verilog
  ## Clock signal
  set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { clk }]; 
  ## FPGAOL SWITCH
  set_property -dict { PACKAGE_PIN D14   IOSTANDARD LVCMOS33 } [get_ports { sw[0] }];
  set_property -dict { PACKAGE_PIN F16   IOSTANDARD LVCMOS33 } [get_ports { sw[1] }];
  set_property -dict { PACKAGE_PIN G16   IOSTANDARD LVCMOS33 } [get_ports { sw[2] }];
  set_property -dict { PACKAGE_PIN H14   IOSTANDARD LVCMOS33 } [get_ports { sw[3] }];
  set_property -dict { PACKAGE_PIN E16   IOSTANDARD LVCMOS33 } [get_ports { sw[4] }];
  set_property -dict { PACKAGE_PIN F13   IOSTANDARD LVCMOS33 } [get_ports { sw[5] }];
  set_property -dict { PACKAGE_PIN G13   IOSTANDARD LVCMOS33 } [get_ports { sw[6] }];
  set_property -dict { PACKAGE_PIN H16   IOSTANDARD LVCMOS33 } [get_ports { sw[7] }];
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

  <img src="C:\Users\Archer\AppData\Roaming\Typora\typora-user-images\image-20221125132652125.png" alt="image-20221125132652125" style="zoom:50%;" />

  <img src="C:\Users\Archer\AppData\Roaming\Typora\typora-user-images\image-20221125132704465.png" alt="image-20221125132704465" style="zoom:50%;" />

==T3(Q)==

> 利用本实验中的时钟管理单元或周期脉冲技术，设计一个精度为 0.1 秒的计时器，用 4 位数码管显示出来，数码管从高到低，分别表示分钟、秒钟十位、秒钟个位、十分之一秒，该计时器具有复位功能（可采用按键或开关作为复位信号），复位时计数值为 1234， 即1分23.4秒

**分析**

上一题目已经提及，默认的100MHz的时钟信号周期为0.00001ms。而在本题目中，数据输出以100ms作为最小时钟周期，因此应自制控制信号，通过计数方式使得控制信号每经过10000000个默认时钟周期产生一次脉冲，从而按照正确频率修改输出数据内容。高频片选信号的调制与上一题目类似，同样通过计数方式对时钟信号进行降频即可。

**结果**

- 设计文件

  ```verilog
  module T_3(
      input clk,rst,
      output reg[2:0]an,
      output reg[3:0]hex
  );
  reg [3:0]cnt_A=0;
  reg [1:0]counter=0;
  reg [27:0]cnt_T=0;
  reg [15:0]T=0;
  always@(posedge clk)begin
      if(cnt_A<4'b1001)begin
          cnt_A<=cnt_A+1;
      end
      else begin
          cnt_A=0;
          counter=counter+1;
          case(counter)
              2'b00:begin
                  an=3'b000;
                  hex=T[3:0];
              end
              2'b01:begin 
                  an=3'b001;
                  hex=T[7:4];
              end
              2'b10:begin 
                  an=3'b010;
                  hex=T[11:8];
              end
              2'b11:begin 
                  an=3'b011;
                  hex=T[15:12];
              end
          endcase
      end
  end
  always@(posedge clk)begin
      if(rst)
      T<=16'h1234;
      else if(cnt_T<24'h98967f)begin
          cnt_T<=cnt_T+1;
          if(cnt_T==24'h98967e)begin
              if(T[3:0]<4'b1001)begin
                  T[3:0]=T[3:0]+1;
              end
              else begin
                  T[3:0]=0;
                  if(T[7:4]<4'b1001)begin
                      T[7:4]=T[7:4]+1;
                  end
                  else begin
                      T[7:4]=0;
                      if(T[11:8]<4'b0101)begin
                          T[11:8]=T[11:8]+1;
                      end
                      else begin
                          T[11:8]=0;
                          if(T[15:12]<4'b1001)begin
                              T[15:12]=T[15:12]+1;
                          end
                          else T[15:12]=0;
                      end
                  end
              end
          end
      end
      else cnt_T=0;
  end
  endmodule
  ```

- 仿真文件

  ```verilog
  module testbench();
  reg clk;
  reg rst;
  wire [2:0]an;
  wire [3:0]hex;
  T_3 T_3(.clk(clk),.rst(rst),.an(an),.hex(hex));
  initial clk=0;
  always #1 clk=~clk;
  initial begin 
      rst=1;
      #1000 rst=0;
  end
  endmodule
  ```

  - 体现rst的两种的情况

    - 仿真波形

      <img src="C:\Users\Archer\AppData\Roaming\Typora\typora-user-images\image-20221125152417104.png" alt="image-20221125152417104" style="zoom:50%;" />

      <img src="C:\Users\Archer\AppData\Roaming\Typora\typora-user-images\image-20221125152308520.png" alt="image-20221125152308520" style="zoom:50%;" />

- 约束文件

  ```verilog
  set_property -dict { PACKAGE_PIN E3  IOSTANDARD LVCMOS33} [get_ports { clk }];
  set_property -dict { PACKAGE_PIN B18  IOSTANDARD LVCMOS33} [get_ports { rst }];
  
  set_property -dict { PACKAGE_PIN A14   IOSTANDARD LVCMOS33 } [get_ports { hex[0] }];
  set_property -dict { PACKAGE_PIN A13   IOSTANDARD LVCMOS33 } [get_ports { hex[1] }];
  set_property -dict { PACKAGE_PIN A16   IOSTANDARD LVCMOS33 } [get_ports { hex[2] }];
  set_property -dict { PACKAGE_PIN A15   IOSTANDARD LVCMOS33 } [get_ports { hex[3] }];
  set_property -dict { PACKAGE_PIN B17   IOSTANDARD LVCMOS33 } [get_ports { an[0] }];
  set_property -dict { PACKAGE_PIN B16   IOSTANDARD LVCMOS33 } [get_ports { an[1] }];
  set_property -dict { PACKAGE_PIN A18   IOSTANDARD LVCMOS33 } [get_ports { an[2] }];
  ```

- FPGA烧写结果

  <img src="C:\Users\Archer\AppData\Roaming\Typora\typora-user-images\image-20221125153115570.png" alt="image-20221125153115570" style="zoom:50%;" />

  <img src="C:\Users\Archer\AppData\Roaming\Typora\typora-user-images\image-20221125153209264.png" alt="image-20221125153209264" style="zoom:50%;" />
