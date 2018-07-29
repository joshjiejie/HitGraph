module spmv_combine_unit (
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


module spmv_gather_pipe # (
    parameter PIPE_DEPTH = 3,
    parameter PAR_SIZE_W = 18
)(
    input wire                      clk,
    input wire                      rst,        
    input wire [31:0]               update_value,
    input wire [31:0]               update_dest,
    input wire [63:0]               dest_attr,
    input wire [0:0]                input_valid,    
    output wire [63:0]              WData,
    output wire [PAR_SIZE_W-1:0]    WAddr,    
    output wire [0:0]               Wvalid,
    output wire [0:0]               par_active  
);

    reg [0:0] valid_reg [PIPE_DEPTH-1:0];
    reg [31:0] dest_reg [PIPE_DEPTH-1:0];    
    assign WAddr = dest_reg[PIPE_DEPTH-1][PAR_SIZE_W-1:0];
    assign par_active = 1'b1;
        
    reg	[31:0] dest_attr_reg [PIPE_DEPTH-1:0];    	
    integer i;
    always @(posedge clk) begin
        if (rst) begin
            for(i=0; i<PIPE_DEPTH; i=i+1) begin
                dest_reg[i] <= 0;
				dest_attr_reg [i] <= 0;
            end
        end	else begin
            for(i=1; i<PIPE_DEPTH; i=i+1) begin
               dest_reg[i] <= dest_reg[i-1];
			   dest_attr_reg [i] <= dest_attr_reg [i-1]; 
            end
            dest_reg [0] <=  update_dest;            
			dest_attr_reg [0] <= dest_attr [63:32];
        end
    end    
    
    fp_add adder(              
        .aclk(clk),
        .s_axis_a_tvalid(input_valid),        
        .s_axis_a_tdata(update_value),
        .s_axis_b_tvalid(input_valid),
        .s_axis_b_tdata(dest_attr[31:0]),
        .m_axis_result_tvalid (Wvalid),
        .m_axis_result_tready(1'b1),      
        .m_axis_result_tdata(WData[31:0])              
    );
    assign WData[63:32] = dest_attr_reg [PIPE_DEPTH-1];
	
endmodule


module spmv_scatter_pipe # (
    parameter PIPE_DEPTH = 3,
    parameter URAM_DATA_W = 32
)(
    input wire                      clk,
    input wire                      rst,    
    input wire [31:0]               edge_weight,
    input wire [URAM_DATA_W-1:0]    src_attr,
    input wire [31:0]               edge_dest,
    input wire [0:0]                input_valid,    
    output wire [31:0]              update_value,
    output wire [31:0]              update_dest,    
    output wire [0:0]               output_valid  
);
    reg [31:0] dest_reg [PIPE_DEPTH-1:0];    
    assign update_dest = dest_reg[PIPE_DEPTH-1];
    
    integer i;
    always @(posedge clk) begin
        if (rst) begin
            for(i=0; i<PIPE_DEPTH; i=i+1) begin
                dest_reg[i] <= 0;
            end
        end	else begin
            for(i=1; i<PIPE_DEPTH; i=i+1) begin
               dest_reg[i] <= dest_reg[i-1];
            end
            dest_reg [0] <=  edge_dest;            
        end
    end
    
    fp_mul multiplier(              
        .aclk(clk),
        .s_axis_a_tvalid(input_valid),        
        .s_axis_a_tdata(edge_weight),
        .s_axis_b_tvalid(input_valid),
        .s_axis_b_tdata(src_attr),
        .m_axis_result_tvalid (output_valid),
        .m_axis_result_tready(1'b1),      
        .m_axis_result_tdata(update_value)              
    );
    
endmodule



module pr_combine_unit (
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


module pr_gather_pipe # (
    parameter PIPE_DEPTH = 3,
    parameter PAR_SIZE_W = 18,
    parameter URAM_DATA_W = 64
)(
    input wire                      clk,
    input wire                      rst,        
    input wire [31:0]               update_value,
    input wire [31:0]               update_dest,
    input wire [URAM_DATA_W-1:0]    dest_attr,
    input wire [0:0]                input_valid,    
    output wire [URAM_DATA_W-1:0]   WData,
    output wire [PAR_SIZE_W-1:0]    WAddr,    
    output wire [0:0]               Wvalid,
    output wire [0:0]               par_active  
);

    reg [0:0] valid_reg [PIPE_DEPTH-1:0];
    reg [31:0] dest_reg [PIPE_DEPTH-1:0];    
    assign WAddr = dest_reg[PIPE_DEPTH-1][PAR_SIZE_W-1:0];
    assign par_active = 1'b1;
        
    reg	[31:0] dest_attr_reg [PIPE_DEPTH-1:0];    	
    integer i;
    always @(posedge clk) begin
        if (rst) begin
            for(i=0; i<PIPE_DEPTH; i=i+1) begin
                dest_reg[i] <= 0;
				dest_attr_reg [i] <= 0;
            end
        end	else begin
            for(i=1; i<PIPE_DEPTH; i=i+1) begin
               dest_reg[i] <= dest_reg[i-1];
			   dest_attr_reg [i] <= dest_attr_reg [i-1]; 
            end
            dest_reg [0] <=  update_dest;            
			dest_attr_reg [0] <= dest_attr [63:32];
        end
    end    
    
    fp_add adder(              
        .aclk(clk),
        .s_axis_a_tvalid(input_valid),        
        .s_axis_a_tdata(update_value),
        .s_axis_b_tvalid(input_valid),
        .s_axis_b_tdata(dest_attr[31:0]),
        .m_axis_result_tvalid (Wvalid),
        .m_axis_result_tready(1'b1),      
        .m_axis_result_tdata(WData[31:0])              
    );
    assign WData[63:32] = dest_attr_reg [PIPE_DEPTH-1];
	
endmodule


module pr_scatter_pipe # (
    parameter PIPE_DEPTH = 3,
    parameter URAM_DATA_W = 64
)(
    input wire                      clk,
    input wire                      rst,    
    input wire [31:0]               edge_weight,
    input wire [URAM_DATA_W-1:0]    src_attr,
    input wire [31:0]               edge_dest,
    input wire [0:0]                input_valid,    
    output wire [31:0]              update_value,
    output wire [31:0]              update_dest,    
    output wire [0:0]               output_valid  
);
    reg [31:0] dest_reg [PIPE_DEPTH-1:0];    
    assign update_dest = dest_reg[PIPE_DEPTH-1];
    
    integer i;
    always @(posedge clk) begin
        if (rst) begin
            for(i=0; i<PIPE_DEPTH; i=i+1) begin
                dest_reg[i] <= 0;
            end
        end	else begin
            for(i=1; i<PIPE_DEPTH; i=i+1) begin
               dest_reg[i] <= dest_reg[i-1];
            end
            dest_reg [0] <=  edge_dest;            
        end
    end
    
    fp_mul multiplier(              
        .aclk(clk),
        .s_axis_a_tvalid(input_valid),        
        .s_axis_a_tdata(src_attr[31:0]),
        .s_axis_b_tvalid(input_valid),
        .s_axis_b_tdata(src_attr[63:32]),
        .m_axis_result_tvalid (output_valid),      
        .m_axis_result_tdata(update_value)              
    );
    
endmodule

module sssp_combine_unit (
    input wire clk,
    input wire [31:0] update_A,
    input wire [31:0] update_B,
    output reg [31:0] combined_update
);    
    always @(posedge clk) begin
        combined_update <= (update_A>update_B) ? update_B : update_A;   
    end 
endmodule


module sssp_gather_pipe # (
    parameter PIPE_DEPTH = 1,
    parameter PAR_SIZE_W = 18,
    parameter URAM_DATA_W = 32
)(
    input wire                      clk,
    input wire                      rst,        
    input wire [31:0]               update_value,
    input wire [31:0]               update_dest,
    input wire [URAM_DATA_W-1:0]    dest_attr,
    input wire [0:0]                input_valid,    
    output reg [URAM_DATA_W-1:0]   WData,
    output reg [PAR_SIZE_W-1:0]    WAddr,    
    output reg [0:0]               Wvalid,
    output reg [0:0]               par_active  
);
    always @(posedge clk) begin
        if (rst) begin
            WData <= 0;
            WAddr <= 0;
            Wvalid <= 0;
            par_active <= 0;  
        end  else begin
            WAddr <= update_dest[PAR_SIZE_W-1:0];
            WData[30:0] <= (update_value < dest_attr) ? update_value[30:0] : dest_attr[30:0];            
            WData[31:31] <= input_valid && (update_value < dest_attr[30:0]);
			Wvalid <= input_valid && (update_value < dest_attr[30:0]);
            par_active <= input_valid && (update_value < dest_attr[30:0]);
        end
     end     
	
