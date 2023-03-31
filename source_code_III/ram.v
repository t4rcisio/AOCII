



module ram(clock, data_out);

input clock;
reg [18:0] instruction;

output [7:0] data_out;

wire [7:0] cacheData;


initial begin

		instruction = 19'b1010000000011111111;
		#50;
		
		instruction = 19'b1110000000000000001;
		#100;

end


//  MODE      INDEX        TAG          DATA
//   1          2           8             8
//	 [18]     [17:16]     [15:08]       [07:00]

cache   lsd(clock, instruction[17:16], instruction[15:8], instruction[7:0], instruction[18], cacheData);


endmodule