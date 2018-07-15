module combining_network # (
	parameter DATA_W = 32,
	parameter PIPE_DEPTH = 5,
	parameter PAR_SIZE_W = 17,
    parameter PAR_NUM   = 16,
    parameter PAR_NUM_W = 4
)(
	input wire          			clk,
    input wire          			rst,    
    input wire  [7:0]         		InputValid,
	input wire  [DATA_W*8-1:0]   	InDestVid,    
    input wire  [DATA_W*8-1:0]   	InUpdate,    
    output reg [511:0]              DRAM_W,
    output reg                      DRAM_W_valid,
    output wire                     stall_request
);

wire [DATA_W*8-1:0] OutUpdate [2:0];
wire [DATA_W*8-1:0] OutDestVid [2:0];
wire [8-1:0] OutValid [4:0];
wire [DATA_W*2*8-1:0] Ubuff_out [1:0];
wire [63:0]	  se_output_word;
wire         se_output_valid;
    
CNx8 #(.DATA_W(DATA_W), .PIPE_DEPTH(PIPE_DEPTH))
CNstage0 (
	.clk(clk),
    .rst(rst),    
    .InputValid(InputValid),
	.InDestVid(InDestVid),    
    .InUpdate(InUpdate),    
    .OutUpdate(OutUpdate[0]),
    .OutDestVid(OutDestVid[0]),
	.OutValid(OutValid[0])
);

