module bufferx8 # (parameter DATA_W = 32, parameter ADDR_W =16, parameter Bank_Num_W = 5)
(	
	input wire 					clk,
	input wire 					rst,
	input wire [ADDR_W-1:0]		R_Addr0,
	input wire [ADDR_W-1:0]		R_Addr1,
	input wire [ADDR_W-1:0]		R_Addr2,
	input wire [ADDR_W-1:0]		R_Addr3,
	input wire [ADDR_W-1:0]		R_Addr4,
	input wire [ADDR_W-1:0]		R_Addr5,
	input wire [ADDR_W-1:0]		R_Addr6,
	input wire [ADDR_W-1:0]		R_Addr7,
	input wire [ADDR_W-1:0]		W_Addr0,
	input wire [ADDR_W-1:0]		W_Addr1,
	input wire [ADDR_W-1:0]		W_Addr2,
	input wire [ADDR_W-1:0]		W_Addr3,
	input wire [ADDR_W-1:0]		W_Addr4,
	input wire [ADDR_W-1:0]		W_Addr5,
	input wire [ADDR_W-1:0]		W_Addr6,
	input wire [ADDR_W-1:0]		W_Addr7,
	input wire [DATA_W-1:0]		W_Data0,
	input wire [DATA_W-1:0]		W_Data1,
	input wire [DATA_W-1:0]		W_Data2,
	input wire [DATA_W-1:0]		W_Data3,
	input wire [DATA_W-1:0]		W_Data4,
	input wire [DATA_W-1:0]		W_Data5,
	input wire [DATA_W-1:0]		W_Data6,
	input wire [DATA_W-1:0]		W_Data7,
	input wire					R_valid0,
	input wire					R_valid1,
	input wire					R_valid2,
	input wire					R_valid3,
	input wire					R_valid4,
	input wire					R_valid5,
	input wire					R_valid6,
	input wire					R_valid7,
	input wire 					W_valid0,
	input wire 					W_valid1,
	input wire 					W_valid2,
	input wire 					W_valid3,
	input wire 					W_valid4,
	input wire 					W_valid5,
	input wire 					W_valid6,
	input wire 					W_valid7,
	output reg					R_out_valid0,
	output reg					R_out_valid1,
	output reg					R_out_valid2,
	output reg					R_out_valid3,
	output reg					R_out_valid4,
	output reg					R_out_valid5,
	output reg					R_out_valid6,
	output reg					R_out_valid7,
	output wire [DATA_W-1:0]	R_Data0,
	output wire [DATA_W-1:0]	R_Data1,
	output wire [DATA_W-1:0]	R_Data2,
	output wire [DATA_W-1:0]	R_Data3,
	output wire [DATA_W-1:0]	R_Data4,
	output wire [DATA_W-1:0]	R_Data5,
	output wire [DATA_W-1:0]	R_Data6,
	output wire [DATA_W-1:0]	R_Data7
);

localparam Bank_Num = (2**Bank_Num_W);

wire [DATA_W-1:0] 				bank_rdata 	[Bank_Num-1:0];
wire [DATA_W-1:0] 				bank_wdata 	[Bank_Num-1:0];
wire [ADDR_W-Bank_Num_W-1:0] 	bank_raddr 	[Bank_Num-1:0];
wire [ADDR_W-Bank_Num_W-1:0] 	bank_waddr 	[Bank_Num-1:0];
wire 			  				bank_w_en  	[Bank_Num-1:0];
reg	 [Bank_Num_W-1:0] 		  	sel		 	[Bank_Num-1:0];

