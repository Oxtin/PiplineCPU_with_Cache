module CPU
(
    clk_i, 
    rst_i,
    start_i,

    mem_data_i, 
    mem_ack_i,     
    mem_data_o, 
    mem_addr_o,     
    mem_enable_o, 
    mem_write_o
);

input               clk_i;
input               rst_i;
input               start_i;

output    [31:0] mem_addr_o;
input    [255:0]    mem_data_i;
output    mem_enable_o;
output    mem_write_o;
input    mem_ack_i;
output    [255:0]    mem_data_o;

// wries 
// pc
wire    [31:0]  this_pc;
wire    [31:0]  next_pc;
wire    [31:0]  pc_ID;
wire    [31:0]  pc_res;
wire    PCWrite;

// Mem_res
wire    [31:0]  Mem_res_MEM;
wire    [31:0]  Mem_res_WB;

// ALU_res
wire    [31:0]  ALU_res_EX;
wire    [31:0]  ALU_res_MEM;
wire    [31:0]  ALU_res_WB;

// rs
wire    [31:0]  rs_1_ID;
wire    [31:0]  rs_2_ID;
wire    [31:0]  rs_1_EX;
wire    [31:0]  rs_2_EX;
wire    [31:0]  rs_2_MEM;

//rd
wire    [4:0]   rd_EX;
wire    [4:0]   rd_MEM;
wire    [4:0]   rd_WB;

wire    [9:0]   func_EX;

wire    [31:0]  ALU_second_src;

// signals 
wire    [3:0]   ALUCtrl;
wire    [1:0]   ALUOp_ID;
wire    [1:0]   ALUOp_EX;
wire    ALUSrc_ID;
wire    ALUSrc_EX;
wire    RegWrite_ID;
wire    MemtoReg_ID;
wire    MemRead_ID;
wire    MemWrite_ID;
wire    RegWrite_EX;
wire    MemtoReg_EX;
wire    MemRead_EX;
wire    MemWrite_EX;
wire    RegWrite_MEM;
wire    MemtoReg_MEM;
wire    MemRead_MEM;
wire    MemWrite_MEM;
wire    RegWrite_WB;
wire    MemtoReg_WB;

// instruction
wire    [31:0]  instruction;
wire    [31:0]  instruction_IF;
wire    [31:0]  instruction_ID;
wire    [31:0]  instruction_EX;

// forwarding unit 

wire    [4:0]   EX_rs_1;
wire    [4:0]   EX_rs_2;
wire    [1:0]   Forward_a;
wire    [1:0]   Forward_b;

// MUX res
wire    [31:0]  MUX_1_res;
wire    [31:0]  MUX_2_res;

// hazard detection unit
wire    [31:0]  branch_addr;
wire    Branch;
wire    Stall;
wire    NoOp;
wire    Flush;
assign Flush = (Branch & (rs_1_ID == rs_2_ID));

wire    [31:0]  MUX_reg;
wire    [31:0]  ALU_reg;

// const
reg [31:0]  four = 4;

wire    memory_stall;


Control Control(
    .Op_i       (instruction[6:0]),
    .NoOp_i     (NoOp),
    .ALUOp_o    (ALUOp_ID),
    .ALUSrc_o   (ALUSrc_ID),
    .RegWrite_o (RegWrite_ID),
    .MemtoReg_o (MemtoReg_ID),
    .MemRead_o  (MemRead_ID),
    .MemWrite_o (MemWrite_ID),
    .Branch_o   (Branch)
);

Adder Add_PC(
    .data1_in   (this_pc),
    .data2_in   (four),
    .data_o     (next_pc)
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .PCWrite_i  (PCWrite),
    .stall_i    (memory_stall),
    .pc_i       (pc_res),
    .pc_o       (this_pc)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (this_pc), 
    .instr_o    (instruction_IF)
);

Registers Registers(
    .clk_i          (clk_i),
    .RS1addr_i      (instruction[19:15]),
    .RS2addr_i      (instruction[24:20]),
    .RDaddr_i       (rd_WB), 
    .RDdata_i       (MUX_reg),
    .RegWrite_i     (RegWrite_WB), 
    .RS1data_o      (rs_1_ID), 
    .RS2data_o      (rs_2_ID) 
);

MUX_2 MUX_ALUSrc(
    .data1_i    (MUX_2_res),
    .data2_i    (instruction_EX),
    .select_i   (ALUSrc_EX),
    .data_o     (ALU_second_src)
);

MUX_2 MUX_MemSrc(
    .data1_i    (ALU_res_WB),
    .data2_i    (Mem_res_WB),
    .select_i   (MemtoReg_WB),
    .data_o     (MUX_reg)
);

MUX_2 MUX_pc(
    .data1_i    (next_pc),
    .data2_i    (branch_addr),
    .select_i   (Flush),
    .data_o     (pc_res)
);

Immediate_Generator Immediate_Generator(
    .data_i     (instruction),
    .data_o     (instruction_ID)
);

ALU ALU(
    .data1_i    (MUX_1_res),
    .data2_i    (ALU_second_src),
    .ALUCtrl_i  (ALUCtrl),
    .data_o     (ALU_res_EX),
    .Zero_o     ()
);

ALU_Control ALU_Control(
    .funct_i    (func_EX),
    .ALUOp_i    (ALUOp_EX),
    .ALUCtrl_o  (ALUCtrl)
);

/*
Data_Memory Data_Memory(
    .clk_i      (clk_i), 
    .addr_i     (ALU_res_MEM),
    .MemRead_i  (MemRead_MEM),
    .MemWrite_i (MemWrite_MEM),
    .data_i     (rs_2_MEM),
    .data_o     (Mem_res_MEM)
);
*/

