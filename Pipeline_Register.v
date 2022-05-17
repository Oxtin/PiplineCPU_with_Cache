module IF_ID(
    clk_i,
    instruction_i,
    PC_i,
    Stall_i,
    Flush_i,
    instruction_o,
    PC_o,
);

input   clk_i;
input   [31:0]  instruction_i;
input   [31:0]  PC_i;
input   Stall_i;
input   Flush_i;

output  [31:0]  instruction_o;
output  [31:0]  PC_o;

reg [31:0]  instruction = 0;
reg [31:0]  PC = 0;

always@(posedge clk_i) begin
    if(~Stall_i) begin
        if(Flush_i) begin
            instruction <= 0;
            PC <= 0;
        end
        else begin
            instruction <= instruction_i;
            PC <= PC_i;
        end
    end
end

assign instruction_o = instruction;
assign PC_o = PC;

endmodule

module ID_EX(
    clk_i,
    RegWrite_i,
    MemtoReg_i,
    MemRead_i,
    MemWrite_i,
    ALUOp_i,
    ALUSrc_i,
    rs_1_i,
    rs_2_i,
    rs_1_index_i,
    rs_2_index_i,
    ImmGen_i,
    funct_i,
    rd_i,

    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    ALUOp_o,
    ALUSrc_o,
    rs_1_o,
    rs_2_o,
    rs_1_index_o,
    rs_2_index_o,
    ImmGen_o,
    funct_o,
    rd_o,
    Stall_i
);

input   clk_i;
input   RegWrite_i;
input   MemtoReg_i;
input   MemRead_i;
input   MemWrite_i;
input   [1:0]   ALUOp_i;
input   ALUSrc_i;
input   [31:0]  rs_1_i;
input   [31:0]  rs_2_i;
input   [4:0]   rs_1_index_i;
input   [4:0]   rs_2_index_i;
input   [31:0]  ImmGen_i;
input   [9:0]   funct_i;
input   [4:0]   rd_i;
input   Stall_i;

output  RegWrite_o;
output  MemtoReg_o;
output  MemRead_o;
output  MemWrite_o;
output  [1:0]   ALUOp_o;
output  ALUSrc_o;
output  [31:0]  rs_1_o;
output  [31:0]  rs_2_o;
output  [4:0]   rs_1_index_o;
output  [4:0]   rs_2_index_o;
output  [31:0]  ImmGen_o;
output  [9:0]   funct_o;
output  [4:0]   rd_o;

reg   RegWrite = 0;
reg   MemtoReg = 0;
reg   MemRead = 0;
reg   MemWrite = 0;
reg   [1:0]   ALUOp = 0;
reg   ALUSrc = 0;
reg   [31:0]  rs_1 = 0;
reg   [31:0]  rs_2 = 0;
reg   [4:0]  rs_1_index = 0;
reg   [4:0]  rs_2_index = 0;
reg   [31:0]  ImmGen = 0;
reg   [9:0]  funct = 0;
reg   [4:0]  rd = 0;


always@(posedge clk_i) begin
    if(~Stall_i) begin
        RegWrite <= RegWrite_i;
        MemtoReg <= MemtoReg_i;
        MemRead <= MemRead_i;
        MemWrite <= MemWrite_i;
        ALUOp <= ALUOp_i;
        ALUSrc <= ALUSrc_i;
        rs_1 <= rs_1_i;
        rs_2 <= rs_2_i;
        rs_1_index <= rs_1_index_i;
        rs_2_index <= rs_2_index_i;
        ImmGen <= ImmGen_i;
        funct <= funct_i;
        rd <= rd_i;
    end
end

assign RegWrite_o = RegWrite;
assign MemtoReg_o = MemtoReg;
assign MemRead_o = MemRead;
assign MemWrite_o = MemWrite;
assign ALUOp_o = ALUOp;
assign ALUSrc_o = ALUSrc;
assign rs_1_o = rs_1;
assign rs_2_o = rs_2;
assign rs_1_index_o = rs_1_index;
assign rs_2_index_o = rs_2_index;
assign ImmGen_o = ImmGen;
assign funct_o = funct;
assign rd_o = rd;

endmodule

module EX_MEM(
    clk_i,
    RegWrite_i,
    MemtoReg_i,
    MemRead_i,
    MemWrite_i,
    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    ALU_res_i,
    ALU_res_o,
    rs_2_i,
    rs_2_o,
    rd_i,
    rd_o,
    Stall_i
);

input   clk_i;
input   RegWrite_i;
input   MemtoReg_i;
input   MemRead_i;
input   MemWrite_i;
input   [31:0]  rs_2_i;
input   [4:0]   rd_i;
input   [31:0]  ALU_res_i;
input Stall_i;

output  RegWrite_o;
output  MemtoReg_o;
output  MemRead_o;
output  MemWrite_o;
output  [31:0]  rs_2_o;
output  [4:0]   rd_o;
output  [31:0]  ALU_res_o;

reg   RegWrite = 0;
reg   MemtoReg = 0;
reg   MemRead = 0;
reg   MemWrite = 0;
reg   [31:0]    rs_2 = 0;
reg   [4:0]     rd = 0;
reg   [31:0]    ALU_res = 0;

always@(posedge clk_i) begin
    if(~Stall_i) begin
        RegWrite <= RegWrite_i;
        MemtoReg <= MemtoReg_i;
        MemRead <= MemRead_i;
        MemWrite <= MemWrite_i;
        rs_2 <= rs_2_i;
        rd <= rd_i;
        ALU_res <= ALU_res_i;
    end
end

assign RegWrite_o = RegWrite;
assign MemtoReg_o = MemtoReg;
assign MemRead_o = MemRead;
assign MemWrite_o = MemWrite;
assign rs_2_o = rs_2;
assign rd_o = rd;
assign ALU_res_o = ALU_res;

endmodule

module MEM_WB(
    clk_i,
    RegWrite_i,
    MemtoReg_i,
    RegWrite_o,
    MemtoReg_o,
    ALU_res_i,
    ALU_res_o,
    Mem_res_i,
    Mem_res_o,
    rd_i,
    rd_o,
    Stall_i
);

input   clk_i;
input   RegWrite_i;
input   MemtoReg_i;
input   [4:0]  rd_i;
input   [31:0]  ALU_res_i;
input   [31:0]  Mem_res_i;
input   Stall_i;

output  RegWrite_o;
output  MemtoReg_o;
output  [4:0]  rd_o;
output  [31:0] ALU_res_o;
output  [31:0] Mem_res_o;

reg   RegWrite = 0;
reg   MemtoReg = 0;
reg   [4:0]  rd = 0;
reg   [31:0]    ALU_res = 0;
reg   [31:0]    Mem_res = 0;

always@(posedge clk_i) begin
    if(~Stall_i) begin
        RegWrite <= RegWrite_i;
        MemtoReg <= MemtoReg_i;
        rd <= rd_i;
        ALU_res <= ALU_res_i;
        Mem_res <= Mem_res_i;
    end
end

assign RegWrite_o = RegWrite;
assign MemtoReg_o = MemtoReg;
assign rd_o = rd;
assign ALU_res_o = ALU_res;
assign Mem_res_o = Mem_res;

endmodule
