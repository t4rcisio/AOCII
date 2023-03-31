
`timescale 1ps / 1ps
module testbench  ; 
 
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
	  clock  = 1'b0  ;
	 # 50 ;
// 50 ps, single loop till start period.
   repeat(9)
   begin
	   clock  = 1'b1  ;
	  #50  clock  = 1'b0  ;
	  #50 ;
// 950 ps, repeat pattern in loop.
   end
	  clock  = 1'b1  ;
	 # 50 ;
// dumped values till 1 ns
  end

  initial
	#2000 $stop;
endmodule
