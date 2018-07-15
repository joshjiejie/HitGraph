module bram #(
    parameter DATA = 1,
    parameter ADDR = 16
) (
    // Port A
    input   wire                clk,
    input   wire                a_wr,
    input   wire    [ADDR-1:0]  a_addr,
    input   wire    [DATA-1:0]  a_din,
    output  reg     [DATA-1:0]  a_dout,
     
    // Port B
    //input   wire                b_clk,
    input   wire                b_wr,
    input   wire    [ADDR-1:0]  b_addr,
    input   wire    [DATA-1:0]  b_din,
    output  reg     [DATA-1:0]  b_dout
);
 
(* ram_style="block" *) reg [DATA-1:0] mem [(2**ADDR)-1:0];
 
// Port A
always @(posedge clk) begin
    a_dout      <= mem[a_addr];
    if(a_wr) begin
        a_dout      <= a_din;
        mem[a_addr] <= a_din;
    end
end

// Port B
always @(posedge clk) begin
    b_dout      <= mem[b_addr];
    if(b_wr && (~a_wr || b_addr != a_addr)) begin
        b_dout      <= b_din;
        mem[b_addr] <= b_din;
    end
end

endmodule