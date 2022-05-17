module Immediate_Generator(
    data_i,
    data_o
);

input   [31:0]  data_i;
output  [31:0]  data_o;

reg [31:0]  tmp = 0;

always @ (data_i) begin
    if (data_i[6:0] == 7'b0010011) begin
        case (data_i[14:12])
            3'b000: tmp <= {{21{data_i[31]}}, data_i[30:20]}; // addi
            3'b101: tmp <= {{28{data_i[24]}}, data_i[23:20]}; // srai
            default: tmp <= 0;
        endcase
    end
    else if (data_i[6:0] == 7'b0000011) begin
        case (data_i[14:12])
            3'b010: tmp <= {{21{data_i[31]}}, data_i[30:20]}; // lw
            default: tmp <= 0;
        endcase
    end
    else if (data_i[6:0] == 7'b0100011) begin
        case (data_i[14:12])
            3'b010: tmp <= {{{21{data_i[31]}}, {data_i[30:25]}}, data_i[11:7]}; // sw
            default: tmp <= 0;
        endcase
    end
    else if (data_i[6:0] == 7'b1100011) begin
        case (data_i[14:12])
            3'b000: tmp <= {{{21{data_i[31]}}, data_i[7], {data_i[30:25]}}, data_i[11:8]}; // beq  
            default: tmp <= 0;
        endcase
    end
end

assign data_o = tmp;

endmodule
