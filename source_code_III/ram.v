



module ram(clock, data_out);

input clock;
reg [18:0] instruction;

output [7:0] data_out;

wire [7:0] cacheData;


initial begin
					   //  MODE INDEX      TAG         DATA
		instruction = {1'b1, 2'b11, 8'b00000000,8'b00000001}; // Escreve no canal 1
		#50;
		
					   //  MODE INDEX      TAG         DATA
		instruction = {1'b1, 2'b11, 8'b00000000,8'b11111111}; // Provoca um write back
		#150;
		
					   //  MODE INDEX      TAG         DATA
		instruction = {1'b1, 2'b11, 8'b00000001,8'b00001010}; // Escreve  no cabal 2 
		#250;
		
					   //  MODE INDEX      TAG         DATA
		instruction = {1'b1, 2'b11, 8'b00000001,8'b10000001}; // Provoca um write back
		#350;
		
					   //  MODE INDEX      TAG         DATA
		instruction = {1'b1, 2'b00, 8'b0000010,8'b00001111}; // escreve no canal 1
		#450;
		

end


//  MODE      INDEX        TAG          DATA
//   1          2           8             8
//	 [18]     [17:16]     [15:08]       [07:00]

cache   cache_L1(clock, instruction[17:16], instruction[15:8], instruction[7:0], instruction[18], cacheData);


endmodule