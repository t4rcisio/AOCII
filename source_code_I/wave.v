
`timescale 1ps / 1ps
module wave  ; 
 
  reg    clock   ; 
  wire  [7:0]  ram_out   ; 
  ram  
   DUT  ( 
       .clock (clock ) ,
      .ram_out (ram_out ) ); 



// "Clock Pattern" : dutyCycle = 50
// Start Time = 0 ps, End Time = 1 ns, Period = 100 ps
  initial
  begin
   repeat(10)
   begin
	   clock  = 1'b1  ;
	  #50  clock  = 1'b0  ;
	  #50 ;
// 1 ns, repeat pattern in loop.
   end
  end

  initial
	#2000 $stop;
endmodule
