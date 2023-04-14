view wave 
wave clipboard store
wave create -driver freeze -pattern clock -initialvalue 0 -period 100ps -dutycycle 50 -starttime 0ps -endtime 1000ps sim:/ram/clock 
wave create -driver freeze -pattern constant -value X -starttime 0ps -endtime 1000ps sim:/ram/clock 
wave create -pattern constant -value xxxxxxxxxxxxxxxxxxx -range 18 0 -starttime 0ps -endtime 1000ps sim:/ram/instruction 
wave create -driver freeze -pattern constant -value xx -range 1 0 -starttime 0ps -endtime 1000ps sim:/ram/cache_L1/index 
wave create -driver freeze -pattern clock -initialvalue 0 -period 100ps -dutycycle 50 -starttime 0ps -endtime 1000ps sim:/ram/clock 
{wave export -file C:/AOC/memoria/source_code_III/testbench.v -starttime 0 -endtime 1000 -format vlog -designunit ram -f} 
WaveCollapseAll -1
wave clipboard restore
