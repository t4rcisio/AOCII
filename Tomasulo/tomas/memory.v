






module memory(clock, key_mem, instruction, done, solution);

input clock;
input key_mem;

input[42:00] instruction;

output reg done;
output reg [22:00]solution;


reg [15:00] memory_data [0:1024];

reg [15:00] cache_solution;
reg [2:0]  address_solution;
reg [3:0] reg_solution;
reg store;

always @(posedge clock) begin
	
	done <= store;
	solution <= {reg_solution, address_solution, cache_solution};
	
	if(key_mem) begin
		
		// Gravacao
		if(instruction[39] && instruction[38]) begin
			memory_data[instruction[31:16]] = instruction[15:0];
			store = 0;
		end
		// Leitura
		if(instruction[39] && !instruction[38]) begin
			cache_solution = memory_data[instruction[15:00]];
			address_solution <= instruction[42:40];
			reg_solution <= instruction[35:32];
			store = 1;
		end
	end
	else begin
		store = 0;
		cache_solution = 0;
		address_solution = 0;
		reg_solution = 0;
	end
end


endmodule