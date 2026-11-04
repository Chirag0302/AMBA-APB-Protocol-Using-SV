
`ifndef APB_DRIVER_SV
`define APB_DRIVER_SV 

class driver;

	virtual intf vintf; //handle of interface 
	
	transaction trans; //object of transaction class 

	mailbox #(transaction) gen2drv; //mailbox declaration 

	//method to connect mailbox 
	function void connect (virtual intf vintf,mailbox #(transaction) gen2drv);
		this.gen2drv = gen2drv;
		this.vintf = vintf;
	endfunction

	//method to get the information from the generator class 
	task initialization();
		$display("Reset stared at %0t",$time);
		vintf.drv_cb.paddr <= 'd0;
		vintf.drv_cb.pwdata <= 'd0;
		vintf.drv_cb.pwrite <= 1'b0;
		vintf.drv_cb.psel <= 1'b0;
		vintf.drv_cb.penable <= 1'b0;
		$display("Reset completed at %0t",$time);
	endtask 
	
	//method to drive inputs to DUT through interface 
	task drive_to_dut();
		$display("start driving to DUT at :%0t",$time);
		@(posedge vintf.pclk);
		vintf.drv_cb.paddr <= trans.paddr;
		vintf.drv_cb.pwdata <= trans.pwdata;
		vintf.drv_cb.pwrite <= trans.pwrite;
		vintf.drv_cb.psel <= 1'b1;
		//$display(" %0d : waiting for the clock",$time);
		@(posedge vintf.pclk);
		vintf.drv_cb.penable <= 1'b1;
		//$display(" %0d : waiting completed for the clock",$time);
		//$display(" value assigned : %0d",vintf.drv_cb.penable);
		wait(vintf.drv_cb.pready);
		vintf.drv_cb.penable <= 1'b0;
		$display("completed driving to DUT at : %0t",$time);
	endtask

	task run();
	 forever @(vintf.drv_cb) begin
	 	$display("Run method from DRIVER started at : %0t",$time);
		//trans = new(); //object of transaction class 
		gen2drv.get(trans); //get information from the mailbox
		raise_objection("Driver");
		 if(!vintf.presetn) begin 
				   initialization();	
     end
		 wait(vintf.presetn)
			drive_to_dut();
			trans.disp("driver");
			drop_objection("Driver");
			$display("Run method from DRIVER completed at : %0t",$time);
			-> item_done;
		end 
	endtask 

endclass 

`endif 
