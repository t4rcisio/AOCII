



module ram(clock, data_out, hit_out, wBack_out, load_out, channel_out);

input clock;
reg [18:0] instruction;

output [7:0] data_out;
output hit_out;
output wBack_out;
output channel_out;
output load_out;

wire [7:0] cacheData;
wire hit;
wire wBack;
wire channel;
wire load;


initial begin

		// MODE = 1 (ESCRUTA)
		// MODE = 0 (LEITURA)
		
		//1			   //  MODE INDEX      TAG         DATA
		instruction = {1'b0, 2'b00, 8'b00000100,8'b00000000}; // Read Miss
		#100;
		
		//2			   //  MODE INDEX      TAG         DATA
		instruction = {1'b0, 2'b00, 8'b00000101,8'b00000000}; // Read Miss
		#100;
		
		//3			   //  MODE INDEX      TAG         DATA
		instruction = {1'b0, 2'b00, 8'b00000100,8'b00000000}; // Read Hit
		#100;
		
		//4			   //  MODE INDEX      TAG         DATA
		instruction = {1'b1, 2'b01, 8'b0000000,8'b00000111}; // Write Hit
		#100;
		
		//5			   //  MODE INDEX      TAG         DATA
		instruction = {1'b1, 2'b10, 8'b0000111,8'b00000010}; // Write Hit
		#100;
		
		//6			   //  MODE INDEX      TAG         DATA
		instruction = {1'b1, 2'b10, 8'b0000110,8'b00000011}; // Write Miss - com write back
		#100;
		
		//7			   //  MODE INDEX      TAG         DATA
		instruction = {1'b0, 2'b10, 8'b0000001,8'b00000000}; // Read Miss - com write back
		#100;
		

end


//  MODE      INDEX        TAG          DATA
//   1          2           8             8
//	 [18]     [17:16]     [15:08]       [07:00]

cache   cache_L1(clock, instruction[17:16], instruction[15:8], instruction[7:0], instruction[18], cacheData, hit, wBack, load, channel);


assign data_out = cacheData;
assign hit_out = hit;
assign wBack_out = wBack;
assign load_out = load;
assign channel_out = channel;


endmodule