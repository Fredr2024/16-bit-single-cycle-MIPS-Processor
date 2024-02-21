 /********************************************************************* 
*** EE 526 L 16-bit syngle cycle MIPS Fred Ryan,  Spring,2023       ***
***                                                                 *** 
***                                                                 *** 
***                                                                 *** 
********************************************************************** 
*** Filename//  alu.v Created by Fred Ryan, 12 May 2023             *** 
*** --- revision history, if any, goes here ---                     *** 
**********************************************************************/ 
`timescale 1 ns / 1 ps    // Set the timescale for simulation

module instr_mem          
(
    input        [15:0]     pc,               // Input signal: program counter
    output wire  [15:0]     instruction       // Output signal: instruction fetched from instruction memory
);

wire [3:0] rom_addr = pc[4:1];                 // Create a new 4-bit signal called rom_addr and assign it the value of the 4 bits of the pc signal from bit 4 down to bit 1

/* 
   lw $1, 4($zero)
   lw $2, 5($zero)  
   beq $1,$2,jump
   sub $3,$1,$2
   sw $3, 7($zero) 
   jump: add $3, $1, $2 
   sw $3, 7($zero)   
*/  

reg [15:0] rom[15:0];                          // Declare a register array called rom to store instructions

initial  
begin 
    $readmemb("./test/rom.txt", rom, 0, 14);    // Read the contents of the "rom.txt" file and initialize the rom array with the instruction values
end

assign instruction = rom[rom_addr[3:0]];        // Assign the instruction output based on the value of the rom_addr signal

endmodule