dcache_controller dcache_controller(
    // System clock, reset and stall
    .clk_i  (clk_i), 
    .rst_i  (rst_i),
    
    // to Data Memory interface        
    .mem_data_i (mem_data_i), 
    .mem_ack_i  (mem_ack_i),     
    .mem_data_o (mem_data_o), 
    .mem_addr_o (mem_addr_o),     
    .mem_enable_o   (mem_enable_o), 
    .mem_write_o    (mem_write_o), 
    
    // to CPU interface    
    .cpu_data_i (rs_2_MEM), 
    .cpu_addr_i (ALU_res_MEM),     
    .cpu_MemRead_i  (MemRead_MEM), 
    .cpu_MemWrite_i (MemWrite_MEM), 
    .cpu_data_o (Mem_res_MEM), 
    .cpu_stall_o    (memory_stall)
);

IF_ID IF_ID(
    .clk_i          (clk_i),
    .instruction_i  (instruction_IF),
    .PC_i           (this_pc),
    .Stall_i        (Stall | memory_stall),
    .Flush_i        (Flush),
    .instruction_o  (instruction),
    .PC_o           (pc_ID)
);

ID_EX ID_EX(
    .clk_i          (clk_i),
    .RegWrite_i     (RegWrite_ID),
    .MemtoReg_i     (MemtoReg_ID),
    .MemRead_i      (MemRead_ID),
    .MemWrite_i     (MemWrite_ID),
    .ALUOp_i        (ALUOp_ID),
    .ALUSrc_i       (ALUSrc_ID),
    .RegWrite_o     (RegWrite_EX),
    .MemtoReg_o     (MemtoReg_EX),
    .MemRead_o      (MemRead_EX),
    .MemWrite_o     (MemWrite_EX),
    .ALUOp_o        (ALUOp_EX),
    .ALUSrc_o       (ALUSrc_EX),
    .rs_1_i         (rs_1_ID),
    .rs_2_i         (rs_2_ID),
    .rs_1_o         (rs_1_EX),
    .rs_2_o         (rs_2_EX),
    .rs_1_index_i   (instruction[19:15]),
    .rs_2_index_i   (instruction[24:20]),
    .rs_1_index_o   (EX_rs_1),
    .rs_2_index_o   (EX_rs_2),
    .ImmGen_i       (instruction_ID),
    .ImmGen_o       (instruction_EX),
    .funct_i        ({instruction[31:25], instruction[14:12]}),
    .funct_o        (func_EX),
    .rd_i           (instruction[11:7]),
    .rd_o           (rd_EX),
    .Stall_i        (memory_stall)
);

EX_MEM EX_MEM(
    .clk_i      (clk_i),
    .RegWrite_i (RegWrite_EX),
    .MemtoReg_i (MemtoReg_EX),
    .MemRead_i  (MemRead_EX),
    .MemWrite_i (MemWrite_EX),
    .RegWrite_o (RegWrite_MEM),
    .MemtoReg_o (MemtoReg_MEM),
    .MemRead_o  (MemRead_MEM),
    .MemWrite_o (MemWrite_MEM),
    .ALU_res_i  (ALU_res_EX),
    .ALU_res_o  (ALU_res_MEM),
    .rs_2_i     (MUX_2_res),
    .rs_2_o     (rs_2_MEM),
    .rd_i       (rd_EX),
    .rd_o       (rd_MEM),
    .Stall_i        (memory_stall)
);

MEM_WB MEM_WB(
    .clk_i      (clk_i),
    .RegWrite_i (RegWrite_MEM),
    .MemtoReg_i (MemtoReg_MEM),
    .RegWrite_o (RegWrite_WB),
    .MemtoReg_o (MemtoReg_WB),
    .ALU_res_i  (ALU_res_MEM),
    .ALU_res_o  (ALU_res_WB),
    .Mem_res_i  (Mem_res_MEM),
    .Mem_res_o  (Mem_res_WB),
    .rd_i       (rd_MEM),
    .rd_o       (rd_WB),
    .Stall_i        (memory_stall)
);

Forwarding_Unit Forwarding_Unit(
    .clk_i          (clk_i),
    .EX_rs_1        (EX_rs_1),
    .EX_rs_2        (EX_rs_2),
    .MEM_RegWrite   (RegWrite_MEM),
    .MEM_rd         (rd_MEM),
    .WB_rd          (rd_WB),
    .WB_RegWrite    (RegWrite_WB),
    .Forward_a      (Forward_a),
    .Forward_b      (Forward_b)
);

MUX_4 MUX_1(
    .data1_i    (rs_1_EX),
    .data2_i    (MUX_reg),
    .data3_i    (ALU_res_MEM),
    .data4_i    (),
    .select_i   (Forward_a),
    .data_o     (MUX_1_res)
);
MUX_4 MUX_2(
    .data1_i    (rs_2_EX),
    .data2_i    (MUX_reg),
    .data3_i    (ALU_res_MEM),
    .data4_i    (),
    .select_i   (Forward_b),
    .data_o     (MUX_2_res)
);

Adder Adder(
    .data1_in   ((instruction_ID << 1)),
    .data2_in   (pc_ID),
    .data_o     (branch_addr)
);

Hazard_Detection_Unit Hazard_Detection(
    .MemRead_i  (MemRead_EX),
    .rd_i       (rd_EX),
    .rs_1_i     (instruction[19:15]),
    .rs_2_i     (instruction[24:20]),
    .NoOp_o     (NoOp),
    .Stall_o    (Stall),
    .PCWrite_o  (PCWrite)
);

endmodule
