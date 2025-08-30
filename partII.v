
module partII(

    output [7:0] HEX0,
    output [7:0] HEX1,
    output [7:0] HEX2,
    output [7:0] HEX3,
    output [7:0] HEX4,
    output [7:0] HEX5,

    input  [1:0] KEY, //KEY[1] -> clk, KEY[0] -> reset

    output reg [9:0] LEDR,

    input  [9:0] SW // SW[7] is mwr, SW[8] is St (output the sqrt)
);

    wire [7:0] sqrt, dataCopy;
    wire Done;  // Declare Done as a wire to connect to the SquareRoot module
    reg [7:0] mdi;
	 wire [7:0] N;
	 wire [2:0] state;
	 reg [3:0] addr = 4'b0000;
	 
		ram8Bit RAM( .data_out(N), .addr(addr), .mdi(mdi), .clk(KEY[1]), .mwr(SW[7])); //SW[7] enable the input mode.
   

	SquareRoot_v1 S(
        .clk(KEY[1]),
        .resetN(KEY[0]),
        .St(SW[8]),
        .N(N),
        .Done(Done),  //Done is LEDR9;
        .Sqrt(sqrt),
		  .state(state),
		  .dataCopy(dataCopy)
		  
    );

    // Control the assignment of mdi based on SW input if the SW[7] is on
    always @(posedge KEY[1]) begin //KEY[1] is clk
		
		if (Done == 1) begin
		if (addr < 4'b1111)
		addr = addr + 1;
		else if (addr == 4'b1111)
		addr = 4'b0000;
		end
		
		
		if(SW[7] == 1) begin
        case(SW[3:0]) // Use the lower 4 switches to select different values of mdi
            4'b0001: mdi = 8'b00000001;  // N = 1
            4'b0010: mdi = 8'b00000100;  // N = 4
            4'b0011: mdi = 8'b00001001;  // N = 9
            4'b0100: mdi = 8'b00010000;  // N = 16
            4'b0101: mdi = 8'b00011001;  // N = 25
            4'b0110: mdi = 8'b00100100;  // N = 36
            4'b0111: mdi = 8'b00110001;  // N = 49
            4'b1000: mdi = 8'b01000000;  // N = 64
            4'b1001: mdi = 8'b00000000;  // N = 0
            4'b1010: mdi = 8'b00000110;  // N = 6
            4'b1011: mdi = 8'b00001101;  // N = 13
            4'b1100: mdi = 8'b00010101;  // N = 21
            4'b1101: mdi = 8'b00011011;  // N = 27
            4'b1110: mdi = 8'b00101100;  // N = 44
            4'b1111: mdi = 8'b11111111;  // N = 255
            default: mdi = 8'b00000111;  // Default case (no value selected)
        endcase
		  end
    end


    always @(*) begin
        LEDR[0] = Done;  // If Done is 1, LEDR[0] will be 1, otherwise it will be 0
    end

    hex_display hex0 (.bin(N[3:0]), .seg(HEX0));
    hex_display hex1 (.bin(N[7:4]), .seg(HEX1));
	 hex_display hex3 (.bin(state), .seg(HEX3));
	 hex_display hex5 (.bin(dataCopy[7:4]), .seg(HEX5));
	 hex_display hex4 (.bin(dataCopy[3:0]), .seg(HEX4));
	 hex_displayOUTPUT hex2 (.bin(sqrt), .seg(HEX2), .PRINT(SW[8]));
endmodule
