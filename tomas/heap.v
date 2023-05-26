



module heap(clock, data_in, read, data_out, read_out, mem_space);


input clock;
input [15:0] data_in;
input read;

output [15:0] data_out;
output reg read_out;
output reg mem_space;

reg [16:0] mem_heap [0:7];
reg [3:0] pointer_store;
reg [3:0] pointer_read;
reg [3:0] pointer_default;
reg [16:0] data_cache;
reg store;
integer i;
reg init;

initial begin
	mem_space = 1;
	pointer_read = 0;
	pointer_store = 0;
	pointer_default = 0;
	read_out = 0;
	init = 1;
	store = 1;
	for (i = 0; i<8; i = i + 1) begin
		mem_heap[i] = 0;
	end
	
end

// [stored] [data]
// [  1   ] [ 16 ]

always @(posedge clock) begin
		
		// Init ajusta a saida de dados da rom com a entrada na heap
		if(init) begin
		init =  !init;
		end
		else if(!init) begin
			
			if(store || read) begin
				
				// Le o dado de uma linha valida
				if(read && mem_heap[pointer_read][16]) begin
					data_cache = mem_heap[pointer_read];
					mem_heap[pointer_read] = 0;
					pointer_read = pointer_read + 1;
					read_out = 1;
					store = 1;
					mem_space = 1;
				end
				
				// grava dado em uma linha invalida
				if(store && !mem_heap[pointer_store][16]) begin
					mem_heap[pointer_store] = {16'b1,data_in};
					pointer_store = pointer_store + 1;
					
					if(pointer_store == 7) // Impede que a ROM forneca mais instrucoes
						mem_space = 0;
					if(pointer_store == 8) // Retorna para o inicio da fila
						pointer_store = 0;
				end
			end
			else begin
				read_out = 0;
				store  = 0;
			end
		end
		
end

assign data_out = data_cache[15:0];

endmodule