`ifndef APB_PACKAGE_SV 
`define APB_PACKAGE_SV

package pkg;
	parameter int DELAY = 30;
	event item_done;
	event reset_item_done;
	int no_transaction;
	static int counter;
		
	`include "transaction.sv"
	`include "generator.sv"
	`include "driver.sv"
	`include "monitor.sv"
	`include "func_covg.sv"
	`include "scoreboard.sv"
	`include "env.sv"

	//Testcases
	`include "Sanity_test.sv"
	`include "Check_boundary_test.sv"
	`include "Multiple_write_read_test.sv"
	`include "Check_error_signal_test.sv"
	`include "in_between_reset_test.sv"

	`include "test.sv"
	
	//---------------------------------------------------------------------------------------------------------------------//
	//--------------- Raise objection and Drop objection method to avoid the hardcoded delay before $finish ---------------//
	//---------------------------------------------------------------------------------------------------------------------//


	//raise objection method which will increase the counter by 1 
	function void raise_objection(string name);
		counter++;
		$display("counter is incresed through raise objection from : %s : %0d",name,counter);
	endfunction

	//drop objection method which will decrease the counter by 1 
	function void drop_objection(string name);
		counter--;
		$display("counter is decread through drop objection from : %s : %0d",name,counter);
	endfunction 
	
endpackage

`endif 
