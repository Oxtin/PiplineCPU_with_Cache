module Control(
    Op_i,
    NoOp_i,
    ALUOp_o,
    ALUSrc_o,
    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    Branch_o
);

input [6:0] Op_i;
input NoOp_i;

output  [1:0]   ALUOp_o;
output  ALUSrc_o;
output  RegWrite_o;
output  MemtoReg_o;
output  MemRead_o;
output  MemWrite_o;
output  Branch_o;

reg [1:0]   tmp_ALUOp = 0;
reg tmp_ALUSrc = 0;
reg tmp_MemRead = 0;
reg tmp_MemWrite = 0;
reg tmp_RegWrite = 0;
reg tmp_MemtoReg = 0;
reg tmp_Branch = 0;

always @ (Op_i or NoOp_i) begin
    if(Op_i == 0) begin
        tmp_ALUOp <= 0; // NoOp
        tmp_ALUSrc <= 0;
        tmp_MemRead <= 0;
        tmp_MemWrite <= 0;
        tmp_RegWrite <= 0;
        tmp_MemtoReg <= 0;
        tmp_Branch <= 0;
    end
    else if(NoOp_i) begin
        tmp_ALUOp <= 0; // NoOp
        tmp_ALUSrc <= 0;
        tmp_MemRead <= 0;
        tmp_MemWrite <= 0;
        tmp_RegWrite <= 0;
        tmp_MemtoReg <= 0;
        tmp_Branch <= 0;
    end
    else begin
        case (Op_i)
            7'b0110011: begin
                tmp_ALUOp <= 2'b10; //R
                tmp_ALUSrc <= 0;
                tmp_MemRead <= 0;
                tmp_MemWrite <= 0;
                tmp_RegWrite <= 1;
                tmp_MemtoReg <= 0;
                tmp_Branch <= 0;
            end
            7'b0010011: begin
                tmp_ALUOp <= 2'b00; //I
                tmp_ALUSrc <= 1;
                tmp_MemRead <= 0;
                tmp_MemWrite <= 0;
                tmp_RegWrite <= 1;
                tmp_MemtoReg <= 0;
                tmp_Branch <= 0;
            end
            7'b0000011: begin
                tmp_ALUOp <= 2'b00; //lw
                tmp_ALUSrc <= 1;
                tmp_MemRead <= 1;
                tmp_MemWrite <= 0;
                tmp_RegWrite <= 1;
                tmp_MemtoReg <= 1;
                tmp_Branch <= 0;
            end
            7'b0100011: begin
                tmp_ALUOp <= 2'b00; //sw
                tmp_ALUSrc <= 1;
                tmp_MemRead <= 0;
                tmp_MemWrite <= 1;
                tmp_RegWrite <= 0;
                tmp_MemtoReg <= 0; //X
                tmp_Branch <= 0;
            end
            7'b1100011: begin
                tmp_ALUOp <= 2'b01; //beq
                tmp_ALUSrc <= 0;
                tmp_MemRead <= 0;
                tmp_MemWrite <= 0;
                tmp_RegWrite <= 0;
                tmp_MemtoReg <= 0; //X
                tmp_Branch <= 1;
            end
            default: begin
                tmp_ALUOp <= 0; // NoOp
                tmp_ALUSrc <= 0;
                tmp_MemRead <= 0;
                tmp_MemWrite <= 0;
                tmp_RegWrite <= 0;
                tmp_MemtoReg <= 0;
                tmp_Branch <= 0;
            end
        endcase
    end
end



assign ALUSrc_o = tmp_ALUSrc;
assign ALUOp_o = tmp_ALUOp;
assign RegWrite_o = tmp_RegWrite;
assign MemRead_o = tmp_MemRead;
assign MemWrite_o = tmp_MemWrite;
assign MemtoReg_o = tmp_MemtoReg;
assign Branch_o = tmp_Branch;

endmodule
