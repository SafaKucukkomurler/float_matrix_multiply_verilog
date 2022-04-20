`timescale 1ns / 1ns

module multply #(parameter M = 6, N = 6, L = 6)
    (
        input clk,
        input start_i,
		output reg done_tick_o,
        input [31:0] operands0,
		input [31:0] operands1,
		input [31:0] operands2,
		input [31:0] operands3,
		input [31:0] operands4,
		input [31:0] operands5,
		input [31:0] operands6,
		input [31:0] operands7,
		input [31:0] operands8,
		input [31:0] operands9,
		input [31:0] operands10,
		input [31:0] operands11,
		input [31:0] operands12,
		input [31:0] operands13,
		input [31:0] operands14,
		input [31:0] operands15,
		input [31:0] operands16,
		input [31:0] operands17,
		input [31:0] operands18,
		input [31:0] operands19,
		input [31:0] operands20,
		input [31:0] operands21,
		input [31:0] operands22,
		input [31:0] operands23,
		input [31:0] operands24,
		input [31:0] operands25,
		input [31:0] operands26,
		input [31:0] operands27,
		input [31:0] operands28,
		input [31:0] operands29,
		input [31:0] operands30,
		input [31:0] operands31,
		input [31:0] operands32,
		input [31:0] operands33,
		input [31:0] operands34,
		input [31:0] operands35,
		input [31:0] operands36,
		input [31:0] operands37,
		input [31:0] operands38,
		input [31:0] operands39,
		input [31:0] operands40,
		input [31:0] operands41,
		input [31:0] operands42,
		input [31:0] operands43,
		input [31:0] operands44,
		input [31:0] operands45,
		input [31:0] operands46,
		input [31:0] operands47,
		input [31:0] operands48,
		input [31:0] operands49,
		input [31:0] operands50,
		input [31:0] operands51,
		input [31:0] operands52,
		input [31:0] operands53,
		input [31:0] operands54,
		input [31:0] operands55,
		input [31:0] operands56,
		input [31:0] operands57,
		input [31:0] operands58,
		input [31:0] operands59,
		input [31:0] operands60,
		input [31:0] operands61,
		input [31:0] operands62,
		input [31:0] operands63,
		input [31:0] operands64,
		input [31:0] operands65,
		input [31:0] operands66,
		input [31:0] operands67,
		input [31:0] operands68,
		input [31:0] operands69,
		input [31:0] operands70,
		input [31:0] operands71,        
        output [31:0] result0,
		output [31:0] result1,
		output [31:0] result2,
		output [31:0] result3,
		output [31:0] result4,
		output [31:0] result5,
		output [31:0] result6,
		output [31:0] result7,
		output [31:0] result8,
		output [31:0] result9,
		output [31:0] result10,
		output [31:0] result11,
		output [31:0] result12,
		output [31:0] result13,
		output [31:0] result14,
		output [31:0] result15,
		output [31:0] result16,
		output [31:0] result17,
		output [31:0] result18,
		output [31:0] result19,
		output [31:0] result20,
		output [31:0] result21,
		output [31:0] result22,
		output [31:0] result23,
		output [31:0] result24,
		output [31:0] result25,
		output [31:0] result26,
		output [31:0] result27,
		output [31:0] result28,
		output [31:0] result29,
		output [31:0] result30,
		output [31:0] result31,
		output [31:0] result32,
		output [31:0] result33,
		output [31:0] result34,
		output [31:0] result35 
    );
	
    wire [31:0] final_result_temp [0:35];
	wire [31:0] operands [0:71];
	
    wire temp_mul_Valid             [0:M-1][0:N-1][0:L-1];
    reg  a_valid                    [0:M-1][0:N-1][0:L-1];
    reg  b_valid                    [0:M-1][0:N-1][0:L-1];
    wire a_tready                   [0:M-1][0:N-1][0:L-1];
    wire b_tready                   [0:M-1][0:N-1][0:L-1];
    reg  result_tready              [0:M-1][0:N-1][0:L-1];
    wire [31:0] temp_result         [0:M-1][0:N-1][0:L-1];

    wire accum_a_tready             [0:M-1][0:N-1][0:L-1];
    wire accum_b_tready             [0:M-1][0:N-1][0:L-1];
    reg  accum_result_tready        [0:M-1][0:N-1][0:L-1];
    wire [31:0] accum_result_tdata  [0:M-1][0:N-1][0:L-1];
    wire accum_result_tvalid        [0:M-1][0:N-1][0:L-1];

    wire accum2_a_tready            [0:M-1][0:N-1];
    wire accum2_b_tready            [0:M-1][0:N-1];
    reg  accum2_result_tready       [0:M-1][0:N-1];
    wire [31:0] accum2_result_tdata [0:M-1][0:N-1];
    wire accum2_result_tvalid       [0:M-1][0:N-1];

    wire accum_out_a_tready         [0:M-1][0:N-1];
    wire accum_out_b_tready         [0:M-1][0:N-1];
    reg accum_out_result_tready     [0:M-1][0:N-1];
    wire accum_out_result_tvalid    [0:M-1][0:N-1];    
    
    genvar i,j,k;
    genvar a;    
    
    localparam s_idle = 3'b000,
               s_busy = 3'b010,
               s_finish = 3'b100;
               
    reg [2:0] state = s_idle;
               
    integer x,y,z;
	
	assign operands[0] = operands0;
	assign operands[1] = operands1;
	assign operands[2] = operands2;
	assign operands[3] = operands3;
	assign operands[4] = operands4;
	assign operands[5] = operands5;
	assign operands[6] = operands6;
	assign operands[7] = operands7;
	assign operands[8] = operands8;
	assign operands[9] = operands9;
	assign operands[10] = operands10;
	assign operands[11] = operands11;
	assign operands[12] = operands12;
	assign operands[13] = operands13;
	assign operands[14] = operands14;
	assign operands[15] = operands15;
	assign operands[16] = operands16;
	assign operands[17] = operands17;
	assign operands[18] = operands18;
	assign operands[19] = operands19;
	assign operands[20] = operands20;
	assign operands[21] = operands21;
	assign operands[22] = operands22;
	assign operands[23] = operands23;
	assign operands[24] = operands24;
	assign operands[25] = operands25;
	assign operands[26] = operands26;
	assign operands[27] = operands27;
	assign operands[28] = operands28;
	assign operands[29] = operands29;
	assign operands[30] = operands30;
	assign operands[31] = operands31;
	assign operands[32] = operands32;
	assign operands[33] = operands33;
	assign operands[34] = operands34;
	assign operands[35] = operands35;
	assign operands[36] = operands36;
	assign operands[37] = operands37;
	assign operands[38] = operands38;
	assign operands[39] = operands39;
	assign operands[40] = operands40;
	assign operands[41] = operands41;
	assign operands[42] = operands42;
	assign operands[43] = operands43;
	assign operands[44] = operands44;
	assign operands[45] = operands45;
	assign operands[46] = operands46;
	assign operands[47] = operands47;
	assign operands[48] = operands48;
	assign operands[49] = operands49;
	assign operands[50] = operands50;
	assign operands[51] = operands51;
	assign operands[52] = operands52;
	assign operands[53] = operands53;
	assign operands[54] = operands54;
	assign operands[55] = operands55;
	assign operands[56] = operands56;
	assign operands[57] = operands57;
	assign operands[58] = operands58;
	assign operands[59] = operands59;
	assign operands[60] = operands60;
	assign operands[61] = operands61;
	assign operands[62] = operands62;
	assign operands[63] = operands63;
	assign operands[64] = operands64;
	assign operands[65] = operands65;
	assign operands[66] = operands66;
	assign operands[67] = operands67;
	assign operands[68] = operands68;
	assign operands[69] = operands69;
	assign operands[70] = operands70;
	assign operands[71] = operands71;

	assign result0 = final_result_temp[0];
	assign result1 = final_result_temp[1];
	assign result2 = final_result_temp[2];
	assign result3 = final_result_temp[3];
	assign result4 = final_result_temp[4];
	assign result5 = final_result_temp[5];
	assign result6 = final_result_temp[6];
	assign result7 = final_result_temp[7];
	assign result8 = final_result_temp[8];
	assign result9 = final_result_temp[9];
	assign result10 = final_result_temp[10];
	assign result11 = final_result_temp[11];
	assign result12 = final_result_temp[12];
	assign result13 = final_result_temp[13];
	assign result14 = final_result_temp[14];
	assign result15 = final_result_temp[15];
	assign result16 = final_result_temp[16];
	assign result17 = final_result_temp[17];
	assign result18 = final_result_temp[18];
	assign result19 = final_result_temp[19];
	assign result20 = final_result_temp[20];
	assign result21 = final_result_temp[21];
	assign result22 = final_result_temp[22];
	assign result23 = final_result_temp[23];
	assign result24 = final_result_temp[24];
	assign result25 = final_result_temp[25];
	assign result26 = final_result_temp[26];
	assign result27 = final_result_temp[27];
	assign result28 = final_result_temp[28];
	assign result29 = final_result_temp[29];
	assign result30 = final_result_temp[30];
	assign result31 = final_result_temp[31];
	assign result32 = final_result_temp[32];
	assign result33 = final_result_temp[33];
	assign result34 = final_result_temp[34];
	assign result35 = final_result_temp[35];
	
	initial begin
		for (x = 0; x < M; x = x + 1) begin
			for (y = 0; y < N; y = y + 1) begin
				for (z = 0; z < L; z = z + 1) begin
					a_valid[x][y][z] = 1'b0;
					b_valid[x][y][z] = 1'b0;
				end      
			end
		end        
        for (x = 0; x < M; x = x + 1) begin
            for (y = 0; y < N; y = y + 1) begin
                for (z = 0; z < L; z = z + 1) begin
                    result_tready[x][y][z] <= 1'b0;
                    accum_result_tready[x][y][z]  <= 1'b0;
                end      
            end
        end
        for (x = 0; x < M; x = x + 1) begin
            for (y = 0; y < N; y = y + 1) begin
                for (z = 0; z < L; z = z + 1) begin
                    accum2_result_tready[x][y] <= 1'b0;
                    accum_out_result_tready[x][y]  <= 1'b0;
                end      
            end
        end		
	end
    
    always@ (posedge clk) begin       
        
        case (state)
            s_idle: begin
                done_tick_o <= 1'b0;
                if (start_i) begin
                    state <= s_busy;
                                  
                    for (x = 0; x < M; x = x + 1) begin
                        for (y = 0; y < N; y = y + 1) begin
                            for (z = 0; z < L; z = z + 1) begin
                                a_valid[x][y][z] <= 1'b1;
                                b_valid[x][y][z] <= 1'b1;
                            end      
                        end
                    end

                end                   
            end
            
            s_busy:begin
                if (accum_out_result_tvalid[0][0] == 1'b0) begin
                    state <= s_busy;                                        
                end
                else if (accum_out_result_tvalid[0][0] == 1'b1) begin                    
                    state <= s_finish;
                    done_tick_o <= 1'b1;
                    for (x = 0; x < M; x = x + 1) begin
                        for (y = 0; y < N; y = y + 1) begin
                            for (z = 0; z < L; z = z + 1) begin
                                a_valid[x][y][z] <= 1'b0;
                                b_valid[x][y][z] <= 1'b0;
                            end      
                        end
                    end
                end
            end           
            
            s_finish:begin
                done_tick_o <= 1'b0;
                if (accum_out_result_tvalid[0][0] == 1'b1) begin
                    state <= s_finish;
                    for (x = 0; x < M; x = x + 1) begin
                        for (y = 0; y < N; y = y + 1) begin
                            for (z = 0; z < L; z = z + 1) begin
                                result_tready[x][y][z] <= 1'b1;
                                accum_result_tready[x][y][z]  <= 1'b1;
                            end      
                        end
                    end
                    for (x = 0; x < M; x = x + 1) begin
                        for (y = 0; y < N; y = y + 1) begin
                            for (z = 0; z < L; z = z + 1) begin
                                accum2_result_tready[x][y] <= 1'b1;
                                accum_out_result_tready[x][y]  <= 1'b1;
                            end      
                        end
                    end                                         
                end
                else if (accum_out_result_tvalid[0][0] == 1'b0) begin
                    state <= s_idle;
                    for (x = 0; x < M; x = x + 1) begin
                        for (y = 0; y < N; y = y + 1) begin
                            for (z = 0; z < L; z = z + 1) begin
                                result_tready[x][y][z] <= 1'b0;
                                accum_result_tready[x][y][z]  <= 1'b0;
                            end      
                        end
                    end
                    for (x = 0; x < M; x = x + 1) begin
                        for (y = 0; y < N; y = y + 1) begin
                            for (z = 0; z < L; z = z + 1) begin
                                accum2_result_tready[x][y] <= 1'b0;
                                accum_out_result_tready[x][y]  <= 1'b0;
                            end      
                        end
                    end 
                end
            end
        endcase
    end

    generate
        for (i = 0; i < M; i = i + 1) begin
            for (j = 0; j < N; j = j + 1) begin
                for (k = 0; k < L; k = k + 1) begin
                    floating_point_0 mul (
                        .aclk(clk),                                                 // input wire aclk
                        .s_axis_a_tvalid(a_valid[i][j][k]),                         // input wire s_axis_a_tvalid
                        .s_axis_a_tready(a_tready[i][j][k]),                        // output wire s_axis_a_tready
                        .s_axis_a_tdata(operands[k * M + i]),                            // input wire [31 : 0] s_axis_a_tdata
                        .s_axis_b_tvalid(b_valid[i][j][k]),                         // input wire s_axis_b_tvalid
                        .s_axis_b_tready(b_tready[i][j][k]),                        // output wire s_axis_b_tready
                        .s_axis_b_tdata(operands[(j * L + k) + 36]),                     // input wire [31 : 0] s_axis_b_tdata
                        .m_axis_result_tvalid(temp_mul_Valid[i][j][k]),             // output wire m_axis_result_tvalid
                        .m_axis_result_tready(result_tready[i][j][k]),              // input wire m_axis_result_tready
                        .m_axis_result_tdata(temp_result[i][j][k])                  // output wire [31 : 0] m_axis_result_tdata
                    );
                    //res[j * M + i] = A[k * M + i] * B[j * L + k] + res[j * M + i];  //Column-major order matrix multiplication
                end
                
                for (a = 0; a < L; a = a + 2) begin
                    floating_point_1 accumulate (
                        .aclk(clk),                                                  // input wire aclk
                        .s_axis_a_tvalid(temp_mul_Valid[i][j][a]),                   // input wire s_axis_a_tvalid
                        .s_axis_a_tready(accum_a_tready[i][j][a]),                   // output wire s_axis_a_tready
                        .s_axis_a_tdata(temp_result[i][j][a]),                       // input wire [31 : 0] s_axis_a_tdata
                        .s_axis_b_tvalid(temp_mul_Valid[i][j][a+1]),                 // input wire s_axis_b_tvalid
                        .s_axis_b_tready(accum_b_tready[i][j][a]),                   // output wire s_axis_b_tready
                        .s_axis_b_tdata(temp_result[i][j][a+1]),                     // input wire [31 : 0] s_axis_b_tdata
                        .m_axis_result_tvalid(accum_result_tvalid[i][j][a]),         // output wire m_axis_result_tvalid
                        .m_axis_result_tready(accum_result_tready[i][j][a]),         // input wire m_axis_result_tready
                        .m_axis_result_tdata(accum_result_tdata[i][j][a])            // output wire [31 : 0] m_axis_result_tdata
                    );
                end

                floating_point_1 accumulate_stage2 (
                    .aclk(clk),                                                  // input wire aclk
                    .s_axis_a_tvalid(accum_result_tvalid[i][j][0]),              // input wire s_axis_a_tvalid
                    .s_axis_a_tready(accum2_a_tready[i][j]),                     // output wire s_axis_a_tready
                    .s_axis_a_tdata(accum_result_tdata[i][j][0]),                // input wire [31 : 0] s_axis_a_tdata
                    .s_axis_b_tvalid(accum_result_tvalid[i][j][2]),              // input wire s_axis_b_tvalid
                    .s_axis_b_tready(accum2_b_tready[i][j]),                     // output wire s_axis_b_tready
                    .s_axis_b_tdata(accum_result_tdata[i][j][2]),                // input wire [31 : 0] s_axis_b_tdata
                    .m_axis_result_tvalid(accum2_result_tvalid[i][j]),           // output wire m_axis_result_tvalid
                    .m_axis_result_tready(accum2_result_tready[i][j]),           // input wire m_axis_result_tready
                    .m_axis_result_tdata(accum2_result_tdata[i][j])              // output wire [31 : 0] m_axis_result_tdata
                );

                floating_point_1 accumulate_out (
                    .aclk(clk),                                                  // input wire aclk
                    .s_axis_a_tvalid(accum_result_tvalid[i][j][4]),              // input wire s_axis_a_tvalid
                    .s_axis_a_tready(accum_out_a_tready[i][j]),                  // output wire s_axis_a_tready
                    .s_axis_a_tdata(accum_result_tdata[i][j][4]),                // input wire [31 : 0] s_axis_a_tdata
                    .s_axis_b_tvalid(accum2_result_tvalid[i][j]),                // input wire s_axis_b_tvalid
                    .s_axis_b_tready(accum_out_b_tready[i][j]),                  // output wire s_axis_b_tready
                    .s_axis_b_tdata(accum2_result_tdata[i][j]),                  // input wire [31 : 0] s_axis_b_tdata
                    .m_axis_result_tvalid(accum_out_result_tvalid[i][j]),        // output wire m_axis_result_tvalid
                    .m_axis_result_tready(accum_out_result_tready[i][j]),        // input wire m_axis_result_tready
                    .m_axis_result_tdata(final_result_temp[j * M + i])               // output wire [31 : 0] m_axis_result_tdata
                );
            end
        end
    endgenerate

endmodule

