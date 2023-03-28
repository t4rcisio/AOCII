



module ram(clock, ram_out);

input clock;
output [7:0]ram_out;

reg [7:0]address;
reg [7:0] data;
reg wren;

wire [7:0] q;


initial begin

	address	= 	8'b00001111;
	data		=	8'b00000010;
	wren		=	1;
	#50;
	
	address	= 	8'b00001110;
	data		=	8'b00000011;
	wren		=	1;
	#100;
	
	address	= 	8'b00001111;
	data		=	8'b00000010;
	wren		=	0;
	#150;
	
	address	= 	8'b00001110;
	data		=	8'b00000011;
	wren		=	0;
	#200;
	
	
end


memory _channel(address,clock,data,wren,q);


assign ram_out = q;

endmodule