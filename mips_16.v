 /********************************************************************* 
*** EE 526 L 16-bit syngle cycle MIPS Fred Ryan,  Spring,2023       ***
***                                                                 *** 
***                                                                 *** 
***                                                                 *** 
********************************************************************** 
*** Filename//  mips_16.v Created by Fred Ryan, 12 May 2023         *** 
*** --- revision history, if any, goes here ---                     *** 
**********************************************************************/ 
`timescale 1 ns / 1 ps  // Sets the timescale for the module

module mips_16( input clk,reset, output[15:0] pc_out,instruction, alu_result,reg1,reg2,reg3 );  // Defines a module named "mips_16" with input and output ports

wire [15:0] instr;  // Declares a 16-bit wire "instr"
wire[1:0] alu_op;  // Declares a 2-bit wire "alu_op"
wire [2:0] write_dest;  // Declares a 3-bit wire "write_dest"
wire [15:0] write_data;  // Declares a 16-bit wire "write_data"
wire [2:0] read_addr_1;  // Declares a 3-bit wire "read_addr_1"
wire [15:0] read_data_1;  // Declares a 16-bit wire "read_data_1"
wire [2:0] read_addr_2;  // Declares a 3-bit wire "read_addr_2"
wire [15:0] read_data_2;  // Declares a 16-bit wire "read_data_2"
wire jump,beq,mem_read,mem_write,alu_src,reg_dst,mem_to_reg,reg_write,bne;  // Declares several wires for control signals
wire [15:0] read_data2,imm_ext;  // Declares several 16-bit wires
wire [2:0] ALU_Control;  // Declares a 3-bit wire "ALU_Control"
wire [15:0] ALU_out;  // Declares a 16-bit wire "ALU_out"
wire zero_flag;  // Declares a wire "zero_flag"
reg[15:0] pc_current;  // Declares a 16-bit register "pc_current"
wire signed[15:0] pc_next,pc_2;  // Declares two 16-bit wires "pc_next" and "pc_2"
wire signed[15:0] im_shift_1, PC_j, PC_beq, PC_4beq,PC_bne,PC_4bne;  // Declares several 16-bit wires
wire beq_control,bne_control;  // Declares wires for control signals
wire [14:0] jump_shift_1;  // Declares a 15-bit wire "jump_shift_1"
wire [15:0] mem_read_data;  // Declares a 16-bit wire "mem_read_data"


// PC
always @(posedge clk or posedge reset)  // Executes the following block on the positive edge of the clock or the positive edge of the reset signal
begin
    if(reset)  // If the reset signal is active
        pc_current <= 16'd0;  // Assigns 0 to the register "pc_current"
    else
        pc_current <= pc_next;  // Assigns the value of "pc_next" to the register "pc_current"
end

// PC + 2
assign pc_2 = pc_current + 16'd2;  // Adds 2 to "pc_current" and assigns the result to "pc_2"
 // instruction memory  
// instruction memory
instr_mem instrucion_memory(.pc(pc_current),.instruction(instr));

// jump shift left 1
assign jump_shift_1 = {instr[12:0],1'b0};

// control unit
control_unit control(.reset(reset),.opcode(instr[15:13]),.reg_dst(reg_dst),
                .mem_to_reg(mem_to_reg),.alu_op(alu_op),.jump(jump),.beq(beq),.mem_read(mem_read),
                .mem_write(mem_write),.alu_src(alu_src),.reg_write(reg_write),.bne(bne));

// multiplexer regdest
assign write_dest = (reg_dst==1'b1) ? instr[6:4] : instr[9:7];

// register file
assign read_addr_1 = instr[12:10];
assign read_addr_2 = instr[9:7];
register_file reg_file(.clk(clk),.rst(reset),.reg_write(reg_write),
.write_dest(write_dest),
.write_data(write_data),
.read_addr_1(read_addr_1),
.read_data_1(read_data_1),
.read_addr_2(read_addr_2),
.read_data_2(read_data_2),
.reg1(reg1),
.reg2(reg2),
.reg3(reg3));

// sign extend
assign imm_ext = {{9{instr[6]}},instr[6:0]}; //9{instr[6]}: This expression creates a 9-bit signal where all the bits are the same as the 6th bit of the instr signal



// ALU control unit
ALUControl ALU_Control_unit(.ALUOp(alu_op),.Function(instr[3:0]),.ALU_Control(ALU_Control));

// multiplexer alu_src
assign read_data2 = (alu_src==1'b1) ? imm_ext : read_data_2;

// ALU
alu alu_unit(.a(read_data_1),.b(read_data2),.alu_ctrl(ALU_Control),.result(ALU_out),.zero(zero_flag));

// immediate shift 1
assign im_shift_1 = {imm_ext[14:0],1'b0};

// PC beq&bne add
assign PC_beq = pc_2 + im_shift_1 ;
assign PC_bne = pc_2 + im_shift_1 ;

// beq control
assign beq_control = beq & zero_flag;
assign bne_control = bne & (~zero_flag);

// PC_beq
assign PC_4beq = (beq_control==1'b1) ? PC_beq : pc_2;

// PC_bne
assign PC_4bne = (bne_control==1'b1) ? PC_bne : PC_4beq;

// PC_j
assign PC_j = {pc_2[15],jump_shift_1};

// PC_next
assign pc_next = (jump == 1'b1) ? PC_j : PC_4beq;

// data memory
data_memory datamem(.clk(clk),.mem_addr(ALU_out),
.mem_write(read_data_2),.mem_write_en(mem_write),.mem_read(mem_read),
.mem_read_data(mem_read_data));

// write back
assign write_data = (mem_to_reg == 1'b0) ? pc_2:((mem_to_reg == 1'b1)? mem_read_data: ALU_out);

// output
assign pc_out = pc_current;
assign alu_result = ALU_out;
assign instruction = instr;
 endmodule  