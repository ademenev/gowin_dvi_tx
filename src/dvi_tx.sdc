create_clock -name sys_clk -period 37.04 -waveform {0 18.52} [get_ports {sys_clk}] -add
create_generated_clock -name dvi_clk -source [get_nets {sys_clk}] -divide_by 4 -multiply_by 55 [get_nets {dvi_clk}]
create_generated_clock -name pix_clk -source [get_nets {dvi_clk}] -divide_by 5 [get_nets {pix_clk}]
