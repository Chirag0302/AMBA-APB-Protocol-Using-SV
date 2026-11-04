//Sanity Testcase : no of transaction must be 1 to check sanity 
//Back to Back write read : no of transaction varies : depends on testcase writer 

class Sanity_test extends generator;

	int num_trans = no_transaction; //number of transaction testcase writer wants to do 
	bit [`ADDR-1:0] addr; //to store the write address so we can read from that address only 

	virtual task run();
		$display("Test case for Sanity test started at : %0t",$time);	
		repeat(num_trans) begin 
			//WRITE functionality 
			trans = new();
			if(!trans.randomize() with {trans.ctrl_e == P_WRITE;}) begin 
				$error("Randomization Failed !!!");
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
		$display("Test case for Sanity test completed at : %0t",$time);	
	endtask 

endclass 
