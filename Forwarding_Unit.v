module Forwarding_Unit(
    clk_i,
    EX_rs_1,
    EX_rs_2,
    MEM_RegWrite,
    MEM_rd,
    WB_rd,
    WB_RegWrite,
    Forward_a,
    Forward_b
);
input    clk_i;
input    [4:0]  EX_rs_1;
input    [4:0]  EX_rs_2;
input    MEM_RegWrite;
input    [4:0]  MEM_rd;
input    [4:0]  WB_rd;
input    WB_RegWrite;
output  [1:0]   Forward_a;
output  [1:0]   Forward_b;

reg  [1:0]   tmp_Forward_a = 0;
reg  [1:0]   tmp_Forward_b = 0;

always@(EX_rs_1 or EX_rs_2 or MEM_RegWrite or MEM_rd or WB_rd or WB_RegWrite) begin
    if(MEM_RegWrite && (MEM_rd != 0) && (MEM_rd == EX_rs_1)) begin
        tmp_Forward_a <= 2'b10;
    end
    else begin
        if(WB_RegWrite && (WB_rd != 0) && (WB_rd == EX_rs_1)) begin
            tmp_Forward_a <= 2'b01;
        end
        else begin
            tmp_Forward_a <= 2'b00;
        end
    end
    if(MEM_RegWrite && (MEM_rd != 0) && (MEM_rd == EX_rs_2)) begin
        tmp_Forward_b <= 2'b10;
    end
    else begin
        if(WB_RegWrite && (WB_rd != 0) && (WB_rd == EX_rs_2)) begin
            tmp_Forward_b <= 2'b01;
        end
        else begin
            tmp_Forward_b <= 2'b00;
        end
    end
end

assign Forward_a = tmp_Forward_a;
assign Forward_b = tmp_Forward_b;

endmodule
