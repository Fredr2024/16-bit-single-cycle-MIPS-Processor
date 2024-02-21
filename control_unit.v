 /********************************************************************* 
*** EE 526 L 16-bit syngle cycle MIPS Fred Ryan,  Spring,2023       ***
***                                                                 *** 
***                                                                 *** 
***                                                                 *** 
********************************************************************** 
*** Filename//  control_unit.v Created by Fred Ryan, 12 May 2023   *** 
*** --- revision history, if any, goes here ---                     *** 
**********************************************************************/ 

`timescale 1 ns / 1 ps
module control_unit( input[2:0] opcode,  
                           input reset,  
                           output reg[1:0] alu_op,  
                           output reg jump,beq,bne,mem_read,mem_write,alu_src,reg_dst,mem_to_reg,reg_write                      
   );  
 always @(*)  
 begin  
      if(reset == 1'b1) begin  
                reg_dst = 1'b0;  
                mem_to_reg = 1'b0;  
                alu_op = 2'b00;  
                jump = 1'b0;  
                beq = 1'b0;  
                mem_read = 1'b0;  
                mem_write = 1'b0;  
                alu_src = 1'b0;  
                reg_write = 1'b0;  
                bne = 1'b0;  
      end  
      else begin  
      case(opcode)   
      3'b000: begin // R type (add,sub,and,or,slt,jr) 
                reg_dst = 1'b1;  
                mem_to_reg = 1'b0;  
                alu_op = 2'b00;  
                jump = 1'b0;  
                beq = 1'b0;  
                mem_read = 1'b0;  
                mem_write = 1'b0;  
                alu_src = 1'b0;  
                reg_write = 1'b1;  
                bne = 1'b0;  
                end  
      3'b001: begin // I type (slti) 
                reg_dst = 1'b0;  
                mem_to_reg = 1'b0;  
                alu_op = 2'b10;  
                jump = 1'b0;  
                beq = 1'b0;  
                mem_read = 1'b0;  
                mem_write = 1'b0;  
                alu_src = 1'b1;  
                reg_write = 1'b1;  
                bne = 1'b0;  
                end  
      3'b010: begin // j type(j) 
                reg_dst = 1'b0;  
                mem_to_reg = 1'b0;  
                alu_op = 2'b00;  
                jump = 1'b1;  
                beq = 1'b0;  
                mem_read = 1'b0;  
                mem_write = 1'b0;  
                alu_src = 1'b0;  
                reg_write = 1'b0;  
                bne = 1'b0;  
                end  
       3'b011: begin// I type (bne)
                reg_dst = 1'b0;
                alu_src = 1'b0;
                mem_to_reg = 1'b0;
                reg_write = 1'b0;
                mem_read = 1'b0;
                mem_write = 1'b0;
                beq = 1'b0;
                bne = 1'b1;
                alu_op = 2'b01;
               jump = 1'b0; 
               end 

      3'b100: begin // I type (lw)
                reg_dst = 1'b0;  
                mem_to_reg = 1'b1;  
                alu_op = 2'b11;  
                jump = 1'b0;  
                beq = 1'b0;  
                mem_read = 1'b1;  
                mem_write = 1'b0;  
                alu_src = 1'b1;  
                reg_write = 1'b1;  
                bne = 1'b0;  
                end  
      3'b101: begin // I type( sw)   
                reg_dst = 1'b0;  
                mem_to_reg = 1'b0;  
                alu_op = 2'b11;  
                jump = 1'b0;  
                beq = 1'b0;  
                mem_read = 1'b0;  
                mem_write = 1'b1;  
                alu_src = 1'b1;  
                reg_write = 1'b0;  
                bne = 1'b0;  
                end  
      3'b110: begin // I type (beq) 
                reg_dst = 1'b0;  
                mem_to_reg = 1'b0;  
                alu_op = 2'b01;  
                jump = 1'b0;  
                beq = 1'b1;  
                mem_read = 1'b0;  
                mem_write = 1'b0;  
                alu_src = 1'b0;  
                reg_write = 1'b0;  
                bne = 1'b0;  
                end  
      3'b111: begin // I type (addi) 
                reg_dst = 1'b0;  
                mem_to_reg = 1'b0;  
                alu_op = 2'b11;  
                jump = 1'b0;  
                beq = 1'b0;  
                mem_read = 1'b0;  
                mem_write = 1'b0;  
                alu_src = 1'b1;  
                reg_write = 1'b1;  
                bne = 1'b0;  
                end  
      default: begin  
                reg_dst = 1'b1;  
                mem_to_reg = 1'b0;  
                alu_op = 2'b00;  
                jump = 1'b0;  
                beq = 1'b0;  
                mem_read = 1'b0;  
                mem_write = 1'b0;  
                alu_src = 1'b0;  
                reg_write = 1'b1;  
                bne = 1'b0;  
                end  
      endcase  
      end  
 end  
 endmodule
 
 module ALUControl( ALU_Control, ALUOp, Function);  
 output reg[2:0] ALU_Control;  
 input [1:0] ALUOp;  
 input [3:0] Function;  
 wire [5:0] ALUControlIn;  
 assign ALUControlIn = {ALUOp,Function};  
 always @(ALUControlIn)  
 casex (ALUControlIn)  
  6'b11xxxx: ALU_Control=3'b000; // Addi,lw,sw
  6'b10xxxx: ALU_Control=3'b100;  //i-type: slti if (a<b) result = 16'd1;
  6'b01xxxx: ALU_Control=3'b001;  // sub 
  6'b000000: ALU_Control=3'b000;  // R-type: ADD
  6'b000001: ALU_Control=3'b001;  // R-type: sub
  6'b000010: ALU_Control=3'b010;  // R-type: AND
  6'b000011: ALU_Control=3'b011;  // R-type: OR
  6'b000100: ALU_Control=3'b100;  //R-type: slt if (a<b) result = 16'd1;
  default: ALU_Control=3'b000;  
  endcase  
 endmodule 