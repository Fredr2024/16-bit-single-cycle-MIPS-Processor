/********************************************************************* 
*** EE 526 L 16-bit syngle cycle MIPS Fred Ryan,  Spring,2023      ***
***                                                                *** 
***                                                                *** 
***                                                                *** 
********************************************************************** 
*** Filename//  alu.v Created by Fred Ryan, 12 May 2023            *** 
*** --- revision history, if any, goes here ---                    *** 
**********************************************************************/ 
`timescale 1 ns / 1 ps

module alu(       
      input          [15:0]     a,                // Input signal a
      input          [15:0]     b,                // Input signal b
      input          [2:0]     alu_ctrl,          // Function select control signal for ALU operation
      output   reg   [15:0]     result,        // Output signal for the ALU result
      output zero                                 // Output signal indicating if the result is zero
   );  
 always @(*)  
 begin   
      case(alu_ctrl)                             // Perform different operations based on alu_ctrl value
      3'b000: result = a + b;                     // Add operation
      3'b001: result = a - b;                     // Subtract operation
      3'b010: result = a & b;                     // Bitwise AND operation
      3'b011: result = a | b;                     // Bitwise OR operation
      3'b100: begin if (a<b) result = 16'd1;       // Compare operation: if a < b, set result to 1; otherwise, set result to 0
                     else result = 16'd0;  
                     end  
      default:result = a + b;                     // Default operation is addition
      endcase  
 end  
 assign zero = (result==16'd0) ? 1'b1: 1'b0;       // Assign zero output based on the result value
 endmodule