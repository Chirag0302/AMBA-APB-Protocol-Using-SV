//Boundary check test : no of transaction varies : depends on testcase writer
//as designer has set that if address is greater than 20 then it will assert pslverr signal 
//so here we are not checking for pslverr : so address will be either 0 or 20

class Check_boundary_test extends generator;

	int num_trans = no_transaction; //number of transaction testcase writer wants to do 
	bit [`ADDR-1:0] addr; //to store the write address so we can read from that address only 
	
	virtual task run();
		$display("Test case for boundary check started at : %0t",$time);
		repeat(num_trans) begin 
			//WRITE functionality 
			trans = new();
			if(!trans.randomize() with {trans.ctrl_e == P_WRITE; 
																	trans.paddr inside {5'b00000, 5'b10100};
																 }) begin 
				$error("Randomization Failed");
			end 
			addr = trans.paddr;
			super.put_and_wait();
	
			//READ functionality 
			trans = new();
			trans.pwdata.rand_mode(0);
			if(!trans.randomize() with {trans.ctrl_e == P_READ; 
																	trans.paddr == addr;
																	}) begin 
				$error("Randomization Failed !!!");
			end 
			super.put_and_wait();
		end 
		$display("Test case for boundary check completed at : %0t",$time);
	endtask 
endclass 
