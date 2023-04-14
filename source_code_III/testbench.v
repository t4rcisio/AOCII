
`timescale 1ps / 1ps
module \testbench.v   ; 
 
  wire    channel_out   ; 
  wire    hit_out   ; 
  reg    clock   ; 
  wire  [7:0]  data_out   ; 
  wire    load_out   ; 
  wire    wBack_out   ; 
  ram  
   DUT  ( 
       .channel_out (channel_out ) ,
      .hit_out (hit_out ) ,
      .clock (clock ) ,
      .data_out (data_out ) ,
      .load_out (load_out ) ,
      .wBack_out (wBack_out ) ); 



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
