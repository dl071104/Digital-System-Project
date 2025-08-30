
module ram8Bit(
output reg [7:0] data_out,
input [3:0] addr,
input [7:0] mdi,
input clk,
input mwr);
//reg [3:0] RAM[15:0] /* synthesis ramstyle = "M9K", ram_init_file = "partI.mif" */;
 (* ramstyle = "M9K", ram_init_file = "partII.mif" *) reg [7:0] RAM[15:0];
always @(posedge clk) begin

 if (mwr) begin
 
	RAM[addr] <=mdi;
	end
		data_out <= RAM[addr];
	end
endmodule
	