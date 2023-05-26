


module mux_merge(clock, instruction, cdb_done, data_cdb, mux_control, data_inb, data_inc, mux_out, merged);

input clock;
input [15:0]instruction;
input [15:0] data_inb;
input [15:0] data_inc;
input mux_control;
input cdb_done;
input [22:00] data_cdb;

output [47:0] mux_out;
output merged;

reg [15:0] temp_inb;
reg [15:0] temp_inc;



reg [47:0] step_2;
reg [15:0] step_1;
reg [15:0] step_0;

reg merged_0;
reg merged_1;
reg merged_2;

always @(posedge clock) begin
   if(mux_control) begin
	
		   // Com os dados em memoria, step 3 concatena tudo no formato base da memoria da 
			// estacao de reserva
			// o if com cdb_done e uma interceptacao de escrita da ula no mux_control
			// verifica se o dado que acabou de ser lido pelo mux no banco de registradores
			// esta' sendo alterado na ula, de forma que, em caso positivo, o valor dos registadores
			// e' alterado direatamente pela saida da ula, garanteindo que chegue os dados atualizados
			// na estacao de reserva
			if(step_1[07:04] == data_cdb[22:19] && cdb_done)
				temp_inb = data_cdb[15:00];
			if(step_1[03:00] == data_cdb[22:19] && cdb_done)
				temp_inc = data_cdb[15:00];
			step_2 = {step_1[15:12],step_1[11:08],step_1[07:04],temp_inb,step_1[03:00],temp_inc};
			merged_2 = merged_1;
			// step 1 <- Devido ao tempo de leitura dos registradores, stpe 1, move a instrucao
			// da cache para outro registrador e salva a resposta do banco de registradores
			step_1 = step_0;
			temp_inb  = data_inb;
			temp_inc  = data_inc;
			merged_1 = merged_0;
			// step 0 <- salva em cache a instrucao vinda da heap
			step_0 = instruction;
			merged_0 = mux_control;
	end

end


assign mux_out = step_2;
assign merged = merged_2;
endmodule


/*
if(async && mux_control) begin
		//         
		mux_out = {temp_op, temp_a, temp_b, data_inb, temp_c, data_inc};
		async   = !async;
	end
	if(!async && mux_control) begin
		temp_op = instruction[15:12];
		temp_a  = instruction[11:08];
		temp_b  = instruction[07:04];
		temp_c  = instruction[03:00];
		async = !async;
	end


*/

