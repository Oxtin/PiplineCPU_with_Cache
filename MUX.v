module MUX_2(
    data1_i,
    data2_i,
    select_i,
    data_o
);

input   [31:0]  data1_i;
input   [31:0]  data2_i;
input select_i;

output  [31:0]  data_o;

reg [31:0]  tmp = 0;

always @ (data1_i or data2_i or select_i) begin
    case (select_i)
        0: tmp <= data1_i;
        1: tmp <= data2_i;
        default: tmp <= data1_i;
    endcase
end

assign data_o = tmp;

endmodule

module MUX_4(
    data1_i,
    data2_i,
    data3_i,
    data4_i,
    select_i,
    data_o
);

input   [31:0]  data1_i;
input   [31:0]  data2_i;
input   [31:0]  data3_i;
input   [31:0]  data4_i;
input   [1:0]   select_i;

output  [31:0]  data_o;

reg [31:0]  tmp = 0;

always @ (data1_i or data2_i or data3_i or data4_i or select_i) begin
    case (select_i)
        2'b00: tmp <= data1_i;
        2'b01: tmp <= data2_i;
        2'b10: tmp <= data3_i;
        2'b11: tmp <= data4_i;
        default: tmp <= data1_i;
    endcase
end

assign data_o = tmp;

endmodule


