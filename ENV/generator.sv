//Generator class for half adder 
//randomize the information coming from transaction class and then put that information into mailbox 

`ifndef APB_GENERATOR_SV 
`define APB_GENERATOR_SV 

//Made generator class virtual so no one can change it 
virtual class generator;
	//as we want to randomize information coming from transaction class
	//handle of transaction class 
	transaction trans;
	
	//we want to put that randomized information into mailbox
	//mailbox declaration
	mailbox #(transaction) gen2drv;

	//method to connect mailbox 
	function void connect(mailbox #(transaction) gen2drv);
		this.gen2drv = gen2drv;
	endfunction

	//method in which data is randomize and put it in mailbox
	//make run mathod pure virtual so testcase writer must write it 
	pure virtual task run();
	/*	
		repeat(1) begin
			trans = new(); //object of transaction class
			trans.randomize() with {trans.ctrl_e == P_WRITE;}; //randomizing the information of the transaction class
			gen2drv.put(trans); //putting the information which is randomized into mailbox
			trans.disp("generator");
			@(item_done);
			$display("item done triggered");
		end 
	endtask 
	*/

	task put_and_wait();
		gen2drv.put(trans);
		raise_objection("Generator");
		trans.disp("Generator");
		@(item_done);
		drop_objection("Generator");
	endtask 

endclass

`endif 
