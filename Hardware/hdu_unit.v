module hdu_unit # (
    parameter ADDR_W = 16
)(
	input   wire clk,
	input   wire rst,
	input   wire [ADDR_W-1:0] Raddr,
	input   wire [ADDR_W-1:0] Waddr,
	input   wire Raddr_valid,
	input   wire Waddr_valid,
	output  reg  flag_valid,
	output  reg  flag
);
    
    wire bram_flag_outA;
    wire bram_flag_outB;
    
    always @(posedge clk) begin
        if(rst) begin
            flag_valid <=1'b0;
            flag <=1'b0;
        end else begin
            flag_valid <= Raddr_valid;
            flag <= bram_flag_outA;            
        end    
    end 
    bram # (.DATA(1),  .ADDR(ADDR_W))
    hdu_ram(
        .clk(clk),
        .a_wr(Raddr_valid),
        .a_addr(Raddr),
        .a_din(1'b1),
        .a_dout(bram_flag_outA),
        .b_wr(Waddr_valid),
        .b_addr(Waddr),
        .b_din(1'b0),
        .b_dout(bram_flag_outB)
    );    
endmodule