



module ram(clock, data_out);

input clock;
reg [18:0] instruction;

output [7:0] data_out;

wire [7:0] cacheData;


initial begin
					   //  MODE INDEX      TAG         DATA
		instruction = {1'b1, 2'b11, 8'b00000000,8'b00000001}; // Escreve no canal 1 -> Miss 
		#100;
		
					   //  MODE INDEX      TAG         DATA
		instruction = {1'b1, 2'b11, 8'b00000000,8'b11111111}; // Escreve no canal 1 - Hit + write back
		#100;
		
					   //  MODE INDEX      TAG         DATA
		instruction = {1'b0, 2'b11, 8'b00000000,8'b00001010}; // Lê no canal 1 - Hit
		#100;
		
					   //  MODE INDEX      TAG         DATA
		instruction = {1'b1, 2'b00, 8'b00000111,8'b10000001}; // Escreve no canal 1 - Miss
		#100;
		
					   //  MODE INDEX      TAG         DATA
		instruction = {1'b0, 2'b00, 8'b00000111,8'b00001111}; // Lê no canal 1 - Hit
		#100;
		
						//  MODE INDEX      TAG         DATA
		instruction = {1'b0, 2'b10, 8'b00000111,8'b00001111}; // Lê no canal 1 - Miss + write back
		#100;
		
						//  MODE INDEX      TAG         DATA
		instruction = {1'b1, 2'b11, 8'b00000111,8'b00001010}; // Escreve no canal 2 -> - Miss
		#100;
		
//		CANAL 2

						//  MODE INDEX      TAG         DATA
		instruction = {1'b1, 2'b11, 8'b00000111,8'b00001010}; // Escreve no canal 2 -> - Hit + write back
		#100;
		
						//  MODE INDEX      TAG         DATA
		instruction = {1'b0, 2'b11, 8'b00000111,8'b00001010}; // Lê no canal 1 - Hit
		#100;
		

end


//  MODE      INDEX        TAG          DATA
//   1          2           8             8
//	 [18]     [17:16]     [15:08]       [07:00]

cache   cache_L1(clock, instruction[17:16], instruction[15:8], instruction[7:0], instruction[18], cacheData);


endmodule