module ALU(
    data1_i,
    data2_i,
    ALUCtrl_i,
    data_o,
    Zero_o
);

input   signed  [31:0]  data1_i;
input   signed  [31:0]  data2_i;
input   [3:0]   ALUCtrl_i;

output  signed  [31:0]  data_o;
output  Zero_o;

reg [31:0]  tmp = 0;

always @ (data1_i or data2_i or ALUCtrl_i) begin
    case (ALUCtrl_i)
        0: tmp <= data1_i & data2_i; //and
        1: tmp <= data1_i ^ data2_i; //xor
        2: tmp <= data1_i << data2_i; //sll
        3: tmp <= data1_i + data2_i; //add
        4: tmp <= data1_i - data2_i; //sub
        5: tmp <= data1_i * data2_i; //mul
        6: tmp <= data1_i + data2_i; //addi
        7: tmp <= data1_i >>> data2_i[4:0]; //srai
        8: tmp <= data1_i + data2_i; //lw sw
        9: tmp <= data1_i - data2_i; //beq
        default: tmp <= 0;
    endcase
end

assign data_o = tmp; 

endmodule
