module tb_sqrt;
parameter num_vectors=16; // 16 words
reg Clock, Resetn, Start; //input
wire Done; //output
reg [7:0] InputVal; //input
wire [3:0] OutputSqrt; //output
wire [2:0] state; //output
wire [7:0] dataCopy; //output
reg [7:0] vectors [0:num_vectors-1];
integer i;

SquareRoot_v1 UUT (.clk(Clock), .resetN(Resetn), .St(Start), .N(InputVal),
.Done(Done), .Sqrt(OutputSqrt), .state(state), .dataCopy(dataCopy));
 initial 
		forever
			begin
				#20 Clock = 1;
			
				 #20 Clock = 0;
			end


	initial // Test stimulus
	begin
	Resetn = 1'b0; // synchronous reset of state machine
	Start = 1'b1; // set Start to ‘false’
	#80 Resetn = 1'b1; // reset low for 2 Clock periods
	$readmemb ("C:/Users/86108/Desktop/EEC180/Lab5/test/tb_partII/testvecs.txt", vectors); // read testvecs file
	for (i=0; i<num_vectors; i=i+1) begin
	InputVal = vectors[i]; 
	$display("vector is %b, is the %d th input", vectors[i], i);
		#20 Start = 1'b1; // Start = ‘true’
		wait (Done==1);
		$display("Input= %d, SqRt= %d, state = %d, Done = %d", InputVal, OutputSqrt, state, Done);
		#20 Start = 1'b0; // After data is captured, reset Start
		wait (Done==0);
		end
		//$finish;
		end
	

endmodule
