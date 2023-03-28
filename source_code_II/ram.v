



module ram(clock, ram_out);

input clock;
output [7:0]ram_out;

reg [7:0]address;
reg [7:0] data;
reg wren;

wire [7:0] q;


reg [7:0] counter;

initial counter = 8'b00000011;


always @(negedge clock) begin

		if (counter < 8'b11111111) begin
			counter = counter + 1;
		end
		else begin
			counter = 0;
		end
		
		address <= counter;
		data <= counter;
		wren <= 1;

end

memory _channel(address,clock,data,wren,q);


assign ram_out = q;

endmodule