module top(sys_clk, O_tmds_clk_p, O_tmds_clk_n, O_tmds_data_p, O_tmds_data_n);

input sys_clk;

output O_tmds_clk_p;
output O_tmds_clk_n;
output [2:0] O_tmds_data_p;
output [2:0] O_tmds_data_n;

wire dvi_clk;
wire pix_clk;

gowin_rpll pll(dvi_clk, sys_clk);

CLKDIV div_by_5(.RESETN(1'b1), .HCLKIN(dvi_clk), .CLKOUT(pix_clk), .CALIB (1'b0));
defparam div_by_5.DIV_MODE="5";
defparam div_by_5.GSREN="false";

wire data_en;
wire vsync;
wire hsync;

reg [2:0] colors = 0;
reg [7:0] counter = 0;

wire [10:0] column;
wire [10:0] row;

dvi_tx dvi_tx_inst(
  1'b1,
  dvi_clk,
  pix_clk,
  vsync,
  hsync,
  data_en,
  {8{colors[2]}},
  {8{colors[1]}},
  {8{colors[0]}},
  O_tmds_clk_p,
  O_tmds_clk_n,
  O_tmds_data_p,
  O_tmds_data_n
);

vesa timing_gen(column, row, vsync, hsync, data_en, pix_clk);

always@(posedge pix_clk) begin
  if (column == 0) begin
    counter <= 0;
    colors <= 0;
  end else if (counter == 159) begin
    counter <= 0;
    colors <= colors + 1'b1;
  end else begin
    counter <= counter + 1;
  end
end

endmodule