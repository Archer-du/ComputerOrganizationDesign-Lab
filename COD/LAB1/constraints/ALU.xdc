## Clock signal
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { clk }]; 
set_property -dict { PACKAGE_PIN B18  IOSTANDARD LVCMOS33} [get_ports { en }];
## FPGAOL SWITCH
set_property -dict { PACKAGE_PIN D14   IOSTANDARD LVCMOS33 } [get_ports { x[0] }];
set_property -dict { PACKAGE_PIN F16   IOSTANDARD LVCMOS33 } [get_ports { x[1] }];
set_property -dict { PACKAGE_PIN G16   IOSTANDARD LVCMOS33 } [get_ports { x[2] }];
set_property -dict { PACKAGE_PIN H14   IOSTANDARD LVCMOS33 } [get_ports { x[3] }];
set_property -dict { PACKAGE_PIN E16   IOSTANDARD LVCMOS33 } [get_ports { x[4] }];
set_property -dict { PACKAGE_PIN F13   IOSTANDARD LVCMOS33 } [get_ports { x[5] }];
set_property -dict { PACKAGE_PIN G13   IOSTANDARD LVCMOS33 } [get_ports { sel[0] }];
set_property -dict { PACKAGE_PIN H16   IOSTANDARD LVCMOS33 } [get_ports { sel[1] }];
## FPGAOL LED
set_property -dict { PACKAGE_PIN C17  IOSTANDARD LVCMOS33} [get_ports { y[0] }];
set_property -dict { PACKAGE_PIN D18  IOSTANDARD LVCMOS33} [get_ports { y[1] }];
set_property -dict { PACKAGE_PIN E18  IOSTANDARD LVCMOS33} [get_ports { y[2] }];
set_property -dict { PACKAGE_PIN G17  IOSTANDARD LVCMOS33} [get_ports { y[3] }];
set_property -dict { PACKAGE_PIN D17  IOSTANDARD LVCMOS33} [get_ports { y[4] }];
set_property -dict { PACKAGE_PIN E17  IOSTANDARD LVCMOS33} [get_ports { y[5] }];
set_property -dict { PACKAGE_PIN G18  IOSTANDARD LVCMOS33} [get_ports { of }];