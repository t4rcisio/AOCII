


module ROM(clock, read, instruction);

input clock;
input read;
output reg [15:0] instruction;


reg [15:0] memory [0:255];
reg [7:0]address;

initial begin 
	
	address = 0;
				    // OP		
					   //0000101000000001	
	memory[00] = 16'b0000101000000001; // add - sem dependencia  1
	memory[01] = 16'b0000000110100000; // sub - dependencia simples 2
	memory[02] = 16'b0000001000011010; // RM  - dependencia dupla  4
	memory[03] = 16'b0000111101110011; // SM  - sem dependencia    3
	memory[04] = 16'b1100101010101111; // SD  - 
	memory[05] = 16'b1000001000101010; // add
	
	/*memory[04] = 16'b0100000000000000; // LI
	memory[05] = 16'b0000000001000000; // add
	memory[06] = 16'b0001000011100000; // sub
	memory[07] = 16'b0010000111111111; // RM
	memory[08] = 16'b1011000000000011; // SM 
	memory[09] = 16'b1101000101000000; // LI
	memory[10] = 16'b1111000000000000; // LI*/
	

end



always @(posedge clock) begin
		
		if(read) begin
			instruction <= memory[address];
			address = address +1;
		end
			
end


endmodule