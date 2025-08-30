
module partI (

input  [9:0] SW,
input  [1:0] KEY,
output [7:0] HEX3,	// address display HEX3
output [7:0] HEX2,	// data input display HEX2
output [7:0] HEX1,	// RAM1 data output display HEX1
output [7:0] HEX0	// RAM0 data output display HEX0
);


 /*

reg [3:0] data_out0;
reg [3:0] data_out1;
wire [3:0] addr = SW[7:4];
wire [3:0] mdi = SW[3:0];
wire mwr = SW[9];
wire clk = KEY[0];
wire ram_select = SW[8];// 0 then ram0, 1 then ram1;
wire rst = KEY[1];
integer x;
*/
wire [3:0] addr = SW[7:4];
wire [3:0] mdi = SW[3:0];
//wire rst = KEY[1];
wire clk = KEY[0];
wire [3:0] data_out0;
wire [3:0] data_out1;
wire mwr0 = SW[9]&(~SW[8]);
wire mwr1 = SW[9]&(SW[8]);

//assign addr = addr&(~rst);
ram RAM1 (.data_out(data_out1), .addr(addr), .mdi(mdi), .clk(clk), .mwr(mwr1));
//ram_1prt ram_1prt_inst(.address(addr), .clock(clk), .data(mdi), .wren(mwr1), .q(data_out1)); //extra credit
ram RAM0 (.data_out(data_out0), .addr(addr), .mdi(mdi), .clk(clk), .mwr(mwr0));
//always @(posedge clk) begin
//if (rst)
//addr = 4'b0000;
//end

hex_display hex_addr (.bin(SW[7:4]), .seg(HEX3));       //address display hex3
hex_display hex_mdi (.bin(SW[3:0]), .seg(HEX2)); //data input display hex2
hex_display hex_ram1 (.bin(data_out1), .seg(HEX1));  //RAM1 output display hex1
hex_display hex_ram0 (.bin(data_out0), .seg(HEX0));  //RAM0 output display hex0

//end
endmodule
