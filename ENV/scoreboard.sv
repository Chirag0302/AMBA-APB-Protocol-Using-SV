`ifndef APB_SCOREBOARD_SV
`define APB_SCOREBOARD_SV 

class scoreboard;
	
	transaction trans_ref; //handle of transaction class : to get information from refrence model 
	transaction trans_mon; //handle of transaction class : to get information from monitor
	
	cvg_grp2_op cvg_prdata;
	//mailbox declaration :
	//for transfer information between monitor and scoreboard 
	mailbox #(transaction) mon_scr; 

	bit [`DATA_WIDTH-1:0] exp_rdata; //expected read data will generate by predictor 
	bit exp_pslverr; //expected slave error will generate by predictor 

	bit [`DATA_WIDTH-1:0] exp_mem_a [int]; //reference memory : using associative array 
	
	bit [`DATA_WIDTH-1:0] arr_exp_q [$:15]; //Depth will be 16 : from 0 to 15
	bit [`DATA_WIDTH-1:0] arr_act_q [$:15]; //Depth will be 16 : from 0 to 15 

	bit [`DATA_WIDTH-1:0] expected; //expected to store the expected value of read data 
	bit [`DATA_WIDTH-1:0] actual; //actual to store the actual value of read data 

	//method to coneect both mailbox 
	function void connect(mailbox #(transaction) mon_scr);
		this.mon_scr = mon_scr;
		cvg_prdata = new();
	endfunction

	//Method to mimic the behaviour of DUT 
	//Reference model 
	task predictor(transaction trans);
		$display("Predictor started at : %0t",$time);
		if(trans.psel && trans.penable && trans.pready == 1) begin 
			if(trans.pwrite == 1) begin 
				//$display("start writing data");
				exp_mem_a [trans.paddr] = trans.pwdata;
				//$display("Exp_mem_a : %p",exp_mem_a);
				//$display("Writing of data is completed");
			end 
			else begin
				//$display("start reading data");
				//$display("Exp_mem_a : %p",exp_mem_a);
				//$display("before read operation : %0d",exp_mem_a [trans.paddr]);
				exp_rdata = exp_mem_a [trans.paddr];
				//$display("exp_rdata : %0d",exp_rdata);
				//$display("reading of data is completed"); 
			end
		end
		else begin
			exp_rdata = 'd0;
		end

		if(trans.psel && trans.penable && trans.pready == 1) begin 
			if(trans.paddr > 5'b1_0100) begin 
				exp_pslverr = 1'b1;
			end 
		end
		else begin 
				exp_pslverr = 1'b0;
		end 
		$display("Predictor completed at : %0t",$time);
	endtask 

	task run();
		forever begin 
			$display("Run method from SCOREBOARD started at : %0t",$time);
			trans_mon = new();
			$display("start getting from monitor");
			mon_scr.get(trans_mon);
			raise_objection("Scoreboard");
			$display("get information from monitor");
			$display("trans_mon : %p",trans_mon);
			trans_ref = new trans_mon; //shallow copy of trans_mon which is coming from monitor into trans_ref to pass the function of predictor
			$display("----------------- will go inside predictor----------------------");
			predictor(trans_ref);
			$display("come out of predictor");

			//overriding the trans_ref read data and slave error with expected read data and expected slave error
			trans_ref.prdata = exp_rdata;
			trans_ref.pslverr = exp_pslverr;

			trans_ref.disp("ref model");

			//push into expected queue : trans_ref 
			//push into actual queue : trans_mon
			arr_exp_q.push_front(exp_rdata);
			arr_act_q.push_front(trans_mon.prdata);

			fork
				wait(arr_exp_q.size() != 0);
				wait(arr_act_q.size() != 0);
			join
			
			expected = arr_exp_q.pop_back();
			actual = arr_act_q.pop_back();

			if(expected == actual) begin
			  cvg_prdata.sample(trans_ref);
				$display("PRDATA CHECKER PASSED !!!");
			end 
			else begin
				$display("PRDATA CHECKER FAILED !!!");
			end 

			if(trans_mon.pslverr == trans_ref.pslverr) begin 
			  cvg_prdata.sample(trans_ref);
				$display("PSLVERR CHECKER PASSED !!!");
			end 
			else begin 
				$display("PSLVERR CHECKER FAILED !!!");
			end 

			drop_objection("Scoreboard");
			$display("Run method from SCOREBOARD completed at : %0t",$time);
		end 
	endtask 
endclass 

`endif 
