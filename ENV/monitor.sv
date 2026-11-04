`ifndef APB_MONITOR_SV 
`define APB_MONITOR_SV 

class monitor;

	virtual intf vintf; //handle of interface : virtual interface 
 
	transaction trans2; //handle of transaction class 
	transaction trans_funcov;
	//mailbox declaration
	//for transfer the information between monitor and reference model 
	mailbox #(transaction) mon_ref;

	//mailbox declaration 
	//for transfer the information between monitor and scoreboard
	mailbox #(transaction) mon_scr;

	//mailbox declaration 
	//for transfer the information from monitor to functional coverage 
	mailbox #(transaction) mon_funcov;

	//method to connect interface and both mailbox 
	function void connect(virtual intf vintf/*, mailbox #(transaction) mon_ref,*/, mailbox #(transaction) mon_scr, mailbox #(transaction) mon_funcov);
		this.vintf = vintf;
		//this.mon_ref = mon_ref;
		this.mon_scr = mon_scr;
		this.mon_funcov = mon_funcov;
	endfunction 

	task run();
		forever @(vintf.mon_cb) begin
			$display("Run method form MONITOR is started : %0t",$time);
			trans2 = new(); //object of transaction class
			trans_funcov = new();

			if(vintf.mon_cb.psel && vintf.mon_cb.penable && vintf.mon_cb.pready == 1) begin 
				//Passing the values which we get from the interface which is connected to the DUT 
				trans2.paddr = vintf.mon_cb.paddr;
				trans2.pwdata = vintf.mon_cb.pwdata;
				trans2.pwrite = vintf.mon_cb.pwrite;
				trans2.psel = vintf.mon_cb.psel;
				trans2.penable = vintf.mon_cb.penable;
				trans2.pready = vintf.mon_cb.pready;
				trans2.prdata = vintf.mon_cb.prdata;
				trans2.pslverr = vintf.mon_cb.pslverr;
			end 

			//decoding enum ctrl_e based on the values of pwrite 
    	$cast(trans2.ctrl_e,trans2.pwrite);
		
			trans2.disp("monitor");

			mon_scr.put(trans2); //put the information into the mailbox between monitor and scoreboard 
   		trans_funcov = new trans2; //shallow copy before putting into mailbox

			mon_funcov.put(trans_funcov); //put the information into the mailbox between monitor and functional coverage class 
			$display("Run method from MONITOR is completed : %0t",$time);
		end 
	endtask 

endclass 

`endif 
