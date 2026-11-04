regress: vlib vlog sim cover delete
vlib:
	vlib work
vlog:
	vlog -coveropt 3 +acc +cover ../RTL/design.v ../TEST/package.sv ../TOP/top.sv +incdir+../ENV +incdir+../TEST

sim:
	vsim -vopt -assertdebug -coverage top +SANITY_TEST -c -do "coverage save -onexit -directive -cvg -codeall test1.ucdb; run -all; exit"
	vsim -vopt -assertdebug -coverage top +CHECK_BOUNDARY_WITHOUT_WAIT -c -do "coverage save -onexit -directive -cvg -codeall test2.ucdb; run -all; exit"
	vsim -vopt -assertdebug -coverage top +BACK_TO_BACK_WRITE_READ_WITHOUT_WAIT -c -do "coverage save -onexit -directive -cvg -codeall test3.ucdb; run -all; exit"
	vsim -vopt -assertdebug -coverage top +MULTIPLE_WRITE_READ_WITHOUT_WAIT -c -do "coverage save -onexit -directive -cvg -codeall test4.ucdb; run -all; exit"
	vsim -vopt -assertdebug -coverage top +ERROR_CHECK_WITHOUT_WAIT -c -do "coverage save -onexit -directive -cvg -codeall test5.ucdb; run -all; exit"
	vsim -vopt -assertdebug -coverage top +IN_BETWEEN_RESET_CHECK -c -do "coverage save -onexit -directive -cvg -codeall test6.ucdb; run -all; exit"
	vsim -vopt -assertdebug -coverage top +SANITY_TEST_WITH_WAIT +WAIT=2 -c -do "coverage save -onexit -directive -cvg -codeall test7.ucdb; run -all; exit"
	vsim -vopt -assertdebug -coverage top +CHECK_BOUNDARY_WITH_WAIT +WAIT=2 -c -do "coverage save -onexit -directive -cvg -codeall test8.ucdb; run -all; exit"
	vsim -vopt -assertdebug -coverage top +MULTIPLE_WRITE_READ_WITH_WAIT +WAIT=2 -c -do "coverage save -onexit -directive -cvg -codeall test9.ucdb; run -all; exit"
	vsim -vopt -assertdebug -coverage top +BACK_TO_BACK_WRITE_READ_WITH_WAIT +WAIT=2 -c -do "coverage save -onexit -directive -cvg -codeall test10.ucdb; run -all; exit"
	vsim -vopt -assertdebug -coverage top +ERROR_CHECK_WITH_WAIT +WAIT=2 -c -do "coverage save -onexit -directive -cvg -codeall test11.ucdb; run -all; exit"


cover:	
	vcover merge APB.ucdb test1.ucdb test2.ucdb test3.ucdb test4.ucdb test5.ucdb test6.ucdb test7.ucdb test8.ucdb test9.ucdb test10.ucdb test11.ucdb

delete:	 
	del test1.ucdb test2.ucdb test3.ucdb test4.ucdb test5.ucdb test6.ucdb test7.ucdb test8.ucdb test9.ucdb test10.ucdb test11.ucdb
	vcover report -html -details APB.ucdb -htmldir APB_TESTs