genvar numbank; 
generate for(numbank=0; numbank < Bank_Num; numbank = numbank+1) 
	begin: elements	
		URAM #(.DATA_W(DATA_W), .ADDR_W(ADDR_W-Bank_Num_W))
		bank (
			.Data_in(bank_wdata[numbank]),
			.R_Addr(bank_raddr[numbank]),
			.W_Addr(bank_waddr[numbank]),
			.W_En(bank_w_en[numbank]),
			.En(1'b1),
			.clk(clk),
			.Data_out(bank_rdata[numbank])
		);
	end
endgenerate	
	
genvar i;
generate for(i=0; i<Bank_Num; i=i+1)  
   begin: read_addr assign bank_raddr[i] = (R_valid0 && R_Addr0[Bank_Num_W-1:0] ==i) ? R_Addr0[ADDR_W-1:Bank_Num_W] :
										   (R_valid1 && R_Addr1[Bank_Num_W-1:0] ==i) ? R_Addr1[ADDR_W-1:Bank_Num_W] : 
										   (R_valid2 && R_Addr2[Bank_Num_W-1:0] ==i) ? R_Addr2[ADDR_W-1:Bank_Num_W] : 
										   (R_valid3 && R_Addr3[Bank_Num_W-1:0] ==i) ? R_Addr3[ADDR_W-1:Bank_Num_W] : 	  
										   (R_valid4 && R_Addr4[Bank_Num_W-1:0] ==i) ? R_Addr4[ADDR_W-1:Bank_Num_W] :
										   (R_valid5 && R_Addr5[Bank_Num_W-1:0] ==i) ? R_Addr5[ADDR_W-1:Bank_Num_W] : 
										   (R_valid6 && R_Addr6[Bank_Num_W-1:0] ==i) ? R_Addr6[ADDR_W-1:Bank_Num_W] : 
										   (R_valid7 && R_Addr7[Bank_Num_W-1:0] ==i) ? R_Addr7[ADDR_W-1:Bank_Num_W] : 1'b0;	  
   end 
endgenerate

generate for(i=0; i<Bank_Num; i=i+1)  
   begin: write_addr assign bank_waddr[i] = (W_valid0 && W_Addr0[Bank_Num_W-1:0] ==i) ? W_Addr0[ADDR_W-1:Bank_Num_W] :
										    (W_valid1 && W_Addr1[Bank_Num_W-1:0] ==i) ? W_Addr1[ADDR_W-1:Bank_Num_W] : 
											(W_valid2 && W_Addr2[Bank_Num_W-1:0] ==i) ? W_Addr2[ADDR_W-1:Bank_Num_W] : 
											(W_valid3 && W_Addr3[Bank_Num_W-1:0] ==i) ? W_Addr3[ADDR_W-1:Bank_Num_W] : 
											(W_valid4 && W_Addr4[Bank_Num_W-1:0] ==i) ? W_Addr4[ADDR_W-1:Bank_Num_W] :
										    (W_valid5 && W_Addr5[Bank_Num_W-1:0] ==i) ? W_Addr5[ADDR_W-1:Bank_Num_W] : 
											(W_valid6 && W_Addr6[Bank_Num_W-1:0] ==i) ? W_Addr6[ADDR_W-1:Bank_Num_W] : 
											(W_valid7 && W_Addr7[Bank_Num_W-1:0] ==i) ? W_Addr7[ADDR_W-1:Bank_Num_W] : 1'b0;
   end 
endgenerate

generate for(i=0; i<Bank_Num; i=i+1)  
   begin: write_data assign bank_wdata[i] = (W_valid0 && W_Addr0[Bank_Num_W-1:0] ==i) ? W_Data0 :
										    (W_valid1 && W_Addr1[Bank_Num_W-1:0] ==i) ? W_Data1 : 
											(W_valid2 && W_Addr2[Bank_Num_W-1:0] ==i) ? W_Data2 :  
											(W_valid3 && W_Addr3[Bank_Num_W-1:0] ==i) ? W_Data3 : 
											(W_valid4 && W_Addr4[Bank_Num_W-1:0] ==i) ? W_Data4 :		
										    (W_valid5 && W_Addr5[Bank_Num_W-1:0] ==i) ? W_Data5 : 
											(W_valid6 && W_Addr6[Bank_Num_W-1:0] ==i) ? W_Data6 :  
											(W_valid7 && W_Addr7[Bank_Num_W-1:0] ==i) ? W_Data7 : 1'b0;											
   end 
endgenerate

generate for(i=0; i<Bank_Num; i=i+1)  
   begin: write_enable assign bank_w_en[i] = (W_valid0 && W_Addr0[Bank_Num_W-1:0] ==i) ? 1'b1 :
										     (W_valid1 && W_Addr1[Bank_Num_W-1:0] ==i) ? 1'b1 : 
											 (W_valid2 && W_Addr2[Bank_Num_W-1:0] ==i) ? 1'b1 : 
											 (W_valid3 && W_Addr3[Bank_Num_W-1:0] ==i) ? 1'b1 :
											 (W_valid4 && W_Addr4[Bank_Num_W-1:0] ==i) ? 1'b1 :
										     (W_valid5 && W_Addr5[Bank_Num_W-1:0] ==i) ? 1'b1 : 
											 (W_valid6 && W_Addr6[Bank_Num_W-1:0] ==i) ? 1'b1 : 
											 (W_valid7 && W_Addr7[Bank_Num_W-1:0] ==i) ? 1'b1 : 1'b0;											 
   end 
endgenerate

assign R_Data0 = bank_rdata[sel[0]];
assign R_Data1 = bank_rdata[sel[1]];
assign R_Data2 = bank_rdata[sel[2]];
assign R_Data3 = bank_rdata[sel[3]];
assign R_Data4 = bank_rdata[sel[4]];
assign R_Data5 = bank_rdata[sel[5]];
assign R_Data6 = bank_rdata[sel[6]];
assign R_Data7 = bank_rdata[sel[7]];

integer j;												
always @(posedge clk) begin
	if(rst) begin
		R_out_valid0 <= 0;
		R_out_valid1 <= 0;
		R_out_valid2 <= 0;
		R_out_valid3 <= 0;
		R_out_valid4 <= 0;
		R_out_valid5 <= 0;
		R_out_valid6 <= 0;
		R_out_valid7 <= 0;
		for(j=0; j<8; j=j+1) sel[j] <=j;            
	end else begin
		R_out_valid0 <= R_valid0;
		R_out_valid1 <= R_valid1;
		R_out_valid2 <= R_valid2;
		R_out_valid3 <= R_valid3;
		R_out_valid4 <= R_valid4;
		R_out_valid5 <= R_valid5;
		R_out_valid6 <= R_valid6;
		R_out_valid7 <= R_valid7;		
		sel[0] <= R_Addr0[Bank_Num_W-1:0];			
		sel[1] <= R_Addr1[Bank_Num_W-1:0];			  
		sel[2] <= R_Addr2[Bank_Num_W-1:0];			
		sel[3] <= R_Addr3[Bank_Num_W-1:0];			  
		sel[4] <= R_Addr4[Bank_Num_W-1:0];			
		sel[5] <= R_Addr5[Bank_Num_W-1:0];			  
		sel[6] <= R_Addr6[Bank_Num_W-1:0];			
		sel[7] <= R_Addr7[Bank_Num_W-1:0];			  	
	end
end
endmodule
	