endmodule


module sssp_scatter_pipe # (
    parameter PIPE_DEPTH = 3,
    parameter URAM_DATA_W = 32
)(
    input wire                      clk,
    input wire                      rst,    
    input wire [15:0]               edge_weight,
    input wire [URAM_DATA_W-1:0]    src_attr,
    input wire [23:0]               edge_dest,
    input wire [0:0]                input_valid,    
    output reg [31:0]              update_value,
    output reg [31:0]              update_dest,    
    output reg [0:0]               output_valid  
);
    always @(posedge clk) begin
        if (rst) begin
            output_valid <= 0;
            update_value <= 0;
            update_dest <= 0;
        end else begin
            output_valid <= input_valid && src_attr[URAM_DATA_W-1:URAM_DATA_W-1];
            update_value <= edge_weight + src_attr[URAM_DATA_W-2:0];
            update_dest <= edge_dest;
        end
    end    
endmodule


module wcc_combine_unit (
    input wire clk,
    input wire [31:0] update_A,
    input wire [31:0] update_B,
    output reg [31:0] combined_update
);    
    always @(posedge clk) begin
        combined_update <= (update_A>update_B) ? update_B : update_A;   
    end 
endmodule


module wcc_gather_pipe # (
    parameter PIPE_DEPTH = 1,
    parameter PAR_SIZE_W = 18,
    parameter URAM_DATA_W = 32
)(
    input wire                      clk,
    input wire                      rst,        
    input wire [31:0]               update_value,
    input wire [31:0]               update_dest,
    input wire [URAM_DATA_W-1:0]    dest_attr,
    input wire [0:0]                input_valid,    
    output reg [URAM_DATA_W-1:0]   WData,
    output reg [PAR_SIZE_W-1:0]    WAddr,    
    output reg [0:0]               Wvalid,
    output reg [0:0]               par_active  
);
    always @(posedge clk) begin
        if (rst) begin
            WData <= 0;
            WAddr <= 0;
            Wvalid <= 0;
            par_active <= 0;  
        end  else begin
            WAddr <= update_dest[PAR_SIZE_W-1:0];
            WData[30:0] <= (update_value < dest_attr) ? update_value[30:0] : dest_attr[30:0];            
            WData[31:31] <= input_valid && (update_value[30:0] < dest_attr[30:0]);
            Wvalid <= input_valid && (update_value[30:0] < dest_attr[30:0]);
            par_active <= input_valid && (update_value[30:0] < dest_attr[30:0]);
        end
     end     
	
endmodule


module wcc_scatter_pipe # (
    parameter PIPE_DEPTH = 3,
    parameter URAM_DATA_W = 32
)(
    input wire                      clk,
    input wire                      rst,    
    input wire [15:0]               edge_weight,
    input wire [URAM_DATA_W-1:0]    src_attr,
    input wire [31:0]               edge_dest,
    input wire [0:0]                input_valid,    
    output reg [31:0]              update_value,
    output reg [31:0]              update_dest,    
    output reg [0:0]               output_valid  
);
    always @(posedge clk) begin
        if (rst) begin
            output_valid <= 0;
            update_value <= 0;
            update_dest <= 0;
        end else begin
            output_valid <= input_valid && src_attr[URAM_DATA_W-1:URAM_DATA_W-1];
            update_value <= src_attr[URAM_DATA_W-2:0];
            update_dest <= edge_dest;
        end
    end    
endmodule

