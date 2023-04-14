


module cache(clock, index, tag, data, mode, data_out, hit_out, wBack_out, load_out, channel_out);

input clock;
input [1:0] index; // Acesso à posição da cache
input [7:0] tag;   // TAG da instrução
input [7:0] data;  // Dado a ser gravado
input mode; 		 // Leitura ou escrita

output [7:0] data_out;
output hit_out;
output wBack_out;
output channel_out;
output load_out;

reg [4:0]valid;
reg [4:0]dirt;
reg [4:0]lru;

reg [7:0] temp_out;

reg hit;
reg miss;
reg w_back;
reg load; 

reg channel_ctrl;

reg [18:0] memCache [0:7];

reg [7:0] RAM [0:255];

reg [2:0] index_plus;


initial begin


valid = 18;
dirt = 17;
lru = 16;
//------------Valid	Dirt	 LRU	   TAG	        Data
memCache[0] = {1'b0, 1'b0, 1'b0, 8'b00000100, 8'b00000001};
memCache[1] = {1'b1, 1'b0, 1'b1, 8'b00000000, 8'b00000011};
memCache[2] = {1'b1, 1'b1, 1'b0, 8'b00000101, 8'b00000101};
memCache[3] = {1'b0, 1'bx, 1'bx, 8'b00000xxx, 8'b00000xxx};

//------------Valid	Dirt	 LRU	   TAG	        Data
memCache[4] = {1'b0, 1'b0, 1'b0, 8'b00000xxx, 8'b00000010};
memCache[5] = {1'b0, 1'b0, 1'b0, 8'b00000xxx, 8'b00000100};
memCache[6] = {1'b1, 1'b1, 1'b1, 8'b00000111, 8'b00000110};
memCache[7] = {1'b0, 1'bx, 1'bx, 8'b00000xxx, 8'b00000xxx};


//----------- PREENCHIMENTO DA RAM
RAM[0] = 8'b00000000;
RAM[1] = 8'b00000001;
RAM[2] = 8'b00000010;
RAM[3] = 8'b00000011;
RAM[4] = 8'b00000100;
RAM[5] = 8'b00000101;
RAM[6] = 8'b00000110;
RAM[7] = 8'b00000111;

end



//---Valid	Dirt	  LRU	   TAG	 Data
//-----1 	  1      1		 8		  8
//----[18]   [17]   [16]  [15:8]  [7:0]

reg temp_tag_a;
reg temp_tag_b;

reg temp_dirt_a;
reg temp_dirt_b;

reg temp_lru_a;
reg temp_lru_b;

reg temp_valid_a;
reg temp_valid_b;



always @(negedge clock) begin
		
		// Faz a soma no index para apontar para o canal 2
		index_plus = {1'b0, index} + 3'b100;
		
		// Faz o calculo da saida de HIT e MISS para cada canal
		if (tag == memCache[index][15:8]) begin
			temp_tag_a = 1;
		end else begin
			temp_tag_a = 0;
		end
		
		if (tag == memCache[index_plus][15:8]) begin
			temp_tag_b = 1;
		end else begin
			temp_tag_b = 0;
		end 
		
		// Faz o calculo para definir se houve Hit ou Miss
		
		hit = (temp_tag_a || temp_tag_b) && (memCache[index][valid] || memCache[index][index_plus]);
		miss = !hit;
		
		// Testa as condicoes de entrada do canal 1, assim habilita ou não os testes no canal 2
		channel_ctrl = ((!temp_lru_a && !temp_tag_a) || temp_tag_a);
		
		// Obtem as variaves logicas para os testes nas condicionais 
		temp_dirt_a 	= memCache[index][dirt];
		temp_dirt_b 	= memCache[index_plus][dirt];
		
		
		temp_lru_a 		= memCache[index][lru];
		temp_lru_b 		= memCache[index_plus][lru];
		
		
		temp_valid_a = memCache[index][valid];
		temp_valid_b = memCache[index][index_plus];
		
		
		// Escrita -> Miss
		if (!temp_tag_a && mode) begin // Caso: Miss na Tag e a LRU esteja em 0
				
				// Memoria vazia
				if (!temp_lru_a) begin
					
					if (temp_dirt_a) begin // Write Back
						RAM[memCache[index][15:8]] = memCache[index][7:0];
						w_back = 1;
						load = 0;
					end else begin
						w_back = 0;
						load = 0;
					end
					
					memCache[index][valid] = 1; 		// Marca a validade
					memCache[index][dirt] = 1;			// Marca que está sujo
				
					memCache[index][lru] = 1;			// Altera o LRU
					memCache[index_plus][lru] = 0;	// LRU da segunda via
				
					memCache[index][15:8] = tag;		// Atualiza a TAG
					memCache[index][7:0] = data;		// Atualiza o dado
					
					temp_out = data;
				
				end	
		end
		
		// Escrita -> Hit
		else if (temp_tag_a && mode) begin // Caso: Hit na Tag. Caso esteja sujo, faz a atualizacao na RAM
				
				if (temp_dirt_a) begin // Write Back
					RAM[memCache[index][15:8]] = memCache[index][7:0];
					w_back = 1;
					load = 0;
				end else begin
					w_back = 0;
					load = 0;
				end
			
				memCache[index][valid] = 1; 		// Marca a validade
				memCache[index][dirt] = 1;			// Marca que está sujo
			
				memCache[index][lru] = 1;			// Altera o LRU
				memCache[index_plus][lru] = 0;	// LRU da segunda via
			
				memCache[index][15:8] = tag;		// Atualiza a TAG
				memCache[index][7:0] = data;		// Atualiza o dado
				
				temp_out = data;
			
		end
		
		// Leitura - Hit
		else if (temp_tag_a && !mode) begin // Caso: Hit na Tag. Testa se o dado e valido, caso
														// 		negativo, traz o dado da RAM								
				if (!temp_valid_a) begin // Busca dado na RAM
					memCache[index][7:0] = RAM[tag];
					load = 1;
					w_back = 0;
				end else begin
					w_back = 0;
					load = 0;
				end
				
				
				memCache[index][valid] = 1; 		// Marca a validade
				memCache[index][dirt] = 0;			// Marca que está limpo
			
				memCache[index][lru] = 1;			// Altera o LRU
				memCache[index_plus][lru] = 0;	// LRU da segunda via
			
				memCache[index][15:8] = tag;		// Atualiza a TAG
				
				temp_out = memCache[index][7:0];
		end
		
		// Leitura - Miss
		else if (!temp_tag_a && !mode && !temp_lru_a) begin // Caso: Miss na Tag e a LRU esteja em 0
				
				memCache[index][7:0] = RAM[tag];
				
				w_back = 0;
				load = 1;
				
				memCache[index][valid] = 1; 		// Marca a validade
				memCache[index][dirt] = 0;			// Marca que está limpo
			
				memCache[index][lru] = 1;			// Altera o LRU
				memCache[index_plus][lru] = 0;	// LRU da segunda via
			
				memCache[index][15:8] = tag;		// Atualiza a TAG
				
				temp_out = memCache[index][7:0];
		end
		else begin
			channel_ctrl = 0;
		end
		
		if (!channel_ctrl) begin  // Caso as condicoes de execucao do canal 1 nao forem satisfeitas
		
			if (!temp_tag_b && mode) begin
					
					// Memoria vazia | Verifica se ha algo escrito no canal 1
					if (!temp_lru_b) begin
					
						if (temp_dirt_b) begin // Write Back
							RAM[memCache[index_plus][15:8]] = memCache[index_plus][7:0];
							w_back = 1;
							load = 0;
						end else begin
							w_back = 0;
							load = 0;
						end
					
						memCache[index_plus][valid] = 1; 		// Marca a validade
						memCache[index_plus][dirt] = 1;			// Marca que está sujo
					
						memCache[index_plus][lru] = 1;			// Altera o LRU
						memCache[index][lru] = 0;					// LRU da primeira via
					
						memCache[index_plus][15:8] = tag;		// Atualiza a TAG
						memCache[index_plus][7:0] = data;		// Atualiza o dado
						
						temp_out = data;
					
					end	
			end
			
			// Escrita -> Hit
			else if (temp_tag_b && mode) begin

					if (temp_dirt_b) begin // Write Back
						RAM[memCache[index_plus][15:8]] = memCache[index_plus][7:0];
						w_back = 1;
						load = 0;
					end else begin
						w_back = 0;
						load = 0;
					end
				
					memCache[index_plus][valid] = 1; 		// Marca a validade
					memCache[index_plus][dirt] = 1;			// Marca que está sujo
				
					memCache[index_plus][lru] = 1;			// Altera o LRU
					memCache[index][lru] = 0;					// LRU da primeira via
				
					memCache[index_plus][15:8] = tag;		// Atualiza a TAG
					memCache[index_plus][7:0] = data;		// Atualiza o dado
					
					temp_out = data;
				
			end
			
			// Leitura - Hit
			else if (temp_tag_b && !mode) begin

					if (!temp_valid_b) begin // Busca dado na RAM
						memCache[index_plus][7:0] = RAM[tag];
						w_back = 0;
						load = 1;
						
					end else begin
						w_back = 0;
						load = 0;
					end
					
					
					memCache[index_plus][valid] = 1; 		// Marca a validade
					memCache[index_plus][dirt] = 0;			// Marca que está limpo
				
					memCache[index_plus][lru] = 1;			// Altera o LRU
					memCache[index][lru] = 0;					// LRU da primeira via
				
					memCache[index_plus][15:8] = tag;		// Atualiza a TAG
					
					temp_out = memCache[index_plus][7:0];
			end
			
			// Leitura - Miss
			else if (!temp_tag_b && !mode && !temp_lru_b) begin

					memCache[index_plus][7:0] = RAM[tag];
					
					w_back = 0;
					load = 1;
					
					memCache[index_plus][valid] = 1; 		// Marca a validade
					memCache[index_plus][dirt] = 0;			// Marca que está limpo
				
					memCache[index_plus][lru] = 1;			// Altera o LRU
					memCache[index][lru] = 0;					// LRU da primeira via
				
					memCache[index_plus][15:8] = tag;		// Atualiza a TAG
					
					temp_out = memCache[index_plus][7:0];
			end
		end
end


//memory _channel(add_memory,clock,data,ctrl_memory, response);


assign data_out = temp_out;
assign hit_out = hit;
assign wBack_out = w_back;
assign load_out = load;
assign channel_out = channel_ctrl;

endmodule