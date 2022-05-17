module dcache_sram
(
    clk_i,
    rst_i,
    addr_i,
    tag_i,
    data_i,
    enable_i,
    write_i,
    tag_o,
    data_o,
    hit_o
);

// I/O Interface from/to controller
input              clk_i;
input              rst_i;
input    [3:0]     addr_i; // 16 entry
input    [24:0]    tag_i; // 24 bit : 1 valid + 1 dirty + 23 tag / 16 entry / 2 table
input    [255:0]   data_i; // 32 byte / 16 entry / 2 table
input              enable_i;
input              write_i;

output   [24:0]    tag_o;
output   [255:0]   data_o;
output             hit_o;

// Memory
reg      [24:0]    tag [0:15][0:1]; 
reg      [255:0]   data[0:15][0:1]; 

integer            i, j;

wire    hit_0;
wire    hit_1;

assign hit_0 = (tag[addr_i][0][24] == 1 && tag_i[22:0] == tag[addr_i][0][22:0])? 1 : 0;
assign hit_1 = (tag[addr_i][1][24] == 1 && tag_i[22:0] == tag[addr_i][1][22:0])? 1 : 0;

reg     [15:0]  LRU;

// Write Data
// 1. Write hit
// 2. Read miss: Read from memory
always@(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        for (i=0;i<16;i=i+1) begin
            for (j=0;j<2;j=j+1) begin
                tag[i][j] <= 25'b0;
                data[i][j] <= 256'b0;
            end
        end
        LRU <= 16'b0;
    end
    if (enable_i && write_i) begin
        // TODO: Handle your write of 2-way associative cache + LRU here
        if(hit_0) begin
            data[addr_i][0] <= data_i;
            tag[addr_i][0] <= tag_i;
            LRU[addr_i] <= 0;
        end
        else if(hit_1) begin
            data[addr_i][1] <= data_i;
            tag[addr_i][1] <= tag_i;
            LRU[addr_i] <= 1;
        end
        else begin
            if(LRU[addr_i] == 1) begin
                data[addr_i][0] <= data_i;
                tag[addr_i][0] <= tag_i;
                LRU[addr_i] <= 0;
            end
            else if(LRU[addr_i] == 0) begin
                data[addr_i][1] <= data_i;
                tag[addr_i][1] <= tag_i;
                LRU[addr_i] <= 1;
            end
        end
    end
    if(enable_i) begin
        if(hit_0) begin
            LRU[addr_i] <= 0;
        end
        if(hit_1) begin
            LRU[addr_i] <= 1;
        end
    end
end

// Read Data
// TODO: tag_o=? data_o=? hit_o=?
assign hit_o = (hit_0 | hit_1);
assign data_o = (hit_0)? data[addr_i][0] : ((hit_1)? data[addr_i][1] : ((LRU[addr_i] == 1)? data[addr_i][0] : data[addr_i][1]));
assign tag_o = (hit_0)? tag[addr_i][0] : ((hit_1)? tag[addr_i][1] : ((LRU[addr_i] == 1)? tag[addr_i][0] : tag[addr_i][1]));

endmodule
