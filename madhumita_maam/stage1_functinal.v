`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.12.2023 12:33:40
// Design Name: 
// Module Name: stage1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module stage1#(parameter AWIDTH		= 9,	//Address Bus width
parameter DWIDTH		= 32,
parameter DWIDTH_CPU  = 32)(

    input			clock,		//Clock input same as CPU and Memory controller(if MemController work on same freq.)
	input			reset_n,	//Active Low Asynchronous Reset Signal Input

	output reg	[DWIDTH-1:0]	data_cpu,	//Parameterized Bi-directional Data bus from CPU
	input	[AWIDTH-1:0]	addr_cpu,	//Parameterized Address bus from CPU
	output reg       [DWIDTH-1:0] data_, //Parameterized Bi-directional Data bus to Main Memory

	input			rd_cpu,		//Active High Read signal from CPU
	input			wr_cpu,
	//input ready_mem,	//Active High WRITE signal from CPU
	input [DWIDTH-1:0] data_read_from_mem,
	input [DWIDTH-1:0] data_read_from_cpu,
	input [DWIDTH-1:0] data_write_to_mem,
	input [DWIDTH-1:0] data_write_to_cpu
	

);
logic		rd_mem; //Active High Read signal to Main Memory
logic [3:0]       wr_mem; //Active High Write signal to Main Memory
//logic       [DWIDTH-1:0] data_mem; //Parameterized Bi-directional Data bus to Main Memory
logic     [AWIDTH-1:0]	addr_mem;	//Parameterized Address bus to Main Memory
logic     ready_mem;    //Active High Ready signal from Main memory, to know the status of memory
logic     [DWIDTH-1:0] data_in;
//logic    [DWIDTH-1:0] data_out;
logic [2:0] select_addr=3'b000;
logic [AWIDTH-1:0] cache_address;
logic [AWIDTH-1:0] memory_address;
logic cache_rd_mem = 'b0;;
logic read_mem = 'b0;
logic [3:0]cache_wr_mem = 'b0;
logic write_mem = 'b0;
logic [DWIDTH-1:0] write_mem_byte;
logic [DWIDTH_CPU-1:0] write_mem_data;

//login write_mem_byte;
 
 //assign read_mem = (cache_rd_mem)?1'd0:1'd1;
//logic [AWIDTH-1:0] memory_address;

 //memory_address


// <= addr_mem;
cache_2wsa cache(
. clock(clock),
.reset_n(reset_n),
.data_out(data_cpu),
.data_in(data_in),
.data_mem(data_mem),
//.wmem_byte(write_mem_data),
.addr_cpu(addr_cpu),
.addr_mem(cache_address),
.rd_cpu(rd_cpu),
.wr_cpu(wr_cpu),
.rd_mem(cache_rd_mem),
.wr_mem(cache_wr_mem),
.ready_mem(ready_mem)
//.stall_cpu()
    );
    
main_memory memory(
.clk(clock),
.reset_n(reset_n),
.rd_mem(read_mem),
.wr_mem(select_addr),
.data_in(write_mem_data),
.addr_mem(cache_address),
.ready_mem(ready_mem),
.data_out(data_read_from_mem)
);

always@(posedge clock)
   begin
    //if(rd_mem|wr_mem)
    if(cache_rd_mem)
      read_mem <= 1'd1;
     if(|cache_wr_mem)
      write_mem <= 1'd1;
      
   
    end
    
   
   


/*always@ (posedge clock or negedge reset_n) begin
if (wr_mem)
   data_in<=data_mem;
else if(rd_mem)   
   data_mem <= data_out;   
else
   data_in<= 'b0;
end



    
 always_comb begin
   data_in = wr_mem? data_mem : 'b0;  
   data_mem = rd_mem? data_out : 'b0;
 end 
*/    
endmodule
