class func_covg;

	transaction trans;

	virtual intf vintf;

	mailbox #(transaction) mon_funcov;

	function void connect(virtual intf vintf, mailbox #(transaction) mon_funcov);
		this.mon_funcov = mon_funcov;
		this.vintf = vintf;
	endfunction

	//Embedded covergroup 
	//We can call sample method of this covergroup in this class only 
	covergroup cvg_grp;

		//When true, coverage information for this covergroup instance shall be saved in the coverage database and included in the coverage report. 
		//When false, implementations are not required to save instance-specific information. 
		option.per_instance = 1;

		penable_cvg : coverpoint trans.penable
		{
			option.comment = "Coverpoint for penable which will check transition of penable signal from 0 to 1 and 1 to 0";
			bins penable_0to1 = (0 => 1);
			bins penable_1to0 = (1 => 0);
		}

		pwrite_cvg : coverpoint trans.pwrite
		{
			option.comment = "Coverpoint for pwrite which will check transition of penable signal from 0 to 1 and 1 to 0";
			bins pwrite_0to1 = (0 => 1);
			bins pwrite_1to0 = (1 => 0);
		}
	
		pready_cvg : coverpoint trans.pready
		{
			option.comment = "Coverpoint for pready which will check transition of penable signal from 0 to 1 and 1 to 0";
			bins pready_0to1 = (0 => 1);
			bins pready_1to0 = (1 => 0);
		}

		coverpoint_paddr : coverpoint trans.paddr
		{
			option.comment = "Coverpoint for paddr which is divided into 3 ranges : min, mid and max and for minimum and maximum range we have taken separate bin low_high";
			bins paddr_min = {[5'd1:5'd11]};
			bins paddr_mid = {[5'd12:5'd21]};
			bins paddr_max = {[5'd22:5'd31]};
			bins paddr_low_high[] = {5'd0,5'd20};
		}
	
		coverpoint_pwdata : coverpoint trans.pwdata
		{
			option.comment = "Coverpoint for pwdata is divided into ranges. So it will automatically divided into three ranges";
			bins pwdata[3] = {[1:$]};
		}
	
	coverpoint_prdata : coverpoint trans.prdata
		{
			option.comment = "Coverpoint for prdata is divided into ranges. So it will automatically divided into three ranges";
			bins prdata[3] = {[1:$]};
		}


		coverpoint_Back_to_Back : coverpoint trans.ctrl_e
		{
			option.comment = "Coverpoint to check back to back write read, back to back write and back to back read functionality";
			bins back2back_write_read = (P_WRITE => P_READ);
			bins back2back_write = (P_WRITE => P_WRITE);
			bins back2back_read = (P_READ => P_READ);
		}

		//Implicit bin for enum ctrl_e
		coverpoint_ctrl_e : coverpoint trans.ctrl_e;
		
		//cross coverage 1 : cross_write : between paddr and pwdata 
		//cross coverage 2 : cross_read : between paddr and prdata 
		cross_write : cross coverpoint_paddr,coverpoint_pwdata;
		cross_read : cross coverpoint_paddr,coverpoint_prdata;

		coverpoint_reset_check : coverpoint trans.prdata iff(vintf.presetn == 0)
		{
			option.comment = "Coverpoint to check reset functionality using wildcard bins";
			wildcard bins reset_check = (32'h????? => 32'd0);
		}


	endgroup


	function new();
		cvg_grp = new();
//		cvg_grp2_op = new();
	endfunction

	task run();
		forever begin
			trans = new();
			mon_funcov.get(trans);
			cvg_grp.sample();
		end
	endtask 

endclass 


//Generic Covergroup 
//We can take instance of Generic covergroup and then sample this anywhere we want 
covergroup cvg_grp2_op with function sample(transaction trans);

		option.per_instance = 1;

		coverpoint_prdata_op : coverpoint trans.prdata
		{
			option.comment = "Coverpoint for prdata is divided into ranges. So it will automatically divided into three ranges";
			bins prdata[3] = {[1:$]};
		}

			pslverr_cvg : coverpoint trans.pslverr
		{
			option.comment = "Coverpoint for pslverr which will check transition of penable signal from 0 to 1 and 1 to 0";
			bins pslverr_0to1 = (0 => 1);
			bins pslverr_1to0 = (1 => 0);
		}

	endgroup 


