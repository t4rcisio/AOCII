


module logic_unity(clock, request, instruction, run, done, solution);

input clock;
input[42:00] instruction;
input run;

output reg request;

output reg done;
output reg [22:00]solution;

reg [15:00] cache_solution;
reg [2:0]  address_solution;
reg [3:0] reg_solution;
reg store;


initial request = 1;
initial solution = 0;

always @(posedge clock) begin

	
	
	if(run) begin
		// informa para o circuito que ha' uma solucao disponivel
		done <= store;
		// endereco: reg_destino,  linha na est. reserva, o resultado 
		solution <= {reg_solution, address_solution, cache_solution};
		
		case(instruction[39:36])
			4'b0000 : begin // SOMA
							cache_solution   <= instruction[31:16] + instruction[15:0];
							address_solution <= instruction[42:40];
							reg_solution <= instruction[35:32];
							store = 1;
						end
			4'b0001 : begin // SUBTRACAO
							cache_solution   <= instruction[31:16] - instruction[15:0];
							address_solution <= instruction[42:40];
							reg_solution <= instruction[35:32];
							store = 1;
						end
			4'b0010 : begin // MUL
							cache_solution   <= instruction[31:16] * instruction[15:0];
							address_solution <= instruction[42:40];
							reg_solution <= instruction[35:32];
							store = 1;
						end
			4'b0011 : begin // DIV
							cache_solution   <= instruction[31:16] / instruction[15:0];
							address_solution <= instruction[42:40];
							reg_solution <= instruction[35:32];
							store = 1;
						end
			default : begin 
							cache_solution <= 16'b0;
							address_solution <= 3'b000;
							reg_solution <= 4'b0000;
							store = 0;
						end
		endcase
	end
	else begin
		done = 0;
		solution =0;
	end
end

endmodule