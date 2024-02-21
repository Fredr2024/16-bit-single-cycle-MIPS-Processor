 /********************************************************************* 
*** EE 526 L 16-bit syngle cycle MIPS Fred Ryan,  Spring,2023       ***
***                                                                 *** 
***                                                                 *** 
***                                                                 *** 
********************************************************************** 
*** Filename//  tb_mips_16.v Created by Fred Ryan, 12 May 2023      *** 
*** --- revision history, if any, goes here ---                     *** 
**********************************************************************/ 
// Define the timescale for the simulation
timescale 1 ns / 1 ps

// Declare the testbench module
module tb_mips16;
  
  // Inputs
  reg clk;
  reg reset;
  
  // Outputs
  wire [15:0] pc_out, instr;
  wire [15:0] alu_result, reg1, reg2, reg3;
  
  // Instantiate the Unit Under Test (UUT)
  mips_16 uut(
    .clk(clk),
    .reset(reset),
    .pc_out(pc_out),
    .instruction(instr),
    .alu_result(alu_result),
    .reg1(reg1),
    .reg2(reg2),
    .reg3(reg3)
  );
  
  // Initialize the clock signal
  initial begin
    clk = 0;
    forever #10 clk = ~clk;
  end
  
  // Initialize the testbench
  initial begin
    // Enable VCD waveform dumping
    $vcdpluson;
    
    // Monitor the values of the instruction, register 1, register 2, and register 3
    $monitor("\ninstruction =%h, register 1=%d, register 2=%d, register 3=%d", instr, reg1, reg2, reg3);
    
    // Set the initial value of the reset signal
    reset = 1;
    
    // Wait for 100 ns for the global reset to finish
    #100;
    
    // Deassert the reset signal
    reset = 0;
    
    // Wait for additional 250 ns
    #250;
    
    // Finish the simulation
    $finish;
  end
endmodule