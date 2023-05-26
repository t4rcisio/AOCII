


module reserve_station(clock, instruction, solution, storage_data, store, read, store_cdb, store_storage, request_data, instruction_out, run, mem_control);

input clock;
input store;
input read;
input store_cdb;
input store_storage;

input [47:00] instruction;
input [22:00] solution;
input [22:00] storage_data;
output reg mem_control;

output reg request_data;

output reg [42:00] instruction_out;
output reg run;
reg out_control;

reg [52:00]mem_station [0:7];

reg [2:0]stack_pointer;

reg [3:0] reg_b;
reg [3:0] reg_c;
reg [3:0] add;

reg [02:00] add_cdb;
reg [15:00] data_cdb;

reg [2:0] read_pointer;
reg [2:0] sub_pointer;
reg store_solution;

reg [3:0] i;

initial begin
mem_control = 0;
out_control = 1;
read_pointer = 0;
request_data = 1;
stack_pointer = 0;
run = 0;

for (i = 0; i<8; i = i + 1) begin
		mem_station[i] = 0;
	end

end

//
always @(posedge clock) begin

	// Grava na stack da estacao de reserva
	// Se a posicao nao conter uma instrucao valida, a gravacao é executada
	if(store && !mem_station[stack_pointer][51]) begin
											  // D  valid 	  	reg destino /B   dB			dado B			Reg C				 d C   dado C				?	
		
											//[Ru]  [V]		[OPERACAO]		    Reg Dest /B] 	    [DB]      [dado B]		 [REG C]		        [DC]		[DADO C]  		[?]
											//[52]  [51] 	  [50:47]		      [46:39]			 [38]       [37:22]        [21:18]		        [17]		[16:1]		    [0]
		mem_station[stack_pointer] = {1'b0,1'b1, instruction[47:44],instruction[43:36],1'b0,instruction[35:20],instruction[19:16],1'b0,instruction[15:0],1'b0};
		add = stack_pointer;
		stack_pointer = stack_pointer +1;
		out_control = clock;
		
		if(stack_pointer == 7) begin 
			request_data = 0;
		end
			
		if(stack_pointer == 8)
			stack_pointer = 0;
	end
	// Avalia, respctivamnete se ha' dependencia entre a ultima instrucao avaliada e as ja' inseridas
	if(store || read || store_cdb) begin
		reg_b = instruction[39:36];
		reg_c = instruction[19:16];
		// recebe o resultado da operacao na ula
		if(store_cdb) begin
			add_cdb = solution[18:16];
			data_cdb = solution[15:00];
			store_solution = store_cdb;
			//mem_station[solution[18:16]][52:51] = 0;
		end
		// loop que percorre a stack
		for (i = 0; i<8; i = i + 1) begin
		
// 1º	-- VERIFICACAO DE DEPENDENCIA
			// o bit da posicao 51 indica validade da instrucao
			if((i != add)&&(mem_station[i][51]) && store) begin
				
				// verifica se ha' correspondencia entre os registradores destino da instrucao em i e o registrador B de dados 
				// da instrucao recem inserida				// Verifica se nao e´ instrucao de load
				if((reg_b == mem_station[i][46:43]) && !(&mem_station[i][50:49]))begin
					mem_station[add][38] = 1'b1;
					mem_station[add][37:22] = 16'b0;
					mem_station[add][37:22] = i;
				end
				// verifica se ha' correspondencia entre os registradores destino da instrucao em i e o registrador C de dados 
				// da instrucao recem inserida
				if((reg_c == mem_station[i][46:43])&& !(&mem_station[i][50:49]))begin
					mem_station[add][17] = 1'b1;
					mem_station[add][16:1] = 16'b0;
					mem_station[add][16:1] = i;
				end
			end
// 2º	-- VERIFICACAO DE SOLUCAO DE INSTRUCAO	
			// Nesse passo, verifica se a instrucao recem executada esta' sendo aguardada por alguma outra instrucaco
			// em caso afirmativo, o dado é substituido e o registrador da instrucao e' marcado como 'pronto'
			// Registrador B
			if(!mem_station[i][52] && mem_station[i][51] && store_solution) begin
				if(mem_station[i][38] && (mem_station[i][37:22] == add_cdb)) begin
					mem_station[i][38] = 0;
					mem_station[i][37:22] = data_cdb;
				end
			// Registrador C
				if(mem_station[i][17] && (mem_station[i][16:01] == add_cdb)) begin
					mem_station[i][17] = 0;
					mem_station[i][16:1] = data_cdb;
				end
			end
// 3º	-- VERIFICACAO DE INSTRUCAO E DESPACHO
			// Caso não haja nenhum marcador de dependencia de dados na instrucao, ela é despachada para a ULA ou para a Memoria
			if(!mem_station[i][52] && mem_station[i][51] && !mem_station[i][38] && !mem_station[i][17] && read  && out_control) begin
				
				// Caso seja uma instrucao de memoria, LW ou SW, o dado e' despachado para a modulo de memoria
				if(mem_station[i][50] && mem_station[i][49]) begin // SW
					instruction_out = {i[2:0],mem_station[i][50:47],mem_station[i][46:43], mem_station[i][37:22],mem_station[i][16:01]};
					mem_station[i][52:51] = 0; // Não gera dependencia
					run = 0;         // desbilita a ula 
					out_control = 0;
					mem_control = 1; // habilita memoria
					
				end
				else
				if(mem_station[i][50] && !mem_station[i][49]) begin // LW
					mem_station[i][52] = 1; // Marca a instrucao como running
					instruction_out = {i[2:0],mem_station[i][50:47],mem_station[i][46:43], mem_station[i][37:22],mem_station[i][16:01]};
					run = 0;         // desbilita a ula 
					out_control = 0;
					mem_control = 1; // habilita memoria
					
				end
				// Caso não seja, envia para a ULA
				else begin
					mem_station[i][52] = 1; // Marca a instrucao como running
					instruction_out = {i[2:0],mem_station[i][50:47],mem_station[i][46:43], mem_station[i][37:22],mem_station[i][16:01]};
					run = 1;                // habilita a ula
					out_control = 0;
					mem_control = 0;        // desabilita a escrita e leitura no modulo memoria
				end
			end
			if(i == 7 && store_solution) begin // Por fim, libera o espaco de memoria da instrucao que acabou de ser executada
				mem_station[solution[18:16]][52:51] = 0;
				store_solution = 0;
			end
		end
	end
	
	
	
	
end




endmodule