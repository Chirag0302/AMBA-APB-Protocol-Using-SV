`ifndef APB_TOP_SV 
`define APB_TOP_SV 

`include "interface.sv"
`include "package.sv"
`include "../RTL/design.v"
import pkg::*;

module top;

	int wait_state;
	bit pclk = 1'b0;
  bit presetn;

	initial begin 
		forever #5 pclk = ~pclk;
	end 
	
	task reset_done();
		fork 
			forever@(reset_item_done) begin 
				reset();
			end 
		join_none 
	endtask 

	intf int_f(pclk,presetn); //handle of interface 

	task reset();
		presetn = 1'b0;
		#DELAY;
		presetn = 1'b1;
	endtask 

	test test_h; //handle of test class 

	APB_slave DUT (.pclk(pclk),
						.presetn(presetn),
						.pslverr(int_f.pslverr),
						.pready(int_f.pready),
						.prdata(int_f.prdata),
						.psel(int_f.psel),
						.penable(int_f.penable),
						.pwrite(int_f.pwrite),
						.paddr(int_f.paddr),
						.pwdata(int_f.pwdata)
						); //instanciate design code 

	initial begin
		$display("----- in valueplusargs ------");
	 	if($value$plusargs("WAIT=%0d",wait_state)) begin
	 		$display("waited for %0d",wait_state);
			DUT.WAIT_PR = wait_state; //back door access for assign value for wait state 
	 end 
	end 
	
	task run_test();
		test_h.build();
		test_h.connect(int_f);
		test_h.run();
	endtask 
		
	initial begin
		test_h = new(); //object of test class 
			reset_done();
			-> reset_item_done;
			fork
				run_test(); //call run method from test class 
				reset();	
			join
		wait(counter == 0);
		$display("objection counter : %0d",counter);
		#10;
		$finish;
	end 
	
endmodule 

`endif 


