//Multiple write and then read Testcase 
//WRITE functionality : storing the randomized write address into queue 
//READ functionality : write a constraint in such a way that read address must be inside queue 
//So we can check that on which address we have written the data while reading from that location we get the same data 

class Multiple_write_read_test extends generator;

	int num_trans = no_transaction; //number of transaction testcase writer wants to do 
	int array_q [$:12]; //queue array to store the randomized write address 

	virtual task run();
		$display("Test case for Multiple Write and read test started at : %0t",$time);	
		repeat(1) begin
			//WRITE functionality 
			repeat(num_trans) begin 
				trans = new();
				if(!trans.randomize() with {trans.ctrl_e == P_WRITE;}) begin 
					$error("Randomization Failed !!!");
				end 
				array_q.push_back(trans.paddr); //storing the randomized write address into queue array 
				super.put_and_wait();
			end 
			//READ functionality 
			repeat(num_trans) begin 
				trans = new();
				if(!trans.randomize() with {trans.ctrl_e == P_READ; trans.paddr inside {array_q};})
					$error("Randomization Failed !!!");
				super.put_and_wait();
			end 
		end 
		$display("Test case for Multiple Write and read test completed at : %0t",$time);	
	endtask 
		
endclass

//approach : 1 
/*
whenever we are randomizing for WRITE only 
Will take one array_q
after randomization of WRITE : 
array_q.push_back(trans.wr_addr);

Then for READ 
We can just write the constraint similar to which we have written right now,
trans.rd_addr inside {trans.array_q};

So for this approach no need to add any post_randomization method inside Transaction class and no need of taking static queue array 
*/

//approach : 2 
/*
we can take one static queue array 
Go into transaction class and add post_randomize() method 
in which we'll just push_back value of wr_addr inside queue array 
and then while using READ functionality 
add constraint that trans.rd_addr inside queue array 
*/ 
