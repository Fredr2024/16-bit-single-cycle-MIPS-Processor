 /********************************************************************* 
*** EE 526 L 16-bit syngle cycle MIPS Fred Ryan,  Spring,2023       ***
***                                                                 *** 
***                                                                 *** 
***                                                                 *** 
********************************************************************** 
*** Filename//  data_memory.v Created by Fred Ryan, 12 May 2023     *** 
*** --- revision history, if any, goes here ---                     *** 
**********************************************************************/ 
`timescale 1 ns / 1 ps

module data_memory 
    input clk,
    input [15:0] mem_addr,
    input [15:0] mem_write,
    input mem_write_en,
    input mem_read,
    // read port
    output [15:0] mem_read_data,
    output wire [15:0] mem
);

reg [15:0] ram[15:0];  // Declaration of a register array named "ram" with 16 elements, each of 16 bits.
integer i;  // Declaration of an integer variable "i".

wire [7:0] ram_addr = mem_addr[7:0];  // Declaration of a wire "ram_addr" which takes the lower 8 bits of "mem_addr".

initial begin
    $readmemb("./test/ram.txt", ram, 0, 15);  // Reads the contents of a memory initialization file into the "ram" array.
    for (i = 0; i < 16; i = i + 1)
        $display("ram%0d = %0d", i, ram[i]);  // Displays the values of the "ram" array elements.
end

always @(posedge clk) begin
    if (mem_write_en)
        ram[ram_addr] <= mem_write;  // Updates the value in "ram" at the specified address when mem_write_en is asserted.
end

assign mem_read_data = (mem_read == 1'b1) ? ram[ram_addr] : 16'd0;  // Assigns the value from "ram" at the specified address to mem_read_data if mem_read is asserted, else assigns 16'd0.
assign mem = ram[7];  // Assigns the value from "ram" at address 7 to the "mem" wire.

initial begin
    #250;
    $display("\nram7 = %d \n", mem);  // Displays the value in "ram" at address 7.
end

endmodule