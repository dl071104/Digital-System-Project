module SquareRoot_v1 (
input clk,
input resetN,
input St,
input [7:0] N,
output reg Done,
output reg [2:0] state,
output reg [3:0] Sqrt,
output reg [7:0] dataCopy
);


wire [7:0] data_out;
reg [3:0] count = 4'b0000;
//reg [2:0] state;
reg [2:0]nextstate;
reg [7:0] sub;
integer clean;
//reg [7:0] dataCopy;


    localparam S0 = 3'd0; //reset
    localparam S1 = 3'd1; //load
    localparam S2 = 3'd2; //check
    localparam S3 = 3'd3; //sub
    localparam S4 = 3'd4; //done
	 localparam S5 = 3'd5; //print


always @(posedge clk or negedge resetN) begin

	if(~resetN) begin

		state<=S0;
		end
	else begin

		state<=nextstate;
		
		
		case(state)
		S0: begin
		count<= 4'b0000; //temp_sqrt
		sub<=8'b00000001;
		Sqrt <= 4'b0000; //final output
		dataCopy <= 8'b00000000;

	
		end
		
		S1: begin

		dataCopy <= N;

		end
		

		
		S3: begin
			dataCopy <= dataCopy - sub;
			sub <= sub + 2;
			count <= count + 1;
			end
		S4: begin
			Done <= 1;
		if (St == 1)
			Sqrt <= count;

			end
			
		S5: begin	

			Done <= 0;

			end
			endcase
			end
			end

always @(*) begin
case (state)
S0: begin

	nextstate <= S1;
	end
S1: begin

	nextstate <=S2;
	end
S2: begin
	if(dataCopy >= sub)
	nextstate <= S3;
	else
	nextstate <= S4;
	end
S3: begin
	nextstate <= S2;
	end
S4: begin
	nextstate <= S5;
	end
S5: begin
	nextstate <= S0;
	end
	endcase
end
endmodule
