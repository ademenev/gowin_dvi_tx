/*
VESA timing generator
*/

module vesa(rst_n, column, row, vsync, hsync, data_en, clock);

input rst_n;
input clock;
output reg [10:0] column;
output reg [10:0] row;
output reg vsync;
output reg hsync;
output reg data_en;

localparam h_sync_time = 12'd40;
localparam h_bporch_time = 12'd220;
localparam h_fporch_time = 12'd110;
localparam h_lborder_time = 12'd0;
localparam h_rborder_time = 12'd0;
localparam h_addr_time = 12'd1280;

localparam v_sync_time = 12'd5;
localparam v_bporch_time = 12'd20;
localparam v_fporch_time = 12'd5;
localparam v_tborder_time = 12'd0;
localparam v_bborder_time = 12'd0;
localparam v_addr_time = 12'd720;

localparam h_total_time = h_sync_time + h_bporch_time + h_fporch_time + h_lborder_time + h_rborder_time + h_addr_time;
localparam v_total_time = v_sync_time + v_bporch_time + v_fporch_time + v_tborder_time + v_bborder_time + v_addr_time;

reg [11:0] col_counter = 0 ;
reg [11:0] row_counter = 0;

wire last_col = col_counter >= h_total_time - 1'b1;
wire last_row = row_counter >= v_total_time - 1'b1;
wire [11:0] row_addr_int;
wire [11:0] col_addr_int;

assign col_addr_int = col_counter - (h_sync_time + h_bporch_time + h_lborder_time );
assign row_addr_int = row_counter - (v_sync_time + v_bporch_time + v_tborder_time );


wire v_en = (row_addr_int < v_addr_time);
wire h_en = (col_addr_int < h_addr_time);

always@(posedge clock or negedge rst_n) begin
  if (!rst_n) begin
    col_counter <= 0;
    row_counter <= 0;
    column <= 0;
    row <= 0;
    vsync <= 0;
    hsync <= 0;
    data_en <= 0;
  end else begin
    if (last_col) col_counter <= 12'b0;
    else col_counter <= col_counter + 1'b1;
    if (last_row & last_col) row_counter <= 12'b0;
    else if (last_col) row_counter <= row_counter + 1'b1;
    hsync <= (col_counter < h_sync_time - 1);
    column <= col_addr_int[10:0];
    row <= row_addr_int[10:0];
    data_en <= v_en & h_en;
    vsync <= (row_counter < v_sync_time);
  end
end


endmodule
