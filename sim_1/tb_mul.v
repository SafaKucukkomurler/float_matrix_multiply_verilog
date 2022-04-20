`timescale 1ns / 1ns

module tb_mul(

    );
	
	// Parameters of Axi Slave Bus Interface S00_AXI
	localparam integer C_S00_AXI_DATA_WIDTH	= 32;
	localparam integer C_S00_AXI_ADDR_WIDTH	= 9;
	
	// Ports of Axi Slave Bus Interface S00_AXI
	reg  s00_axi_aclk                                     ;
	reg  s00_axi_aresetn                                  ;
	reg [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr       ;
	reg [2 : 0] s00_axi_awprot                            ;
	reg  s00_axi_awvalid                                  ;
	wire  s00_axi_awready                          		  ;
	reg [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata        ;
	reg [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb    ;
	reg  s00_axi_wvalid                                   ;
	wire  s00_axi_wready                                  ;
	wire [1 : 0] s00_axi_bresp                            ;
	wire  s00_axi_bvalid                                  ;
	reg  s00_axi_bready                                   ;
	reg [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr       ;
	reg [2 : 0] s00_axi_arprot                            ;
	reg  s00_axi_arvalid                                  ;
	wire  s00_axi_arready                                 ;
	wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata       ;
	wire [1 : 0] s00_axi_rresp                            ;
	wire  s00_axi_rvalid                                  ;
	reg  s00_axi_rready                                   ;
	//Interrupt signal for after finished matrix multiplication.
	wire INTERRUPT                                        ;
	
	always begin #5 s00_axi_aclk = ~s00_axi_aclk; end
	
	reg [31:0] rom [0:107];    
    
    initial begin
        $readmemh("A_matrix_single_hex.mem", rom, 0, 35);
        $readmemh("B_matrix_single_hex.mem", rom, 36, 71);
    end

	integer i;
	
	initial begin
		s00_axi_awprot = 3'b000;
		s00_axi_araddr = 9'b0;
		s00_axi_arprot = 3'b000;
		s00_axi_arvalid = 1'b0;
		s00_axi_rready = 1'b0;		
	
		s00_axi_wstrb = 4'b1111;
		s00_axi_aresetn = 1'b1;
		s00_axi_aclk = 1'b0;
		
		#15		
		s00_axi_aresetn = 1'b0;
		#20
		s00_axi_aresetn = 1'b1;
		
		#20		
		s00_axi_bready = 1'b1;
		
		for (i = 0; i < 72; i = i + 1) begin
			s00_axi_awaddr = i*4;
			s00_axi_wdata = rom[i];
			s00_axi_awvalid = 1'b1;
			s00_axi_wvalid = 1'b1;
			wait(s00_axi_bvalid==1'b1);
			wait(s00_axi_bvalid==1'b0);
		end

		s00_axi_wdata = 32'hBA;
		s00_axi_awaddr = 9'h1B0;
		s00_axi_awvalid = 1'b1;
		s00_axi_wvalid = 1'b1;
		wait(s00_axi_bvalid==1'b1);
		wait(s00_axi_bvalid==1'b0);
		wait(INTERRUPT==1'b1);
		s00_axi_awvalid = 1'b0;
		s00_axi_wvalid = 1'b0;
		
		#20
		s00_axi_wdata = 32'h00000000;
		s00_axi_awaddr = 9'h1B0;
		s00_axi_awvalid = 1'b1;
		s00_axi_wvalid = 1'b1;
		wait(s00_axi_bvalid==1'b1);
		wait(s00_axi_bvalid==1'b0);
		s00_axi_awvalid = 1'b0;
		s00_axi_wvalid = 1'b0;
		#20
		
        for (i = 72; i < 108; i = i + 1) begin
            s00_axi_rready = 1'b1;
            s00_axi_arvalid = 1'b1;
            s00_axi_araddr = i*4;
			@(negedge s00_axi_arready);
            s00_axi_arvalid = 1'b0;
			@(negedge s00_axi_rvalid);
            s00_axi_rready = 1'b0;
        end		
		
		$stop;
	end
	
	myip_zynq_v1_0_S00_AXI myip_v1_0_S00_AXI_inst (
		.S_AXI_ACLK(s00_axi_aclk),
		.S_AXI_ARESETN(s00_axi_aresetn),
		.S_AXI_AWADDR(s00_axi_awaddr),
		.S_AXI_AWPROT(s00_axi_awprot),
		.S_AXI_AWVALID(s00_axi_awvalid),
		.S_AXI_AWREADY(s00_axi_awready),
		.S_AXI_WDATA(s00_axi_wdata),
		.S_AXI_WSTRB(s00_axi_wstrb),
		.S_AXI_WVALID(s00_axi_wvalid),
		.S_AXI_WREADY(s00_axi_wready),
		.S_AXI_BRESP(s00_axi_bresp),
		.S_AXI_BVALID(s00_axi_bvalid),
		.S_AXI_BREADY(s00_axi_bready),
		.S_AXI_ARADDR(s00_axi_araddr),
		.S_AXI_ARPROT(s00_axi_arprot),
		.S_AXI_ARVALID(s00_axi_arvalid),
		.S_AXI_ARREADY(s00_axi_arready),
		.S_AXI_RDATA(s00_axi_rdata),
		.S_AXI_RRESP(s00_axi_rresp),
		.S_AXI_RVALID(s00_axi_rvalid),
		.S_AXI_RREADY(s00_axi_rready),
		.INTERRUPT(INTERRUPT)
	);
	
endmodule
