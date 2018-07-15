module URAM(
	Data_in,	// W
	R_Addr,	// R
	W_Addr,	// W
	W_En,	// W
	En,
	clk,
	Data_out	// R
	);
parameter DATA_W = 256;
parameter ADDR_W = 10;
localparam DEPTH = (2**ADDR_W);

input [DATA_W-1:0] Data_in;
input [ADDR_W-1:0] R_Addr, W_Addr;
input W_En;
input En;
input clk;
output reg [DATA_W-1:0] Data_out;

(* ram_style="ultra" *) reg [DATA_W-1:0] ram [DEPTH-1:0];
integer i;
initial for (i=0; i<DEPTH; i=i+1) begin
	ram[i] = 0;  	
end
always @(posedge clk) begin
	if (En) begin
		Data_out <= ram[R_Addr];
		if (W_En) begin
			ram[W_Addr] <= Data_in;
		end
	end	
end    
					
endmodule