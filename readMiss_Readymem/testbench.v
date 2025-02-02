`timescale 1ns / 100ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:39:18 11/10/2015
// Design Name:   cache_2wsa
// Module Name:   C:/Users/Dadu/OneDrive/Courses/ECE585_MSD_Teuscher/Homework/Homework4/IP/simX/Cache_2wsa/cache_2wsa_tb.v
// Project Name:  Cache_2wsa
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: cache_2wsa
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module cache_2wsa_tb;

	// Inputs
	reg clock;
	reg reset_n;
	reg [15:0] addr_cpu;
	reg rd_cpu;
	reg wr_cpu;
	reg ready_mem;

	// Outputs
	wire [15:0] addr_mem;
	wire rd_mem;
	wire wr_mem;
	wire stall_cpu;

	// Bidirs
	wire [7:0] data_cpu;
	wire [7:0] data_mem;
	
	reg [7:0] dcpu;
	reg [7:0] wcpu;
	reg [7:0] dmem;
	reg [7:0] wmem;
	
	// Instantiate the Unit Under Test (UUT)
	cache_2wsa uut (
		.clock(clock), 
		.reset_n(reset_n), 
		.data_cpu(data_cpu), 
		.data_mem(data_mem), 
		.addr_cpu(addr_cpu), 
		.addr_mem(addr_mem), 
		.rd_cpu(rd_cpu), 
		.wr_cpu(wr_cpu), 
		.rd_mem(rd_mem), 
		.wr_mem(wr_mem), 
		.stall_cpu(stall_cpu), 
		.ready_mem(ready_mem)
	);

	assign data_cpu = wr_cpu? wcpu : 8'dZ;
	assign data_mem = !wr_mem? dmem : 8'dZ;

	initial begin
	clock = 1'd0;
	forever
	#10 clock = ~clock;
	end
	
	task delay;
	begin
	@(negedge clock);
	end
	endtask		
		
	task initialized_input;
    begin
    reset_n = 0;
	addr_cpu = 0;
	rd_cpu = 0;
	wr_cpu = 0;
	ready_mem = 1;
	wcpu = 0;
        end
        endtask

        task read_from_location;
        begin
        rd_cpu = 1'd1;
	addr_cpu = 16'b0000_0000_1001_0011;
	dcpu = data_cpu;
	delay;
	rd_cpu = 1'd1;
	dcpu = data_cpu;
	delay;
	delay;
	rd_cpu = 1'd1;
	dcpu = data_cpu;
	delay;
	rd_cpu = 1'd0;
        end
        endtask 

       task write_in_location;
       begin
        wr_cpu = 1'd1;
	wcpu = 8'h23;
	addr_cpu = 16'b0000_0000_1001_0011;
       end
       endtask 

       task check_updated_data;
       begin
       wr_cpu = 1'd0;
       delay;	
       rd_cpu = 1'd1;
       addr_cpu = 16'b0000_0000_1001_0011;
       dcpu = data_cpu;
       delay;
       rd_cpu = 1'd1;
       dcpu = data_cpu;
       delay;
       rd_cpu = 1'd0;
       end
       endtask

       task read_from_main_memory;
       begin
        rd_cpu = 1'd1;
	addr_cpu = 16'b1100_0000_1000_1011;
	dcpu = data_cpu;
	delay;
	rd_cpu = 1'd1;
	dcpu = data_cpu;
	@(posedge rd_mem);
	ready_mem = 0;
	delay;
	ready_mem = 0;
	dmem = 8'h11;
        delay;
	dmem = 8'h22;
	delay;
	dmem=8'h33;
	delay;
	dmem=8'h44;
	delay;
	rd_cpu = 1'd0;
       end
       endtask
      
       task waitfor_main_memory_to_read;
       begin
       //rd_cpu = 1'd0;
        ready_mem = 1;
       delay;
       end
       endtask 
       
       task read_from_location1;
       begin
       ready_mem=1'd1;
        rd_cpu = 1'd1;
	addr_cpu = 16'b1100_0000_1000_1000;
	dcpu = data_cpu;
	delay;
	rd_cpu = 1'd1;
	dcpu = data_cpu;
	delay;
	delay;
	rd_cpu = 1'd1;
	dcpu = data_cpu;
	delay;
	rd_cpu = 1'd0;
        end
        endtask 
       
       
       
        initial begin
        initialized_input;
        repeat(4)
        delay;
        reset_n=1;
        delay;
        delay;
        read_from_location;
        delay;
        delay;
        write_in_location;
        delay;
        delay;
        check_updated_data;
        delay;
        delay;
        delay;
        read_from_main_memory;
        delay;
        waitfor_main_memory_to_read;
        delay;
        read_from_location1;
        delay;
        
     /*   delay;
		rd_cpu = 1'd1;
		addr_cpu = 16'b1100_1000_1001_1011;//1100_0000_1000_1011
		dcpu = data_cpu;
		delay;
		rd_cpu = 1'd1;
		dcpu = data_cpu;
		@(posedge rd_mem);
		ready_mem = 0;
		repeat(4)
		delay;
		
		ready_mem = 1;
		
		delay;
		
		dmem = 8'h22;
		
		delay;
		
		dmem = 8'h11;
		
		delay;
		
		dmem = 8'h22;
		
		delay;
		
		dmem = 8'h11;
		
		delay;
		
		delay;
		
		delay;
		
		delay;
		
		rd_cpu = 1'd0;*/
		
		// Wait 100 ns for global reset to finish
		#400 $finish;
        
		// Add stimulus here

	end
      
endmodule

