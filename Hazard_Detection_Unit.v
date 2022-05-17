module Hazard_Detection_Unit(
    MemRead_i,
    rd_i,
    rs_1_i,
    rs_2_i,
    NoOp_o,
    Stall_o,
    PCWrite_o
);

input MemRead_i;
input [4:0] rd_i;
input [4:0] rs_1_i;
input [4:0] rs_2_i;

output NoOp_o;
output Stall_o;
output PCWrite_o;

reg tmp_NoOp = 0;
reg tmp_Stall = 0;
reg tmp_PCWrite = 1;

always@(MemRead_i or rd_i or rs_1_i or rs_2_i) begin
    if(MemRead_i) begin
        if(rd_i == rs_1_i || rd_i == rs_2_i) begin
            tmp_NoOp = 1;
            tmp_Stall = 1;
            tmp_PCWrite = 0;
        end
        else begin
            tmp_NoOp = 0;
            tmp_Stall = 0;
            tmp_PCWrite = 1;
        end
    end
    else begin
        tmp_NoOp = 0;
        tmp_Stall = 0;
        tmp_PCWrite = 1;
    end
end

assign NoOp_o = tmp_NoOp;
assign Stall_o = tmp_Stall;
assign PCWrite_o = tmp_PCWrite;

endmodule
