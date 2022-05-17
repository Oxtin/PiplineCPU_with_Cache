module ALU_Control(
    funct_i,
    ALUOp_i,
    ALUCtrl_o
);

input   [9:0]   funct_i;
input   [1:0]   ALUOp_i;

output  [3:0]   ALUCtrl_o;

reg [3:0]   tmp = 0;

always @ (funct_i or ALUOp_i) begin
    if (ALUOp_i == 2'b00) begin // ld sd I
        case (funct_i[2:0])
            3'b000: tmp <= 6; // addi
            3'b101: tmp <= 7; // srai
            3'b010: tmp <= 8; // lw sw
            default: tmp <= 0; 
        endcase
    end 
    else if (ALUOp_i == 2'b01) begin // beq
        case (funct_i[2:0])
            3'b000: tmp <= 9; // lw sw
            default: tmp <= 0;
        endcase
    end
    else if (ALUOp_i == 2'b10) begin // R
        case (funct_i)
            10'b0000000111: tmp <= 0; // and
            10'b0000000100: tmp <= 1; // xor
            10'b0000000001: tmp <= 2; // sll
            10'b0000000000: tmp <= 3; // add
            10'b0100000000: tmp <= 4; // sub 
            10'b0000001000: tmp <= 5; // mul   
            default: tmp <= 0;
        endcase
    end
    else begin
        tmp <= 0;
    end
end

assign ALUCtrl_o = tmp;

endmodule
