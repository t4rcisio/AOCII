


module cache(clock, index, tag, data, mode, data_out);

input clock;
input [1:0] index; // Acesso à posição da cache
input [7:0] tag;   // TAG da instrução
input [7:0] data;  // Dado a ser gravado
input mode; 		 // Leitura ou escrita

output [7:0] data_out;


reg [4:0]valid;
reg [4:0]dirt;
reg [4:0]lru;


reg hit;
reg miss;
reg w_back;

reg [18:0] memCache [0:7];

reg [7:0] RAM [0:255];

reg [2:0] index_plus;

initial begin

valid = 18;
dirt = 17;
lru = 16;

memCache[0] = 0;
memCache[1] = 0;
memCache[2] = 0;
memCache[3] = 0;
memCache[4] = 0;
memCache[5] = 0;
memCache[6] = 0;
memCache[7] = 0;

end



//	  Valid	Dirt	  LRU	   TAG	 Data
// 	 1 	  1      1		 8		  8
//	  [18]   [17]   [16]  [15:8]  [7:0]


always @(negedge clock) begin
		
		
		index_plus = {1'b0, index} + 3'b100;
	
		if (mode) begin // Gravacao
			
			// CANAL 1
			// GRAVACAO VAZIA
			if (!memCache[index][valid] || (!memCache[index][dirt] && !memCache[index][lru])) begin
					
					memCache[index][valid] = 1; 		// Marca a validade
					memCache[index][dirt] = 1;			// Marca que está sujo
					
					memCache[index][lru] = 1;			// Altera o LRU
					memCache[index_plus][lru] = 0;	// LRU da segunda via
					
					memCache[index][15:8] = tag;		// Atualiza a TAG
					memCache[index][7:0] = data;		// Atualiza o dado
					
					miss = 1;
					hit = 0;
					w_back = 0; 
			end
			
			// GRAVACAO SUJA -> Valid e Dirt
			// CANAL 1
			else if (memCache[index][15:8] == tag && memCache[index][valid] && memCache[index][dirt]) begin
					
					RAM[memCache[index][15:8]] = memCache[index][7:0]; // Leva o bloco da cache para a RAM
					
					memCache[index][lru] = 1;			// Altera o LRU
					memCache[index_plus][lru] = 0;	// LRU da segunda via
				
					memCache[index][7:0] = data;		// Atualiza o dado
					

					miss = 0;
					hit = 1;
					w_back = 1;
			end
			
			// GRAVACAO VAZIA
			// CANAL 2
			else if (!memCache[index_plus][valid] || (!memCache[index_plus][dirt] && !memCache[index_plus][lru])) begin
					
					memCache[index_plus][valid] = 1; 		// Marca a validade
					memCache[index_plus][dirt] = 1;			// Marca que está sujo
					
					memCache[index_plus][lru] = 1;			// Altera o LRU
					memCache[index][lru] = 0;	            // LRU da primeira via
					
					memCache[index_plus][15:8] = tag;		// Atualiza a TAG
					memCache[index_plus][7:0] = data;		// Atualiza o dado
					
					miss = 1;
					hit = 0;
					w_back = 0;
			end
			// GRAVACAO SUJA -> Valid e Dirt
			// CANAL 2
			else if (memCache[index_plus][15:8] == tag && memCache[index_plus][valid] && memCache[index_plus][dirt] ) begin
					
					RAM[memCache[index_plus][15:8]] = memCache[index_plus][7:0]; // Leva o bloco da cache para a RAM
					
					memCache[index_plus][lru] = 1;			// Altera o LRU
					memCache[index][lru] = 0;	           // LRU da primeira via
				
					memCache[index_plus][7:0] = data;		// Atualiza o dado
					
					
					miss = 0;
					hit = 1;
					w_back = 1;
			end
			
			
			
			
			
			
		end
end


//memory _channel(add_memory,clock,data,ctrl_memory, response);


//assign data_out = response_L1;


endmodule