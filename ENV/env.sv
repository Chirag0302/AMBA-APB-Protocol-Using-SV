`ifndef APB_ENVIRONMENT_SV
`define APB_ENVIRONMENT_SV 

class env;

	//virtual interface 
	virtual intf vintf;
	
	driver drv; //handle of driver class 
	generator gen; //handle of generator class  
	monitor mon; //handle of monitor class 
	scoreboard scr; //handle of scoreboard 
	func_covg funcov; //handle of functional coverage

  //method to build objects of every component 
	function void build();
		this.drv = new(); //object of driver class 
		this.mon = new(); //object of monitor class 
		this.scr = new(); //object of scoreboard 
		this.funcov = new(); //object of functional coverage 
	endfunction 

	//mailbox declaration : transfer information between generator and monitor  
	mailbox #(transaction) gen2drv = new();

	//mailobx declaration : transfer information between monitor and scoreboard	
	mailbox #(transaction) mon2scr = new();
	
	//mailbox declaration : transfer information from Monitor to functional coverage 
	mailbox #(transaction) mon2funcov = new();

	//connect all the mailbox and interface  
	function void connect (virtual intf int_f );
		this.vintf = int_f;
		gen.connect(gen2drv);
		drv.connect(vintf,gen2drv);
		mon.connect(vintf,mon2scr,mon2funcov);
		funcov.connect(vintf,mon2funcov);
		scr.connect(mon2scr);
	endfunction 

	//method where all the run method are called from the components 
	task run();
		fork
			gen.run();
			drv.run();
			mon.run();
			funcov.run();
		  scr.run();
		join_any
	endtask 

endclass 

`endif 
