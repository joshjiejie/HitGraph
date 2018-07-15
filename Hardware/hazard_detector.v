module hdux8 # (
	parameter ADDR_W = 16,
	parameter Bank_Num_W = 5
)(
	input   wire clk,
	input   wire rst,
	input   wire [ADDR_W-1:0] Raddr0,
	input   wire [ADDR_W-1:0] Raddr1,
	input   wire [ADDR_W-1:0] Raddr2,
	input   wire [ADDR_W-1:0] Raddr3,
	input   wire [ADDR_W-1:0] Raddr4,
	input   wire [ADDR_W-1:0] Raddr5,
	input   wire [ADDR_W-1:0] Raddr6,
	input   wire [ADDR_W-1:0] Raddr7,
	input   wire [ADDR_W-1:0] Waddr0,
	input   wire [ADDR_W-1:0] Waddr1,
	input   wire [ADDR_W-1:0] Waddr2,
	input   wire [ADDR_W-1:0] Waddr3,
	input   wire [ADDR_W-1:0] Waddr4,
	input   wire [ADDR_W-1:0] Waddr5,
	input   wire [ADDR_W-1:0] Waddr6,
	input   wire [ADDR_W-1:0] Waddr7,
	input   wire Raddr_valid0,
	input   wire Raddr_valid1,
	input   wire Raddr_valid2,
	input   wire Raddr_valid3,	
	input   wire Raddr_valid4,
	input   wire Raddr_valid5,
	input   wire Raddr_valid6,
	input   wire Raddr_valid7,	  
	input   wire Waddr_valid0,
	input   wire Waddr_valid1,
	input   wire Waddr_valid2,
	input   wire Waddr_valid3,	  
	input   wire Waddr_valid4,
	input   wire Waddr_valid5,
	input   wire Waddr_valid6,
	input   wire Waddr_valid7,
	output  wire flag_valid0,
	output  wire flag_valid1,
	output  wire flag_valid2,
	output  wire flag_valid3,
	output  wire flag_valid4,
	output  wire flag_valid5,
	output  wire flag_valid6,
	output  wire flag_valid7,
	output  wire flag0,
	output  wire flag1,
	output  wire flag2,
	output  wire flag3,
	output  wire flag4,
	output  wire flag5,
	output  wire flag6,
	output  wire flag7
);
    
localparam Bank_Num = (2**Bank_Num_W);

wire [ADDR_W-Bank_Num_W-1:0] bank_raddr [Bank_Num-1:0];
wire [ADDR_W-Bank_Num_W-1:0] bank_waddr [Bank_Num-1:0];
wire [0:0] bank_rvalid [Bank_Num-1:0];
wire [0:0] bank_wvalid [Bank_Num-1:0];
wire [0:0] bank_fvalid [Bank_Num-1:0];
wire [0:0] bank_flag   [Bank_Num-1:0];

reg	 [Bank_Num_W-1:0] sel	[Bank_Num-1:0];

genvar numbank; 
generate for(numbank=0; numbank < Bank_Num; numbank = numbank+1) 
	begin: elements	
		hdu_unit # (.ADDR_W(ADDR_W-Bank_Num_W))	hdu_bank (
			.clk(clk),
			.rst(rst),
			.Raddr(bank_raddr[numbank]),
			.Waddr(bank_waddr[numbank]),
			.Raddr_valid(bank_rvalid[numbank]),
			.Waddr_valid(bank_wvalid[numbank]),
			.flag_valid(bank_fvalid[numbank]),
			.flag(bank_flag[numbank])
		);
	end
