 /********************************************************************* 
*** EE 526 L 16-bit syngle cycle MIPS Fred Ryan,  Spring,2023       ***
***                                                                 *** 
***                                                                 *** 
***                                                                 *** 
********************************************************************** 
*** Filename//  register_file.v Created by Fred Ryan, 12 May 2023   *** 
*** --- revision history, if any, goes here ---                     *** 
**********************************************************************/ 
`timescale 1 ns / 1 ps

module register_file (
    input clk,
    input rst,
    // write port
    input reg_write,
    input [2:0] write_dest,
    input [15:0] write_data,
    // read port 1
    input [2:0] read_addr_1,
    output [15:0] read_data_1,
    // read port 2
    input [2:0] read_addr_2,
    output [15:0] read_data_2,
    output wire [15:0] reg1, reg2, reg3
);

reg [15:0] reg_file[7:0];  // Declaration of a register array named "reg_file" with 8 elements, each of 16 bits.

integer i;  // Declaration of an integer variable "i".

always @(posedge clk or posedge rst) begin
    if (rst) begin
        for (i = 0; i < 8; i = i + 1)
            reg_file[i] <= 16'd0;  // Resetting all elements of "reg_file" to 16'd0 when "rst" is asserted.
    end
    else begin
        if (reg_write) begin
            reg_file[write_dest] <= write_data;  // Writing "write_data" to the specified destination address in "reg_file" when "reg_write" is asserted.
        end
    end
end

assign read_data_1 = reg_file[read_addr_1];  // Assigning the value from "reg_file" at "read_addr_1" to "read_data_1".
assign read_data_2 = reg_file[read_addr_2];  // Assigning the value from "reg_file" at "read_addr_2" to "read_data_2".
assign reg1 = reg_file[1];  // Assigning the value from "reg_file" at address 1 to "reg1".
assign reg2 = reg_file[2];  // Assigning the value from "reg_file" at address 2 to "reg2".
assign reg3 = reg_file[3];  // Assigning the value from "reg_file" at address 3 to "reg3".

endmodule