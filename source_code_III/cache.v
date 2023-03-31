




module cache(clock, index, tag, data, mode, data_out);

input clock;
input [1:0] index; // Acesso à posição da cache
input [7:0] tag;   // TAG da instrução
input [7:0] data;  // Dado a ser gravado
input mode; 		    // Leitura ou escrita

output [7:0] data_out;


reg hit;
reg miss;

reg [19:0] memCache [7:0];
reg [2:0] index_plus;

reg [7:0] temp;


//	  Valid	Dirt	  LRU	   TAG	 Data
// 	 1 	  1      1		 8		  8
//	  [19]   [18]   [16]  [15:8]  [7:0]


always @(negedge clock) begin
		
		index_plus = {1'b0,index} + 3'b100;

		if (mode) begin // Gravacao
			
			// CANAL 1
			if (memCache[index][15:8] == tag) begin
					hit <= 1;
					
			end else begin
					miss <= 1;
			
			end
			
			// CANAL 2
			if (memCache[index_plus][15:8] == tag) begin
					hit <= 1;
					
			end else begin
					miss <= 1;
					
			
			end
			
		
			memCache[index][7:0] = data;
			temp = data;
			
		end
		if (!mode) begin // Leitura
		
			temp = memCache[index][7:0];
		
		end
		

end

assign data_out = temp;


endmodule