endgenerate 

	
genvar i;
generate for(i=0; i<Bank_Num; i=i+1)  
   begin: read_addr assign bank_raddr[i] = (Raddr_valid0 && Raddr0[Bank_Num_W-1:0] == i) ? Raddr0[ADDR_W-1: Bank_Num_W] :
							(Raddr_valid1 && Raddr1[Bank_Num_W-1:0] == i) ? Raddr1[ADDR_W-1: Bank_Num_W] :	
							(Raddr_valid2 && Raddr2[Bank_Num_W-1:0] == i) ? Raddr2[ADDR_W-1: Bank_Num_W] :	
							(Raddr_valid3 && Raddr3[Bank_Num_W-1:0] == i) ? Raddr3[ADDR_W-1: Bank_Num_W] :	
							(Raddr_valid4 && Raddr4[Bank_Num_W-1:0] == i) ? Raddr4[ADDR_W-1: Bank_Num_W] :
							(Raddr_valid5 && Raddr5[Bank_Num_W-1:0] == i) ? Raddr5[ADDR_W-1: Bank_Num_W] :	
							(Raddr_valid6 && Raddr6[Bank_Num_W-1:0] == i) ? Raddr6[ADDR_W-1: Bank_Num_W] :	
							(Raddr_valid7 && Raddr7[Bank_Num_W-1:0] == i) ? Raddr7[ADDR_W-1: Bank_Num_W] : {(ADDR_W-Bank_Num_W){1'b0}};	  
   end 
endgenerate
	
generate for(i=0; i<Bank_Num; i=i+1)  
   begin: write_addr assign bank_waddr[i] = (Waddr_valid0 && Waddr0[Bank_Num_W-1:0] == i) ? Waddr0[ADDR_W-1: Bank_Num_W] :
							(Waddr_valid1 && Waddr1[Bank_Num_W-1:0] == i) ? Waddr1[ADDR_W-1: Bank_Num_W] :	
							(Waddr_valid2 && Waddr2[Bank_Num_W-1:0] == i) ? Waddr2[ADDR_W-1: Bank_Num_W] :
							(Waddr_valid3 && Waddr3[Bank_Num_W-1:0] == i) ? Waddr3[ADDR_W-1: Bank_Num_W] :	
							(Waddr_valid4 && Waddr4[Bank_Num_W-1:0] == i) ? Waddr4[ADDR_W-1: Bank_Num_W] :
							(Waddr_valid5 && Waddr5[Bank_Num_W-1:0] == i) ? Waddr5[ADDR_W-1: Bank_Num_W] :	
							(Waddr_valid6 && Waddr6[Bank_Num_W-1:0] == i) ? Waddr6[ADDR_W-1: Bank_Num_W] :
							(Waddr_valid7 && Waddr7[Bank_Num_W-1:0] == i) ? Waddr7[ADDR_W-1: Bank_Num_W] : {(ADDR_W-Bank_Num_W){1'b0}};	
   end 
endgenerate
																			
generate for(i=0; i<Bank_Num; i=i+1)  
   begin: read_valid assign bank_rvalid[i] = (Raddr_valid0 && Raddr0[Bank_Num_W-1:0] == i) ? 1'b1 :
							(Raddr_valid1 && Raddr1[Bank_Num_W-1:0] == i) ? 1'b1 : 
							(Raddr_valid2 && Raddr2[Bank_Num_W-1:0] == i) ? 1'b1 : 
							(Raddr_valid3 && Raddr3[Bank_Num_W-1:0] == i) ? 1'b1 : 
							(Raddr_valid4 && Raddr4[Bank_Num_W-1:0] == i) ? 1'b1 :
							(Raddr_valid5 && Raddr5[Bank_Num_W-1:0] == i) ? 1'b1 : 
							(Raddr_valid6 && Raddr6[Bank_Num_W-1:0] == i) ? 1'b1 : 
							(Raddr_valid7 && Raddr7[Bank_Num_W-1:0] == i) ? 1'b1 : 1'b0;
   end 
endgenerate
							
generate for(i=0; i<Bank_Num; i=i+1)  
   begin: write_valid assign bank_wvalid[i] = (Waddr_valid0 && Waddr0[Bank_Num_W-1:0] == i) ? 1'b1 :
							(Waddr_valid1 && Waddr1[Bank_Num_W-1:0] == i) ? 1'b1 : 
							(Waddr_valid2 && Waddr2[Bank_Num_W-1:0] == i) ? 1'b1 :
							(Waddr_valid3 && Waddr3[Bank_Num_W-1:0] == i) ? 1'b1 : 
							(Waddr_valid4 && Waddr4[Bank_Num_W-1:0] == i) ? 1'b1 :
							(Waddr_valid5 && Waddr5[Bank_Num_W-1:0] == i) ? 1'b1 : 
							(Waddr_valid6 && Waddr6[Bank_Num_W-1:0] == i) ? 1'b1 :
							(Waddr_valid7 && Waddr7[Bank_Num_W-1:0] == i) ? 1'b1 : 1'b0;
   end 
endgenerate
							
							
always @(posedge clk) begin
	if(rst) begin
		sel[0] <=0;
		sel[1] <=1;    
		sel[2] <=2;
		sel[3] <=3;
		sel[4] <=4;
		sel[5] <=5;    
		sel[6] <=6;
		sel[7] <=7;			
	end else begin
		sel[0] <= Raddr0[Bank_Num_W-1:0];			
		sel[1] <= Raddr1[Bank_Num_W-1:0];			  
		sel[2] <= Raddr2[Bank_Num_W-1:0];			
		sel[3] <= Raddr3[Bank_Num_W-1:0];			  
		sel[4] <= Raddr4[Bank_Num_W-1:0];			
		sel[5] <= Raddr5[Bank_Num_W-1:0];			  
		sel[6] <= Raddr6[Bank_Num_W-1:0];			
		sel[7] <= Raddr7[Bank_Num_W-1:0];		
	end
end

assign flag_valid0 = bank_fvalid[sel[0]];
assign flag_valid1 = bank_fvalid[sel[1]];
assign flag_valid2 = bank_fvalid[sel[2]];
assign flag_valid3 = bank_fvalid[sel[3]];
assign flag_valid4 = bank_fvalid[sel[4]];
assign flag_valid5 = bank_fvalid[sel[5]];
assign flag_valid6 = bank_fvalid[sel[6]];
assign flag_valid7 = bank_fvalid[sel[7]];	
assign flag0 = bank_flag[sel[0]];
assign flag1 = bank_flag[sel[1]];
assign flag2 = bank_flag[sel[2]];
assign flag3 = bank_flag[sel[3]];	
assign flag4 = bank_flag[sel[4]];
assign flag5 = bank_flag[sel[5]];
assign flag6 = bank_flag[sel[6]];
assign flag7 = bank_flag[sel[7]];

endmodule