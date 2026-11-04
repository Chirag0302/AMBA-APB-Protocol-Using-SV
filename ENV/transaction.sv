`ifndef APB_TRANSACTION_SV
`define APB_TRANSACTION_SV 

/*
PSLVERR : Output of slave 
PREADY : Output of slave 
PRDATA : Output of slave

PADDR : input to the slave 
PWDATA : input to the slave 
PSELx : input to the slave 
PENABLE : input to the slave 
PWRITE : input to the slave 

PCLK : Global signal : from TOP
PRESETn : Global signal : from TOP 
*/

typedef enum bit {P_READ=0,P_WRITE} control; //functionality of FIFO 
//1'b0 : P_READ = 0 : PWRITE = 0 : for Read Transfer 
//1'b1 : P_WRITE = 1 : PWRITE = 1 : for Write Transfer 
class transaction;

	rand control ctrl_e;

	//inputs which we want to randomize throught generator and pass to DUT through driver
	bit pslverr;
	bit pready;
	bit [(`DATA_WIDTH-1):0] prdata;
	
	rand bit [(`ADDR-1):0] paddr;
	rand bit [(`DATA_WIDTH-1):0] pwdata;

	bit psel;
	bit penable;
	bit pwrite;


	function void post_randomize();
		$cast(pwrite,ctrl_e);
		//pwrite = 1'b1;
	endfunction 
	
	//how much design specs are observed validated and tested // input drive and output recevie observer checker //test  
	
	function void disp(string name);
		$display("");
		$display("------------------------------------------");
		$display("                   %s                     ",name);
		$display("------------------------------------------");
    $display("|   Name    |     Data     |   Time   |" );
    $display("------------------------------------------");
    $display("| function  |\t\t%0s\t\t|   %4t   |",this.ctrl_e,$time);
    $display("| PADDR     |\t\t%3d\t\t|   %4t   |",this.paddr,$time);
    $display("| PWRITE    |\t\t%3d\t\t|   %4t   |",this.pwrite,$time);
    $display("| PWDATA    |\t\t%3d\t\t|   %4t   |",this.pwdata,$time);
    $display("| PSEL      |\t\t%3d\t\t|   %4t   |",this.psel,$time);
    $display("| PENABLE   |\t\t%3d\t\t|   %4t   |",this.penable,$time);
    $display("| PREADY    |\t\t%3d\t\t|   %4t   |",this.pready,$time);
    $display("| PRDATA    |\t\t%3d\t\t|   %4t   |",this.prdata,$time);
    $display("| PSLVERR   |\t\t%3d\t\t|   %4t   |",this.pslverr,$time);
    $display("------------------------------------------");
    	
	endfunction 

endclass 

`endif 
