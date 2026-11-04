vlib work
vlog ../RTL/design.v ../TEST/package.sv ../TOP/top.sv +incdir+../ENV +incdir+../TEST
vsim -assertdebug -voptargs=+acc  -coverage  work.top +IN_BETWEEN_RESET_CHECK +WAIT=0 
add wave -r /*
run -all 