Ubuffx8
Ubuff0 (
    .clk(clk),
    .rst(rst),    
    .last_input_in(1'b0),
    .word_in({OutUpdate[0][DATA_W*8-1:DATA_W*7],OutDestVid[0][DATA_W*8-1:DATA_W*7],OutUpdate[0][DATA_W*7-1:DATA_W*6],OutDestVid[0][DATA_W*7-1:DATA_W*6],
              OutUpdate[0][DATA_W*6-1:DATA_W*5],OutDestVid[0][DATA_W*6-1:DATA_W*5],OutUpdate[0][DATA_W*5-1:DATA_W*4],OutDestVid[0][DATA_W*5-1:DATA_W*4],
              OutUpdate[0][DATA_W*4-1:DATA_W*3],OutDestVid[0][DATA_W*4-1:DATA_W*3],OutUpdate[0][DATA_W*3-1:DATA_W*2],OutDestVid[0][DATA_W*3-1:DATA_W*2],
              OutUpdate[0][DATA_W*2-1:DATA_W*1],OutDestVid[0][DATA_W*2-1:DATA_W*1],OutUpdate[0][DATA_W*1-1:DATA_W*0],OutDestVid[0][DATA_W*1-1:DATA_W*0]}),
	.word_in_valid(OutValid[0]),
    //input wire [1:0] control,        
    .word_out(Ubuff_out[0]), 
    .valid_out(OutValid[1])
);

CNx8 #(.DATA_W(DATA_W), .PIPE_DEPTH(PIPE_DEPTH))
CNstage1 (
	.clk(clk),
    .rst(rst),    
    .InputValid(OutValid[1]),
	.InDestVid({Ubuff_out[0][DATA_W*15-1:DATA_W*14],Ubuff_out[0][DATA_W*13-1:DATA_W*12],Ubuff_out[0][DATA_W*11-1:DATA_W*10],Ubuff_out[0][DATA_W*9-1:DATA_W*8],Ubuff_out[0][DATA_W*7-1:DATA_W*6],Ubuff_out[0][DATA_W*5-1:DATA_W*4],Ubuff_out[0][DATA_W*3-1:DATA_W*2],Ubuff_out[0][DATA_W*1-1:DATA_W*0]}),    
    .InUpdate({Ubuff_out[0][DATA_W*16-1:DATA_W*15],Ubuff_out[0][DATA_W*14-1:DATA_W*13],Ubuff_out[0][DATA_W*12-1:DATA_W*11],Ubuff_out[0][DATA_W*10-1:DATA_W*9],Ubuff_out[0][DATA_W*8-1:DATA_W*7],Ubuff_out[0][DATA_W*6-1:DATA_W*5],Ubuff_out[0][DATA_W*4-1:DATA_W*3],Ubuff_out[0][DATA_W*2-1:DATA_W*1]}),       
    .OutUpdate(OutUpdate[1]),
    .OutDestVid(OutDestVid[1]),
	.OutValid(OutValid[2])
);

Ubuffx8
Ubuff1 (
    .clk(clk),
    .rst(rst),    
    .last_input_in(1'b0),
    .word_in({OutUpdate[1][DATA_W*8-1:DATA_W*7],OutDestVid[1][DATA_W*8-1:DATA_W*7],OutUpdate[1][DATA_W*7-1:DATA_W*6],OutDestVid[1][DATA_W*7-1:DATA_W*6],
              OutUpdate[1][DATA_W*6-1:DATA_W*5],OutDestVid[1][DATA_W*6-1:DATA_W*5],OutUpdate[1][DATA_W*5-1:DATA_W*4],OutDestVid[1][DATA_W*5-1:DATA_W*4],
              OutUpdate[1][DATA_W*4-1:DATA_W*3],OutDestVid[1][DATA_W*4-1:DATA_W*3],OutUpdate[1][DATA_W*3-1:DATA_W*2],OutDestVid[1][DATA_W*3-1:DATA_W*2],
              OutUpdate[1][DATA_W*2-1:DATA_W*1],OutDestVid[1][DATA_W*2-1:DATA_W*1],OutUpdate[1][DATA_W*1-1:DATA_W*0],OutDestVid[1][DATA_W*1-1:DATA_W*0]}),
	.word_in_valid(OutValid[2]),
    //input wire [1:0] control,        
    .word_out(Ubuff_out[1]), 
    .valid_out(OutValid[3])
);


CNx8 #(.DATA_W(DATA_W), .PIPE_DEPTH(PIPE_DEPTH))
CNstage2 (
	.clk(clk),
    .rst(rst),    
    .InputValid(OutValid[3]),
	.InDestVid({Ubuff_out[1][DATA_W*15-1:DATA_W*14],Ubuff_out[1][DATA_W*13-1:DATA_W*12],Ubuff_out[1][DATA_W*11-1:DATA_W*10],Ubuff_out[1][DATA_W*9-1:DATA_W*8],Ubuff_out[1][DATA_W*7-1:DATA_W*6],Ubuff_out[1][DATA_W*5-1:DATA_W*4],Ubuff_out[1][DATA_W*3-1:DATA_W*2],Ubuff_out[1][DATA_W*1-1:DATA_W*0]}),    
    .InUpdate({Ubuff_out[1][DATA_W*16-1:DATA_W*15],Ubuff_out[1][DATA_W*14-1:DATA_W*13],Ubuff_out[1][DATA_W*12-1:DATA_W*11],Ubuff_out[1][DATA_W*10-1:DATA_W*9],Ubuff_out[1][DATA_W*8-1:DATA_W*7],Ubuff_out[1][DATA_W*6-1:DATA_W*5],Ubuff_out[1][DATA_W*4-1:DATA_W*3],Ubuff_out[1][DATA_W*2-1:DATA_W*1]}),       
    .OutUpdate(OutUpdate[2]),
    .OutDestVid(OutDestVid[2]),
	.OutValid(OutValid[4])
);

seout output_update(
	.clk(clk),
	.rst(rst),
	.input_update0({OutUpdate[2][DATA_W*8-1:DATA_W*7], OutDestVid[2][DATA_W*8-1:DATA_W*7]}),
	.input_update1({OutUpdate[2][DATA_W*7-1:DATA_W*6], OutDestVid[2][DATA_W*7-1:DATA_W*6]}),
	.input_update2({OutUpdate[2][DATA_W*6-1:DATA_W*5], OutDestVid[2][DATA_W*6-1:DATA_W*5]}),
	.input_update3({OutUpdate[2][DATA_W*5-1:DATA_W*4], OutDestVid[2][DATA_W*5-1:DATA_W*4]}),
	.input_update4({OutUpdate[2][DATA_W*4-1:DATA_W*3], OutDestVid[2][DATA_W*4-1:DATA_W*3]}),
	.input_update5({OutUpdate[2][DATA_W*3-1:DATA_W*2], OutDestVid[2][DATA_W*3-1:DATA_W*2]}),
	.input_update6({OutUpdate[2][DATA_W*2-1:DATA_W*1], OutDestVid[2][DATA_W*2-1:DATA_W*1]}),
	.input_update7({OutUpdate[2][DATA_W*1-1:DATA_W*0], OutDestVid[2][DATA_W*1-1:DATA_W*0]}),
	.input_valid0(OutValid[4][7:7]),
	.input_valid1(OutValid[4][6:6]),
	.input_valid2(OutValid[4][5:5]),
	.input_valid3(OutValid[4][4:4]),
	.input_valid4(OutValid[4][3:3]),
	.input_valid5(OutValid[4][2:2]),
	.input_valid6(OutValid[4][1:1]),
	.input_valid7(OutValid[4][0:0]),	
	.output_word(se_output_word),
	.output_valid(se_output_valid),
	.se_stall_request(stall_request)
);

reg [511:0]  	Ubuff         			[PAR_NUM-1:0];
reg [2:0]   	Ubuff_size            	[PAR_NUM-1:0];

integer i;
wire [PAR_NUM_W-1:0] input_update_bin_id;
//reg [31:0]  par_bin_addr            [PAR_NUM-1:0];


assign input_update_bin_id = se_output_word[PAR_SIZE_W+PAR_NUM_W-1:PAR_SIZE_W];

always @(posedge clk) begin
    if(rst) begin        
        for(i=0; i<PAR_NUM; i=i+1) begin
            Ubuff[i] 		 <= 0;
            Ubuff_size [i] 	 <= 0;
        end
        DRAM_W <= 0;
        DRAM_W_valid <= 0;	
    end else begin 	
        DRAM_W_valid <= 0;
        DRAM_W <= 0;
        if(se_output_valid) begin
            if(Ubuff_size[input_update_bin_id] == 7) begin
                DRAM_W <= {Ubuff[input_update_bin_id][447:0], se_output_word};
                DRAM_W_valid <= 1'b1;
                Ubuff[input_update_bin_id] <= 0;
                Ubuff_size[input_update_bin_id] <= 0;
            end else begin
                Ubuff[input_update_bin_id] <= (Ubuff[input_update_bin_id]<<64)+se_output_word;
                Ubuff_size[input_update_bin_id] <= Ubuff_size[input_update_bin_id]+1;				
            end
        end							
    end
end

endmodule


module seout (
	input wire clk,
	input wire rst,
	input wire [63:0]	input_update0,
	input wire [63:0]	input_update1,
	input wire [63:0]	input_update2,
	input wire [63:0]	input_update3,
	input wire [63:0]	input_update4,
	input wire [63:0]	input_update5,
	input wire [63:0]	input_update6,
	input wire [63:0]	input_update7,	
	input wire input_valid0,
	input wire input_valid1,
	input wire input_valid2,
	input wire input_valid3,
	input wire input_valid4,
	input wire input_valid5,
	input wire input_valid6,
	input wire input_valid7,
	output reg	[63:0]	output_word,
	output reg	output_valid,
	output reg 	se_stall_request
);

	reg [63:0] 	update_buff 		[7:0];
	reg [0:0] 	update_valid_buff 	[7:0];
	
	always @(posedge clk) begin
        if (rst) begin
			update_buff[0] <= 0;
			update_buff[1] <= 0;
			update_buff[2] <= 0;
			update_buff[3] <= 0;
			update_buff[4] <= 0;
			update_buff[5] <= 0;
			update_buff[6] <= 0;
			update_buff[7] <= 0;
			update_valid_buff[0] <= 0;
			update_valid_buff[1] <= 0;
			update_valid_buff[2] <= 0;
			update_valid_buff[3] <= 0;
			update_valid_buff[4] <= 0;
			update_valid_buff[5] <= 0;
			update_valid_buff[6] <= 0;
			update_valid_buff[7] <= 0;
        end	else begin			
			update_buff[0] <= input_update0;
			update_buff[1] <= input_update1;
			update_buff[2] <= input_update2;
			update_buff[3] <= input_update3;
			update_buff[4] <= input_update4;
			update_buff[5] <= input_update5;
			update_buff[6] <= input_update6;
			update_buff[7] <= input_update7;
			update_valid_buff[0] <= input_valid0;
			update_valid_buff[1] <= input_valid1;
			update_valid_buff[2] <= input_valid2;
			update_valid_buff[3] <= input_valid3;
			update_valid_buff[4] <= input_valid4;
			update_valid_buff[5] <= input_valid5;
			update_valid_buff[6] <= input_valid6;
			update_valid_buff[7] <= input_valid7;			
			output_word <= update_buff[0];
            case({update_valid_buff[0], update_valid_buff[1], update_valid_buff[2], update_valid_buff[3], update_valid_buff[4], update_valid_buff[5], update_valid_buff[6], update_valid_buff[7]}) 
				8'b00000000: begin					
					output_valid <= 0;					
					se_stall_request <= 0;
				end
				8'b10000000: begin					
					output_valid <= 1;
					se_stall_request <= 0;
				end
				default:begin					
					output_valid <= 1;
					update_buff[0] <= update_buff[1];
					update_valid_buff[0] <= update_valid_buff[1];
					update_buff[1] <= update_buff[2];
					update_valid_buff[1] <= update_valid_buff[2];
					update_buff[2] <= update_buff[3];
					update_valid_buff[2] <= update_valid_buff[3];
					update_buff[3] <= update_buff[4];
					update_valid_buff[3] <= update_valid_buff[4];
					update_buff[4] <= update_buff[5];
					update_valid_buff[4] <= update_valid_buff[5];
					update_buff[5] <= update_buff[6];
					update_valid_buff[5] <= update_valid_buff[6];
					update_buff[6] <= update_buff[7];
					update_valid_buff[6] <= update_valid_buff[7];
					update_valid_buff[7] <= 0;
					se_stall_request <= 1;
				end
			endcase
        end
    end	
endmodule

module CNx8 # (
	parameter DATA_W = 32,
	parameter PIPE_DEPTH = 5
)(
	input wire          			clk,
    input wire          			rst,    
    input wire  [7:0]         		InputValid,
	input wire  [DATA_W*8-1:0]   	InDestVid,    
    input wire  [DATA_W*8-1:0]   	InUpdate,    
    output wire [DATA_W*8-1:0]   	OutUpdate,
    output wire [DATA_W*8-1:0]  	OutDestVid,
	output wire [7:0]  				OutValid
);

wire [7:0]  			Valid_wire  	[4:0];
wire [DATA_W*8-1:0] 	Update_wire 	[4:0];
wire [DATA_W*8-1:0] 	DestVid_wire 	[4:0];
    
// stage 0 
CaC #(.DATA_W(DATA_W), .PIPE_DEPTH(PIPE_DEPTH))
stage00 (
	.clk(clk),
	.rst(rst),
	.InputValid_A(InputValid[0:0]),
	.InputValid_B(InputValid[1:1]),
	.InDestVid_A(InDestVid[DATA_W*0+DATA_W-1:DATA_W*0]),
	.InDestVid_B(InDestVid[DATA_W*1+DATA_W-1:DATA_W*1]),
	.InUpdate_A(InUpdate[DATA_W*0+DATA_W-1:DATA_W*0]),
	.InUpdate_B(InUpdate[DATA_W*1+DATA_W-1:DATA_W*1]),
	.OutUpdate_A(Update_wire[0][DATA_W*0+DATA_W-1:DATA_W*0]),
	.OutUpdate_B(Update_wire[0][DATA_W*1+DATA_W-1:DATA_W*1]),
	.OutDestVid_A(DestVid_wire[0][DATA_W*0+DATA_W-1:DATA_W*0]),
	.OutDestVid_B(DestVid_wire[0][DATA_W*1+DATA_W-1:DATA_W*1]),
	.OutValid_A(Valid_wire[0][0:0]),
	.OutValid_B(Valid_wire[0][1:1])
);

CaC #(.DATA_W(DATA_W), .PIPE_DEPTH(PIPE_DEPTH))
stage01 (
	.clk(clk),
	.rst(rst),
	.InputValid_A(InputValid[2:2]),
	.InputValid_B(InputValid[3:3]),
	.InDestVid_A(InDestVid[DATA_W*2+DATA_W-1:DATA_W*2]),
	.InDestVid_B(InDestVid[DATA_W*3+DATA_W-1:DATA_W*3]),
	.InUpdate_A(InUpdate[DATA_W*2+DATA_W-1:DATA_W*2]),
	.InUpdate_B(InUpdate[DATA_W*3+DATA_W-1:DATA_W*3]),
	.OutUpdate_A(Update_wire[0][DATA_W*2+DATA_W-1:DATA_W*2]),
	.OutUpdate_B(Update_wire[0][DATA_W*3+DATA_W-1:DATA_W*3]),
	.OutDestVid_A(DestVid_wire[0][DATA_W*2+DATA_W-1:DATA_W*2]),
	.OutDestVid_B(DestVid_wire[0][DATA_W*3+DATA_W-1:DATA_W*3]),
	.OutValid_A(Valid_wire[0][2:2]),
	.OutValid_B(Valid_wire[0][3:3])
);

CaC #(.DATA_W(DATA_W), .PIPE_DEPTH(PIPE_DEPTH))
stage02 (
	.clk(clk),
	.rst(rst),
	.InputValid_A(InputValid[4:4]),
	.InputValid_B(InputValid[5:5]),
	.InDestVid_A(InDestVid[DATA_W*4+DATA_W-1:DATA_W*4]),
	.InDestVid_B(InDestVid[DATA_W*5+DATA_W-1:DATA_W*5]),
	.InUpdate_A(InUpdate[DATA_W*4+DATA_W-1:DATA_W*4]),
	.InUpdate_B(InUpdate[DATA_W*5+DATA_W-1:DATA_W*5]),
	.OutUpdate_A(Update_wire[0][DATA_W*4+DATA_W-1:DATA_W*4]),
	.OutUpdate_B(Update_wire[0][DATA_W*5+DATA_W-1:DATA_W*5]),
	.OutDestVid_A(DestVid_wire[0][DATA_W*4+DATA_W-1:DATA_W*4]),
	.OutDestVid_B(DestVid_wire[0][DATA_W*5+DATA_W-1:DATA_W*5]),
	.OutValid_A(Valid_wire[0][4:4]),
	.OutValid_B(Valid_wire[0][5:5])
);

CaC #(.DATA_W(DATA_W), .PIPE_DEPTH(PIPE_DEPTH))
stage03 (
	.clk(clk),
	.rst(rst),
	.InputValid_A(InputValid[6:6]),
	.InputValid_B(InputValid[7:7]),
	.InDestVid_A(InDestVid[DATA_W*6+DATA_W-1:DATA_W*6]),
	.InDestVid_B(InDestVid[DATA_W*7+DATA_W-1:DATA_W*7]),
	.InUpdate_A(InUpdate[DATA_W*6+DATA_W-1:DATA_W*6]),
	.InUpdate_B(InUpdate[DATA_W*7+DATA_W-1:DATA_W*7]),
	.OutUpdate_A(Update_wire[0][DATA_W*6+DATA_W-1:DATA_W*6]),
	.OutUpdate_B(Update_wire[0][DATA_W*7+DATA_W-1:DATA_W*7]),
	.OutDestVid_A(DestVid_wire[0][DATA_W*6+DATA_W-1:DATA_W*6]),
	.OutDestVid_B(DestVid_wire[0][DATA_W*7+DATA_W-1:DATA_W*7]),
	.OutValid_A(Valid_wire[0][6:6]),
	.OutValid_B(Valid_wire[0][7:7])
);

// stage 1
CaC #(.DATA_W(DATA_W), .PIPE_DEPTH(PIPE_DEPTH))
stage10 (
	.clk(clk),
	.rst(rst),
	.InputValid_A(Valid_wire[0][0:0]),
	.InputValid_B(Valid_wire[0][2:2]),
	.InDestVid_A(DestVid_wire[0][DATA_W*0+DATA_W-1:DATA_W*0]),
	.InDestVid_B(DestVid_wire[0][DATA_W*2+DATA_W-1:DATA_W*2]),
	.InUpdate_A(Update_wire[0][DATA_W*0+DATA_W-1:DATA_W*0]),
	.InUpdate_B(Update_wire[0][DATA_W*2+DATA_W-1:DATA_W*2]),
	.OutUpdate_A(Update_wire[1][DATA_W*0+DATA_W-1:DATA_W*0]),
	.OutUpdate_B(Update_wire[1][DATA_W*2+DATA_W-1:DATA_W*2]),
	.OutDestVid_A(DestVid_wire[1][DATA_W*0+DATA_W-1:DATA_W*0]),
	.OutDestVid_B(DestVid_wire[1][DATA_W*2+DATA_W-1:DATA_W*2]),
	.OutValid_A(Valid_wire[1][0:0]),
	.OutValid_B(Valid_wire[1][2:2])
);

CaC #(.DATA_W(DATA_W), .PIPE_DEPTH(PIPE_DEPTH))
stage11 (
	.clk(clk),
	.rst(rst),
	.InputValid_A(Valid_wire[0][1:1]),
	.InputValid_B(Valid_wire[0][3:3]),
	.InDestVid_A(DestVid_wire[0][DATA_W*1+DATA_W-1:DATA_W*1]),
	.InDestVid_B(DestVid_wire[0][DATA_W*3+DATA_W-1:DATA_W*3]),
	.InUpdate_A(Update_wire[0][DATA_W*1+DATA_W-1:DATA_W*1]),
	.InUpdate_B(Update_wire[0][DATA_W*3+DATA_W-1:DATA_W*3]),
	.OutUpdate_A(Update_wire[1][DATA_W*1+DATA_W-1:DATA_W*1]),
	.OutUpdate_B(Update_wire[1][DATA_W*3+DATA_W-1:DATA_W*3]),
	.OutDestVid_A(DestVid_wire[1][DATA_W*1+DATA_W-1:DATA_W*1]),
	.OutDestVid_B(DestVid_wire[1][DATA_W*3+DATA_W-1:DATA_W*3]),
	.OutValid_A(Valid_wire[1][1:1]),
	.OutValid_B(Valid_wire[1][3:3])
);

CaC #(.DATA_W(DATA_W), .PIPE_DEPTH(PIPE_DEPTH))
stage12 (
	.clk(clk),
	.rst(rst),
	.InputValid_A(Valid_wire[0][4:4]),
	.InputValid_B(Valid_wire[0][6:6]),
	.InDestVid_A(DestVid_wire[0][DATA_W*4+DATA_W-1:DATA_W*4]),
	.InDestVid_B(DestVid_wire[0][DATA_W*6+DATA_W-1:DATA_W*6]),
	.InUpdate_A(Update_wire[0][DATA_W*4+DATA_W-1:DATA_W*4]),
	.InUpdate_B(Update_wire[0][DATA_W*6+DATA_W-1:DATA_W*6]),
	.OutUpdate_A(Update_wire[1][DATA_W*4+DATA_W-1:DATA_W*4]),
	.OutUpdate_B(Update_wire[1][DATA_W*6+DATA_W-1:DATA_W*6]),
	.OutDestVid_A(DestVid_wire[1][DATA_W*4+DATA_W-1:DATA_W*4]),
	.OutDestVid_B(DestVid_wire[1][DATA_W*6+DATA_W-1:DATA_W*6]),
	.OutValid_A(Valid_wire[1][4:4]),
	.OutValid_B(Valid_wire[1][6:6])
);

CaC #(.DATA_W(DATA_W), .PIPE_DEPTH(PIPE_DEPTH))
stage13 (
	.clk(clk),
	.rst(rst),
	.InputValid_A(Valid_wire[0][5:5]),
	.InputValid_B(Valid_wire[0][7:7]),
	.InDestVid_A(DestVid_wire[0][DATA_W*5+DATA_W-1:DATA_W*5]),
	.InDestVid_B(DestVid_wire[0][DATA_W*7+DATA_W-1:DATA_W*7]),
	.InUpdate_A(Update_wire[0][DATA_W*5+DATA_W-1:DATA_W*5]),
	.InUpdate_B(Update_wire[0][DATA_W*7+DATA_W-1:DATA_W*7]),
	.OutUpdate_A(Update_wire[1][DATA_W*5+DATA_W-1:DATA_W*5]),
	.OutUpdate_B(Update_wire[1][DATA_W*7+DATA_W-1:DATA_W*7]),
	.OutDestVid_A(DestVid_wire[1][DATA_W*5+DATA_W-1:DATA_W*5]),
	.OutDestVid_B(DestVid_wire[1][DATA_W*7+DATA_W-1:DATA_W*7]),
	.OutValid_A(Valid_wire[1][5:5]),
	.OutValid_B(Valid_wire[1][7:7])
);

// stage 2
CaC #(.DATA_W(DATA_W), .PIPE_DEPTH(PIPE_DEPTH))
stage20 (
	.clk(clk),
	.rst(rst),
	.InputValid_A(Valid_wire[1][0:0]),
	.InputValid_B(Valid_wire[1][1:1]),
	.InDestVid_A(DestVid_wire[1][DATA_W*0+DATA_W-1:DATA_W*0]),
	.InDestVid_B(DestVid_wire[1][DATA_W*1+DATA_W-1:DATA_W*1]),
	.InUpdate_A(Update_wire[1][DATA_W*0+DATA_W-1:DATA_W*0]),
	.InUpdate_B(Update_wire[1][DATA_W*1+DATA_W-1:DATA_W*1]),
	.OutUpdate_A(Update_wire[2][DATA_W*0+DATA_W-1:DATA_W*0]),
	.OutUpdate_B(Update_wire[2][DATA_W*1+DATA_W-1:DATA_W*1]),
	.OutDestVid_A(DestVid_wire[2][DATA_W*0+DATA_W-1:DATA_W*0]),
	.OutDestVid_B(DestVid_wire[2][DATA_W*1+DATA_W-1:DATA_W*1]),
	.OutValid_A(Valid_wire[2][0:0]),
	.OutValid_B(Valid_wire[2][1:1])
);

CaC #(.DATA_W(DATA_W), .PIPE_DEPTH(PIPE_DEPTH))
stage21 (
	.clk(clk),
	.rst(rst),
	.InputValid_A(Valid_wire[1][2:2]),
	.InputValid_B(Valid_wire[1][3:3]),
	.InDestVid_A(DestVid_wire[1][DATA_W*2+DATA_W-1:DATA_W*2]),
	.InDestVid_B(DestVid_wire[1][DATA_W*3+DATA_W-1:DATA_W*3]),
	.InUpdate_A(Update_wire[1][DATA_W*2+DATA_W-1:DATA_W*2]),
	.InUpdate_B(Update_wire[1][DATA_W*3+DATA_W-1:DATA_W*3]),
	.OutUpdate_A(Update_wire[2][DATA_W*2+DATA_W-1:DATA_W*2]),
	.OutUpdate_B(Update_wire[2][DATA_W*3+DATA_W-1:DATA_W*3]),
	.OutDestVid_A(DestVid_wire[2][DATA_W*2+DATA_W-1:DATA_W*2]),
	.OutDestVid_B(DestVid_wire[2][DATA_W*3+DATA_W-1:DATA_W*3]),
	.OutValid_A(Valid_wire[2][2:2]),
	.OutValid_B(Valid_wire[2][3:3])
);

CaC #(.DATA_W(DATA_W), .PIPE_DEPTH(PIPE_DEPTH))
stage22 (
	.clk(clk),
	.rst(rst),
	.InputValid_A(Valid_wire[1][4:4]),
	.InputValid_B(Valid_wire[1][5:5]),
	.InDestVid_A(DestVid_wire[1][DATA_W*4+DATA_W-1:DATA_W*4]),
	.InDestVid_B(DestVid_wire[1][DATA_W*5+DATA_W-1:DATA_W*5]),
	.InUpdate_A(Update_wire[1][DATA_W*4+DATA_W-1:DATA_W*4]),
	.InUpdate_B(Update_wire[1][DATA_W*5+DATA_W-1:DATA_W*5]),
	.OutUpdate_A(Update_wire[2][DATA_W*4+DATA_W-1:DATA_W*4]),
	.OutUpdate_B(Update_wire[2][DATA_W*5+DATA_W-1:DATA_W*5]),
	.OutDestVid_A(DestVid_wire[2][DATA_W*4+DATA_W-1:DATA_W*4]),
	.OutDestVid_B(DestVid_wire[2][DATA_W*5+DATA_W-1:DATA_W*5]),
	.OutValid_A(Valid_wire[2][4:4]),
	.OutValid_B(Valid_wire[2][5:5])
);

CaC #(.DATA_W(DATA_W), .PIPE_DEPTH(PIPE_DEPTH))
stage23 (
	.clk(clk),
	.rst(rst),
	.InputValid_A(Valid_wire[1][6:6]),
	.InputValid_B(Valid_wire[1][7:7]),
	.InDestVid_A(DestVid_wire[1][DATA_W*6+DATA_W-1:DATA_W*6]),
	.InDestVid_B(DestVid_wire[1][DATA_W*7+DATA_W-1:DATA_W*7]),
	.InUpdate_A(Update_wire[1][DATA_W*6+DATA_W-1:DATA_W*6]),
	.InUpdate_B(Update_wire[1][DATA_W*7+DATA_W-1:DATA_W*7]),
	.OutUpdate_A(Update_wire[2][DATA_W*6+DATA_W-1:DATA_W*6]),
	.OutUpdate_B(Update_wire[2][DATA_W*7+DATA_W-1:DATA_W*7]),
	.OutDestVid_A(DestVid_wire[2][DATA_W*6+DATA_W-1:DATA_W*6]),
	.OutDestVid_B(DestVid_wire[2][DATA_W*7+DATA_W-1:DATA_W*7]),
	.OutValid_A(Valid_wire[2][6:6]),
	.OutValid_B(Valid_wire[2][7:7])
);

// stage 3
CaC #(.DATA_W(DATA_W), .PIPE_DEPTH(PIPE_DEPTH))
stage30 (
	.clk(clk),
	.rst(rst),
	.InputValid_A(Valid_wire[2][0:0]),
	.InputValid_B(Valid_wire[2][4:4]),
	.InDestVid_A(DestVid_wire[2][DATA_W*0+DATA_W-1:DATA_W*0]),
	.InDestVid_B(DestVid_wire[2][DATA_W*4+DATA_W-1:DATA_W*4]),
	.InUpdate_A(Update_wire[2][DATA_W*0+DATA_W-1:DATA_W*0]),
	.InUpdate_B(Update_wire[2][DATA_W*4+DATA_W-1:DATA_W*4]),
	.OutUpdate_A(Update_wire[3][DATA_W*0+DATA_W-1:DATA_W*0]),
	.OutUpdate_B(Update_wire[3][DATA_W*4+DATA_W-1:DATA_W*4]),
	.OutDestVid_A(DestVid_wire[3][DATA_W*0+DATA_W-1:DATA_W*0]),
	.OutDestVid_B(DestVid_wire[3][DATA_W*4+DATA_W-1:DATA_W*4]),
	.OutValid_A(Valid_wire[3][0:0]),
	.OutValid_B(Valid_wire[3][4:4])
);

CaC #(.DATA_W(DATA_W), .PIPE_DEPTH(PIPE_DEPTH))
stage31 (
	.clk(clk),
	.rst(rst),
	.InputValid_A(Valid_wire[2][1:1]),
	.InputValid_B(Valid_wire[2][5:5]),
	.InDestVid_A(DestVid_wire[2][DATA_W*1+DATA_W-1:DATA_W*1]),
	.InDestVid_B(DestVid_wire[2][DATA_W*5+DATA_W-1:DATA_W*5]),
	.InUpdate_A(Update_wire[2][DATA_W*1+DATA_W-1:DATA_W*1]),
	.InUpdate_B(Update_wire[2][DATA_W*5+DATA_W-1:DATA_W*5]),
	.OutUpdate_A(Update_wire[3][DATA_W*1+DATA_W-1:DATA_W*1]),
	.OutUpdate_B(Update_wire[3][DATA_W*5+DATA_W-1:DATA_W*5]),
	.OutDestVid_A(DestVid_wire[3][DATA_W*1+DATA_W-1:DATA_W*1]),
	.OutDestVid_B(DestVid_wire[3][DATA_W*5+DATA_W-1:DATA_W*5]),
	.OutValid_A(Valid_wire[3][1:1]),
	.OutValid_B(Valid_wire[3][5:5])
);

CaC #(.DATA_W(DATA_W), .PIPE_DEPTH(PIPE_DEPTH))
stage32 (
	.clk(clk),
	.rst(rst),
	.InputValid_A(Valid_wire[2][2:2]),
	.InputValid_B(Valid_wire[2][6:6]),
	.InDestVid_A(DestVid_wire[2][DATA_W*2+DATA_W-1:DATA_W*2]),
	.InDestVid_B(DestVid_wire[2][DATA_W*6+DATA_W-1:DATA_W*6]),
	.InUpdate_A(Update_wire[2][DATA_W*2+DATA_W-1:DATA_W*2]),
	.InUpdate_B(Update_wire[2][DATA_W*6+DATA_W-1:DATA_W*6]),
	.OutUpdate_A(Update_wire[3][DATA_W*2+DATA_W-1:DATA_W*2]),
	.OutUpdate_B(Update_wire[3][DATA_W*6+DATA_W-1:DATA_W*6]),
	.OutDestVid_A(DestVid_wire[3][DATA_W*2+DATA_W-1:DATA_W*2]),
	.OutDestVid_B(DestVid_wire[3][DATA_W*6+DATA_W-1:DATA_W*6]),
	.OutValid_A(Valid_wire[3][2:2]),
	.OutValid_B(Valid_wire[3][6:6])
);

CaC #(.DATA_W(DATA_W), .PIPE_DEPTH(PIPE_DEPTH))
stage33 (
	.clk(clk),
	.rst(rst),
	.InputValid_A(Valid_wire[2][3:3]),
	.InputValid_B(Valid_wire[2][7:7]),
	.InDestVid_A(DestVid_wire[2][DATA_W*3+DATA_W-1:DATA_W*3]),
	.InDestVid_B(DestVid_wire[2][DATA_W*7+DATA_W-1:DATA_W*7]),
	.InUpdate_A(Update_wire[2][DATA_W*3+DATA_W-1:DATA_W*3]),
	.InUpdate_B(Update_wire[2][DATA_W*7+DATA_W-1:DATA_W*7]),
	.OutUpdate_A(Update_wire[3][DATA_W*3+DATA_W-1:DATA_W*3]),
	.OutUpdate_B(Update_wire[3][DATA_W*7+DATA_W-1:DATA_W*7]),
	.OutDestVid_A(DestVid_wire[3][DATA_W*3+DATA_W-1:DATA_W*3]),
	.OutDestVid_B(DestVid_wire[3][DATA_W*7+DATA_W-1:DATA_W*7]),
	.OutValid_A(Valid_wire[3][3:3]),
	.OutValid_B(Valid_wire[3][7:7])
);

// stage 4
CaC #(.DATA_W(DATA_W), .PIPE_DEPTH(PIPE_DEPTH))
stage40 (
	.clk(clk),
	.rst(rst),
	.InputValid_A(Valid_wire[3][0:0]),
	.InputValid_B(Valid_wire[3][2:2]),
	.InDestVid_A(DestVid_wire[3][DATA_W*0+DATA_W-1:DATA_W*0]),
	.InDestVid_B(DestVid_wire[3][DATA_W*2+DATA_W-1:DATA_W*2]),
	.InUpdate_A(Update_wire[3][DATA_W*0+DATA_W-1:DATA_W*0]),
	.InUpdate_B(Update_wire[3][DATA_W*2+DATA_W-1:DATA_W*2]),
	.OutUpdate_A(Update_wire[4][DATA_W*0+DATA_W-1:DATA_W*0]),
	.OutUpdate_B(Update_wire[4][DATA_W*2+DATA_W-1:DATA_W*2]),
	.OutDestVid_A(DestVid_wire[4][DATA_W*0+DATA_W-1:DATA_W*0]),
	.OutDestVid_B(DestVid_wire[4][DATA_W*2+DATA_W-1:DATA_W*2]),
	.OutValid_A(Valid_wire[4][0:0]),
	.OutValid_B(Valid_wire[4][2:2])
);

CaC #(.DATA_W(DATA_W), .PIPE_DEPTH(PIPE_DEPTH))
stage41 (
	.clk(clk),
	.rst(rst),
	.InputValid_A(Valid_wire[3][1:1]),
	.InputValid_B(Valid_wire[3][3:3]),
	.InDestVid_A(DestVid_wire[3][DATA_W*1+DATA_W-1:DATA_W*1]),
	.InDestVid_B(DestVid_wire[3][DATA_W*3+DATA_W-1:DATA_W*3]),
	.InUpdate_A(Update_wire[3][DATA_W*1+DATA_W-1:DATA_W*1]),
	.InUpdate_B(Update_wire[3][DATA_W*3+DATA_W-1:DATA_W*3]),
	.OutUpdate_A(Update_wire[4][DATA_W*1+DATA_W-1:DATA_W*1]),
	.OutUpdate_B(Update_wire[4][DATA_W*3+DATA_W-1:DATA_W*3]),
	.OutDestVid_A(DestVid_wire[4][DATA_W*1+DATA_W-1:DATA_W*1]),
	.OutDestVid_B(DestVid_wire[4][DATA_W*3+DATA_W-1:DATA_W*3]),
	.OutValid_A(Valid_wire[4][1:1]),
	.OutValid_B(Valid_wire[4][3:3])
);

CaC #(.DATA_W(DATA_W), .PIPE_DEPTH(PIPE_DEPTH))
stage42 (
	.clk(clk),
	.rst(rst),
	.InputValid_A(Valid_wire[3][4:4]),
	.InputValid_B(Valid_wire[3][6:6]),
	.InDestVid_A(DestVid_wire[3][DATA_W*4+DATA_W-1:DATA_W*4]),
	.InDestVid_B(DestVid_wire[3][DATA_W*6+DATA_W-1:DATA_W*6]),
	.InUpdate_A(Update_wire[3][DATA_W*4+DATA_W-1:DATA_W*4]),
	.InUpdate_B(Update_wire[3][DATA_W*6+DATA_W-1:DATA_W*6]),
	.OutUpdate_A(Update_wire[4][DATA_W*4+DATA_W-1:DATA_W*4]),
	.OutUpdate_B(Update_wire[4][DATA_W*6+DATA_W-1:DATA_W*6]),
	.OutDestVid_A(DestVid_wire[4][DATA_W*4+DATA_W-1:DATA_W*4]),
	.OutDestVid_B(DestVid_wire[4][DATA_W*6+DATA_W-1:DATA_W*6]),
	.OutValid_A(Valid_wire[4][4:4]),
	.OutValid_B(Valid_wire[4][6:6])
);

CaC #(.DATA_W(DATA_W), .PIPE_DEPTH(PIPE_DEPTH))
stage43 (
	.clk(clk),
	.rst(rst),
	.InputValid_A(Valid_wire[3][5:5]),
	.InputValid_B(Valid_wire[3][7:7]),
	.InDestVid_A(DestVid_wire[3][DATA_W*5+DATA_W-1:DATA_W*5]),
	.InDestVid_B(DestVid_wire[3][DATA_W*7+DATA_W-1:DATA_W*7]),
	.InUpdate_A(Update_wire[3][DATA_W*5+DATA_W-1:DATA_W*5]),
	.InUpdate_B(Update_wire[3][DATA_W*7+DATA_W-1:DATA_W*7]),
	.OutUpdate_A(Update_wire[4][DATA_W*5+DATA_W-1:DATA_W*5]),
	.OutUpdate_B(Update_wire[4][DATA_W*7+DATA_W-1:DATA_W*7]),
	.OutDestVid_A(DestVid_wire[4][DATA_W*5+DATA_W-1:DATA_W*5]),
	.OutDestVid_B(DestVid_wire[4][DATA_W*7+DATA_W-1:DATA_W*7]),
	.OutValid_A(Valid_wire[4][5:5]),
	.OutValid_B(Valid_wire[4][7:7])
);

// stage 5
CaC #(.DATA_W(DATA_W), .PIPE_DEPTH(PIPE_DEPTH))
stage50 (
	.clk(clk),
	.rst(rst),
	.InputValid_A(Valid_wire[4][0:0]),
	.InputValid_B(Valid_wire[4][1:1]),
	.InDestVid_A(DestVid_wire[4][DATA_W*0+DATA_W-1:DATA_W*0]),
	.InDestVid_B(DestVid_wire[4][DATA_W*1+DATA_W-1:DATA_W*1]),
	.InUpdate_A(Update_wire[4][DATA_W*0+DATA_W-1:DATA_W*0]),
	.InUpdate_B(Update_wire[4][DATA_W*1+DATA_W-1:DATA_W*1]),
	.OutUpdate_A(OutUpdate[DATA_W*0+DATA_W-1:DATA_W*0]),
	.OutUpdate_B(OutUpdate[DATA_W*1+DATA_W-1:DATA_W*1]),
	.OutDestVid_A(OutDestVid[DATA_W*0+DATA_W-1:DATA_W*0]),
	.OutDestVid_B(OutDestVid[DATA_W*1+DATA_W-1:DATA_W*1]),
	.OutValid_A(OutValid[0:0]),
	.OutValid_B(OutValid[1:1])
);

CaC #(.DATA_W(DATA_W), .PIPE_DEPTH(PIPE_DEPTH))
stage51 (
	.clk(clk),
	.rst(rst),
	.InputValid_A(Valid_wire[4][2:2]),
	.InputValid_B(Valid_wire[4][3:3]),
	.InDestVid_A(DestVid_wire[4][DATA_W*2+DATA_W-1:DATA_W*2]),
	.InDestVid_B(DestVid_wire[4][DATA_W*3+DATA_W-1:DATA_W*3]),
	.InUpdate_A(Update_wire[4][DATA_W*2+DATA_W-1:DATA_W*2]),
	.InUpdate_B(Update_wire[4][DATA_W*3+DATA_W-1:DATA_W*3]),
	.OutUpdate_A(OutUpdate[DATA_W*2+DATA_W-1:DATA_W*2]),
	.OutUpdate_B(OutUpdate[DATA_W*3+DATA_W-1:DATA_W*3]),
	.OutDestVid_A(OutDestVid[DATA_W*2+DATA_W-1:DATA_W*2]),
	.OutDestVid_B(OutDestVid[DATA_W*3+DATA_W-1:DATA_W*3]),
	.OutValid_A(OutValid[2:2]),
	.OutValid_B(OutValid[3:3])
);

CaC #(.DATA_W(DATA_W), .PIPE_DEPTH(PIPE_DEPTH))
stage52 (
	.clk(clk),
	.rst(rst),
	.InputValid_A(Valid_wire[4][4:4]),
	.InputValid_B(Valid_wire[4][5:5]),
	.InDestVid_A(DestVid_wire[4][DATA_W*4+DATA_W-1:DATA_W*4]),
	.InDestVid_B(DestVid_wire[4][DATA_W*5+DATA_W-1:DATA_W*5]),
	.InUpdate_A(Update_wire[4][DATA_W*4+DATA_W-1:DATA_W*4]),
	.InUpdate_B(Update_wire[4][DATA_W*5+DATA_W-1:DATA_W*5]),
	.OutUpdate_A(OutUpdate[DATA_W*4+DATA_W-1:DATA_W*4]),
	.OutUpdate_B(OutUpdate[DATA_W*5+DATA_W-1:DATA_W*5]),
	.OutDestVid_A(OutDestVid[DATA_W*4+DATA_W-1:DATA_W*4]),
	.OutDestVid_B(OutDestVid[DATA_W*5+DATA_W-1:DATA_W*5]),
	.OutValid_A(OutValid[4:4]),
	.OutValid_B(OutValid[5:5])
);

CaC #(.DATA_W(DATA_W), .PIPE_DEPTH(PIPE_DEPTH))
stage53 (
	.clk(clk),
	.rst(rst),
	.InputValid_A(Valid_wire[4][6:6]),
	.InputValid_B(Valid_wire[4][7:7]),
	.InDestVid_A(DestVid_wire[4][DATA_W*6+DATA_W-1:DATA_W*6]),
	.InDestVid_B(DestVid_wire[4][DATA_W*7+DATA_W-1:DATA_W*7]),
	.InUpdate_A(Update_wire[4][DATA_W*6+DATA_W-1:DATA_W*6]),
	.InUpdate_B(Update_wire[4][DATA_W*7+DATA_W-1:DATA_W*7]),
	.OutUpdate_A(OutUpdate[DATA_W*6+DATA_W-1:DATA_W*6]),
	.OutUpdate_B(OutUpdate[DATA_W*7+DATA_W-1:DATA_W*7]),
	.OutDestVid_A(OutDestVid[DATA_W*6+DATA_W-1:DATA_W*6]),
	.OutDestVid_B(OutDestVid[DATA_W*7+DATA_W-1:DATA_W*7]),
	.OutValid_A(OutValid[6:6]),
	.OutValid_B(OutValid[7:7])
);

endmodule

module Ubuffx8(
    input wire clk,
    input wire rst,    
    input wire last_input_in,
    input wire [64*8-1:0] word_in,
	input wire [7:0] word_in_valid,
    //input wire [1:0] control,        
    output reg [64*8-1:0] word_out, 
    output reg [7:0] valid_out
);

reg [2:0]		counter;
reg	[63:0]	update_buff [6:0];

integer i;
	
always @ (posedge clk) begin
	if (rst) begin
		counter <=0;
		word_out <=0;
		valid_out <=8'b00000000;
		for(i=0; i<7; i=i+1) begin 
			update_buff [i] <=0;            
		end
	end else begin		
		counter <= counter;				
		for(i=0; i<7; i=i+1) begin 
			update_buff [i] <= update_buff [i] ;            
		end
		word_out  <= 0;
		valid_out <= 8'b00000000;
		if(last_input_in) begin			
			valid_out	<= 	(counter == 0) ? 8'b00000000 :
										(counter == 1) ? 8'b10000000 :
										(counter == 2) ? 8'b11000000 :
										(counter == 3) ? 8'b11100000 :
										(counter == 4) ? 8'b11110000 :
										(counter == 5) ? 8'b11111000 :
										(counter == 6) ? 8'b11111100 : 8'b11111110;						   
			word_out	<= {update_buff[0],update_buff[1],update_buff[2],update_buff[3],update_buff[4],update_buff[5],update_buff[6], 64'h000000000000000};	
			counter		<= 0;
		end else begin								
			case(word_in_valid)					
				8'b10000000: begin                    
					if(counter<7) begin
					   counter <= counter +1;
					   update_buff[counter] <= word_in[511:448]; 
					   valid_out <= 8'b00000000;
					end else begin
					   counter <= 0;
					   valid_out <=8'b11111111;
					   word_out <= {update_buff[0],update_buff[1],update_buff[2],update_buff[3],update_buff[4],update_buff[5],update_buff[6], word_in[511:448]}; 
					end                        
				end
				8'b11000000: begin                    
				   if(counter<6) begin
					  counter <= counter +2;
					  valid_out <= 8'b00000000;
					  update_buff[counter]   <= word_in[511:448]; 
					  update_buff[counter+1] <= word_in[447:384]; 
				   end else if (counter==6) begin
					  counter <= 0;
					  valid_out <=8'b11111111;
					  word_out <= {update_buff[0],update_buff[1],update_buff[2],update_buff[3],update_buff[4],update_buff[5], word_in[511:384]};
				  end else begin
					  counter <= 1;
					  valid_out <= 8'b11111111;
					  word_out <= {update_buff[0],update_buff[1],update_buff[2],update_buff[3],update_buff[4],update_buff[5],update_buff[6], word_in[511:448]}; 
					  update_buff[0] <= word_in[447:384];       
				   end                       
			   end
			   8'b11100000: begin                    
				  if(counter<5) begin
					 counter <= counter +3;
					 valid_out <= 8'b00000000;
					 update_buff[counter]   <= word_in[511:448]; 
					 update_buff[counter+1] <= word_in[447:384]; 
					 update_buff[counter+2] <= word_in[383:320]; 
				  end else if (counter==5) begin
					 counter  	<= 0;
					 valid_out 	<= 8'b11111111;
					 word_out  	<= {update_buff[0],update_buff[1],update_buff[2],update_buff[3],update_buff[4], word_in[511:320]};
				 end else if (counter==6) begin
					 counter <= 1;
					 valid_out <= 8'b11111111;
					 word_out <= {update_buff[0],update_buff[1],update_buff[2],update_buff[3],update_buff[4],update_buff[5], word_in[511:384]};
					 update_buff[0] <= word_in[383:320];                             
				  end else begin
					 counter 	<= 2;
					 valid_out 	<=8'b11111111;
					 word_out 	<= {update_buff[0],update_buff[1],update_buff[2],update_buff[3],update_buff[4],update_buff[5],update_buff[6], word_in[511:448]};
					 update_buff[0] <= word_in[447:384]; 
					 update_buff[1] <= word_in[383:320]; 
				  end                                        
			   end
			   8'b11110000: begin                    
					 if(counter<4) begin
						counter <= counter +4;
						valid_out <= 8'b00000000;
						update_buff[counter]   <= word_in[511:448]; 
						update_buff[counter+1] <= word_in[447:384]; 
						update_buff[counter+2] <= word_in[383:320]; 
						update_buff[counter+3] <= word_in[319:256];
					 end else if (counter==4) begin
						counter <= 0;
						valid_out <=8'b11111111;
						word_out <= {update_buff[0],update_buff[1],update_buff[2],update_buff[3], word_in[511:256]};
					end else if (counter==5) begin
						counter <= 1;
						valid_out <=8'b11111111;
						word_out <= {update_buff[0],update_buff[1],update_buff[2],update_buff[3],update_buff[4],word_in[511:320]}; 
						update_buff[0] <= word_in[319:256];                                
					 end else if (counter==6) begin
						 counter <= 2;
						 valid_out <=8'b11111111;
						 word_out <= {update_buff[0],update_buff[1],update_buff[2],update_buff[3],update_buff[4],update_buff[5],word_in[511:384]};
						 update_buff[0] <= word_in[383:320]; 
						 update_buff[1] <= word_in[319:256];                   
					 end else begin
						counter <= 3;
						valid_out <=8'b11111111;
						word_out <= {update_buff[0],update_buff[1],update_buff[2],update_buff[3],update_buff[4],update_buff[5],update_buff[6],word_in[511:448]};
						update_buff[0] <= word_in[447:384]; 
						update_buff[1] <= word_in[383:320];  
						update_buff[2] <= word_in[319:256];
					 end                                        
			   end
			   8'b11111000: begin                    
					if(counter<3) begin
					   counter <= counter+5;
					   valid_out <= 8'b00000000;
					   update_buff[counter]   <= word_in[511:448]; 
					   update_buff[counter+1] <= word_in[447:384];
					   update_buff[counter+2] <= word_in[383:320];
					   update_buff[counter+3] <= word_in[319:256];
					   update_buff[counter+4] <= word_in[255:192];
					end else if (counter==3) begin
					   counter <= 0;
					   valid_out <=8'b11111111;
					   word_out <= {update_buff[0],update_buff[1],update_buff[2],word_in[511:192]};
				    end else if (counter==4) begin
					   counter <= 1;
					   valid_out <=8'b11111111;
					   word_out <= {update_buff[0],update_buff[1],update_buff[2],update_buff[3], word_in[511:256]}; 
					   update_buff[0] <= word_in[255:192];                                
					end else if (counter==5) begin
						counter <= 2;
						valid_out <=8'b11111111;
						word_out <= {update_buff[0],update_buff[1],update_buff[2],update_buff[3],update_buff[4], word_in[511:320]};
						update_buff[0] <= word_in[319:256];
						update_buff[1] <= word_in[255:192];           
					end else if (counter==6) begin
						counter   <= 3;
						valid_out <=8'b11111111;
						word_out <= {update_buff[0],update_buff[1],update_buff[2],update_buff[3],update_buff[4],update_buff[5], word_in[511:384]};
						update_buff[0] <= word_in[383:320];
						update_buff[1] <= word_in[319:256];
						update_buff[2] <= word_in[255:192];
					end else begin
					   counter <= 4;
					   valid_out <=8'b11111111;
					   word_out <= {update_buff[0],update_buff[1],update_buff[2],update_buff[3],update_buff[4],update_buff[5],update_buff[6],word_in[511:448]};
					   update_buff[0] <= word_in[447:384];
					   update_buff[1] <= word_in[383:320];
					   update_buff[2] <= word_in[319:256];
					   update_buff[3] <= word_in[255:192];
					end                                        
				end
				8'b11111100: begin                    
					if(counter<2) begin
					   counter <= counter+6;
					   valid_out <= 8'b00000000;
					   update_buff[counter]   <= word_in[511:448]; 
					   update_buff[counter+1] <= word_in[447:384];
					   update_buff[counter+2] <= word_in[383:320];
					   update_buff[counter+3] <= word_in[319:256];
					   update_buff[counter+4] <= word_in[255:192];
					   update_buff[counter+5] <= word_in[191:128];
					end else if (counter==2) begin
					   counter <= 0;
					   valid_out <=8'b11111111;
					   word_out <= {update_buff[0],update_buff[1], word_in[511:128]};                                                                       
					end else if (counter==3) begin
					   counter <= 1;
					   valid_out <=8'b11111111;
					   word_out <= {update_buff[0],update_buff[1],update_buff[2], word_in[511:192]}; 
					   update_buff[0] <= word_in[191:128];                                
					end else if (counter==4) begin
						counter <= 2;
						valid_out <=8'b11111111;
						word_out <= {update_buff[0],update_buff[1],update_buff[2],update_buff[3], word_in[511:256]};
						update_buff[0] <= word_in[255:192];
						update_buff[1] <= word_in[191:128];                                             
					end else if (counter==5) begin
						counter   <= 3;
						valid_out <=8'b11111111;
						word_out <= {update_buff[0],update_buff[1],update_buff[2],update_buff[3],update_buff[4], word_in[511:320]};
						update_buff[0] <= word_in[319:256];
						update_buff[1] <= word_in[255:192];
						update_buff[2] <= word_in[191:128];
					end else if (counter==6) begin
					   counter 		<= 4;
					   valid_out 	<=8'b11111111;
					   word_out 	<= {update_buff[0],update_buff[1],update_buff[2],update_buff[3],update_buff[4],update_buff[5], word_in[511:384]};
					   update_buff[0] <= word_in[383:320];
					   update_buff[1] <= word_in[319:256];
					   update_buff[2] <= word_in[255:192];   
					   update_buff[3] <= word_in[191:128];
					end else begin
					   counter 		<= 5;
					   valid_out 	<=8'b11111111;
					   word_out 	<= {update_buff[0],update_buff[1],update_buff[2],update_buff[3],update_buff[4],update_buff[5],update_buff[6],word_in[511:448]};
					   update_buff[0] <= word_in[447:384];
					   update_buff[1] <= word_in[383:320];
					   update_buff[2] <= word_in[319:256];
					   update_buff[3] <= word_in[255:192];  
					   update_buff[4] <= word_in[191:128];
					end                                        
				end
				8'b11111110: begin                    
					if(counter==0) begin
					   counter <= counter+7;
					   valid_out <= 8'b00000000;
					   update_buff[counter]   <= word_in[511:448]; 
					   update_buff[counter+1] <= word_in[447:384];
					   update_buff[counter+2] <= word_in[383:320];
					   update_buff[counter+3] <= word_in[319:256];
					   update_buff[counter+4] <= word_in[255:192];
					   update_buff[counter+5] <= word_in[191:128];
					   update_buff[counter+6] <= word_in[127:64];
					end else if (counter==1) begin
					   counter <= 0;
					   valid_out <=8'b11111111;
					   word_out <= {update_buff[0], word_in[511:64]};                                                                       
					end else if (counter==2) begin
					   counter <= 1;
					   valid_out <=8'b11111111;
					   word_out <= {update_buff[0],update_buff[1], word_in[511:128]}; 
					   update_buff[0] <= word_in[127:64];                        
					end else if (counter==3) begin
						counter <= 2;
						valid_out <=8'b11111111;
						word_out <= {update_buff[0],update_buff[1],update_buff[2],word_in[511:192]};
						update_buff[0] <= word_in[191:128];
						update_buff[1] <= word_in[127:64];                                          
					end else if (counter==4) begin
						counter   <= 3;
						valid_out <=8'b11111111;
						word_out <= {update_buff[0],update_buff[1],update_buff[2],update_buff[3], word_in[511:256]};
						update_buff[0] <= word_in[255:192];
						update_buff[1] <= word_in[191:128];
						update_buff[2] <= word_in[127:64];                       
					end else if (counter==5) begin
					   counter <= 4;
					   valid_out <=8'b11111111;
					   word_out <= {update_buff[0],update_buff[1],update_buff[2],update_buff[3],update_buff[4], word_in[511:320]};                           
					   update_buff[0] <= word_in[319:256];
					   update_buff[1] <= word_in[255:192];
					   update_buff[2] <= word_in[191:128];
					   update_buff[3] <= word_in[127:64];       
					end else if (counter==6) begin
						  counter <= 5;
						  valid_out <=8'b11111111;
						  word_out <= {update_buff[0],update_buff[1],update_buff[2],update_buff[3],update_buff[4],update_buff[5], word_in[511:384]};
						  update_buff[0] <= word_in[383:320];
						  update_buff[1] <= word_in[319:256];
						  update_buff[2] <= word_in[255:192];
						  update_buff[3] <= word_in[191:128];
						  update_buff[4] <= word_in[127:64];          
					end else begin
					   counter <= 6;
					   valid_out <=8'b11111111;
					   word_out <= {update_buff[0],update_buff[1],update_buff[2],update_buff[3],update_buff[4],update_buff[5],update_buff[6],word_in[511:448]};
					   update_buff[0] <= word_in[447:384];
					   update_buff[1] <= word_in[383:320];
					   update_buff[2] <= word_in[319:256];
					   update_buff[3] <= word_in[255:192];
					   update_buff[4] <= word_in[191:128];
					   update_buff[5] <= word_in[127:64];     
				   end                                        
				end
				default: begin                    											   
					valid_out <=8'b11111111;
					word_out <= word_in;					                                          
				end						
			endcase	
		end  
	end         
end
  
endmodule

module CaC # (
	parameter DATA_W = 32,
	parameter PIPE_DEPTH = 3
)(
	input wire          		clk,
    input wire          		rst,    
    input wire  [0:0]         	InputValid_A,
    input wire  [0:0]         	InputValid_B,
	input wire  [DATA_W-1:0]   	InDestVid_A,
    input wire  [DATA_W-1:0]   	InDestVid_B,
    input wire  [DATA_W-1:0]   	InUpdate_A,
    input wire  [DATA_W-1:0]   	InUpdate_B,
    output wire [DATA_W-1:0]   	OutUpdate_A,
    output wire [DATA_W-1:0]   	OutUpdate_B,
	output wire [DATA_W-1:0]  	OutDestVid_A,
    output wire [DATA_W-1:0]  	OutDestVid_B,
    output wire [0:0]  			OutValid_A,
	output wire [0:0]  			OutValid_B
);

reg [0:0]			Valid_reg_A 	[PIPE_DEPTH-1:0];
reg [0:0]			Valid_reg_B 	[PIPE_DEPTH-1:0];
reg [DATA_W-1:0]	DestVid_reg_A 	[PIPE_DEPTH-1:0];
reg [DATA_W-1:0]	DestVid_reg_B 	[PIPE_DEPTH-1:0];
reg [DATA_W-1:0]	Update_reg_A 	[PIPE_DEPTH-1:0];
reg [DATA_W-1:0]	Update_reg_B 	[PIPE_DEPTH-1:0];
integer i;

always @(posedge clk) begin
	if (rst) begin
		for(i=0; i<PIPE_DEPTH; i=i+1) begin 
            Valid_reg_A [i] <= 0;    
			Valid_reg_B [i] <= 0;
			DestVid_reg_A [i] <= 0;
			DestVid_reg_B [i] <= 0;
			Update_reg_A [i] <= 0;
			Update_reg_B [i] <= 0;
        end 
	end	else begin
		Valid_reg_A[0] <= (InputValid_A & InputValid_B & InDestVid_B<InDestVid_A) ? InputValid_B : InputValid_A;
		Valid_reg_B[0] <= (InputValid_A & InputValid_B & InDestVid_B>InDestVid_A) ? InputValid_A : InputValid_B;
		DestVid_reg_A[0] <= (InputValid_A & InputValid_B & InDestVid_B<InDestVid_A) ? InDestVid_B : InDestVid_A;
		DestVid_reg_B[0] <= (InputValid_A & InputValid_B & InDestVid_B>InDestVid_A) ? InDestVid_A : InDestVid_B;
		Update_reg_A [0] <= (InputValid_A & InputValid_B & InDestVid_B<InDestVid_A) ? InUpdate_B : InUpdate_A;
		Update_reg_B [0] <= (InputValid_A & InputValid_B & InDestVid_B>InDestVid_A) ? InUpdate_A : InUpdate_B;
		for(i=1; i<PIPE_DEPTH; i=i+1) begin 
            Valid_reg_A [i] <= Valid_reg_A [i-1];    
			Valid_reg_B [i] <= Valid_reg_B [i-1];
			DestVid_reg_A [i] <= DestVid_reg_A [i-1];
			DestVid_reg_B [i] <= DestVid_reg_B [i-1];
			Update_reg_A [i] <= Update_reg_A [i-1];
			Update_reg_B [i] <= Update_reg_B [i-1];
        end 		
	end
end
	
wire [DATA_W-1:0] result; 
	
combine_unit combiner(
    .clk    (clk),    
    .update_A (Update_reg_A [0]),    
    .update_B (Update_reg_B [0]),                          
    .combined_update (result)
);  

assign OutDestVid_A = 	DestVid_reg_A[PIPE_DEPTH-1];
assign OutDestVid_B = 	DestVid_reg_A[PIPE_DEPTH-1];
assign OutValid_A	= 	Valid_reg_A[PIPE_DEPTH-1];
assign OutValid_B 	= 	(Valid_reg_A[PIPE_DEPTH-1] & Valid_reg_B[PIPE_DEPTH-1] & (DestVid_reg_A[PIPE_DEPTH-1]==DestVid_reg_B[PIPE_DEPTH-1])) ? 1'b0 : Valid_reg_B[PIPE_DEPTH-1];
assign OutUpdate_A 	= 	(Valid_reg_A[PIPE_DEPTH-1] & Valid_reg_B[PIPE_DEPTH-1] & (DestVid_reg_A[PIPE_DEPTH-1]==DestVid_reg_B[PIPE_DEPTH-1])) ? result : Update_reg_A [PIPE_DEPTH-1];
assign OutUpdate_B 	= 	(Valid_reg_A[PIPE_DEPTH-1] & Valid_reg_B[PIPE_DEPTH-1] & (DestVid_reg_A[PIPE_DEPTH-1]==DestVid_reg_B[PIPE_DEPTH-1])) ? 0 : Update_reg_B [PIPE_DEPTH-1];
	
endmodule

module combine_unit (
    input wire clk,
    input wire [31:0] update_A,
    input wire [31:0] update_B,
    output wire [31:0] combined_update
);

fp_add adder(              
    .aclk(clk),
    .s_axis_a_tvalid(1'b1),        
    .s_axis_a_tdata(update_A),
    .s_axis_b_tvalid(1'b1),
    .s_axis_b_tdata(update_B),    
    .m_axis_result_tready(1'b1),      
    .m_axis_result_tdata(combined_update)              
);
endmodule