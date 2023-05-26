


module register_db(clock, read, store, reg_a, reg_b, reg_c, data_in, out_b, out_c);

input clock;
input read;
input store;

input [3:0] reg_a;
input [3:0] reg_b;
input [3:0] reg_c;

input [15:0] data_in;

output reg [15:0] out_b;
output reg [15:0] out_c;


reg [15:0] register [0:15];


initial begin
	register[00] = 16'b0000000000000001;
	register[01] = 16'b0000000000000010;
	register[02] = 16'b0000000000000011;
	register[03] = 16'b0000000000000100;
	register[04] = 16'b0000000000000001;
	register[05] = 16'b0000000000000010;
	register[06] = 16'b0000000000000011;
	register[07] = 16'b0000000000000100;
	register[08] = 16'b0000000000000001;
	register[09] = 16'b0000000000000010;
	register[10] = 16'b0000000000000100;
	register[11] = 16'b0000000000000100;
	register[12] = 16'b0000000000000100;
	register[13] = 16'b0000000000000100;
	register[14] = 16'b0000000000000100;
	register[15] = 16'b0000000000000100;
end


always @(posedge clock) begin

	if(read) begin
		out_b <= register[reg_b];
		out_c <= register[reg_c];
	end
	if(store) begin
		register[reg_a] = data_in;
	end
	
end







endmodule