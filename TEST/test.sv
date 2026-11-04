`ifndef APB_TEST_SV
`define APB_TEST_SV

class test;
	
	virtual intf int_f; //handle of interface 
	
	env env_h = new(); //object of environment class 
	
//	int wait_state = 0;
	
	//testcases
	Sanity_test sanity_test_1_h;
	Sanity_test bck2bck_wr_h1;
	Check_boundary_test check_boundary_h;
	Multiple_write_read_test mul_write_read_h;
	check_error_signal_test error_check_h;

	Sanity_test sanity_test_2_h;
	Sanity_test bck2bck_wr_h2;
	Check_boundary_test check_boundary_h2;
	Multiple_write_read_test mul_write_read_h2;
	check_error_signal_test error_check_h2;

	in_between_reset_test reset_check_h;

	//method to build object 
	function void build();
		env_h.build(); //call build method of environment class to connect all components 
	endfunction 

	//connect interface with virtual interface 
	virtual function void connect(virtual intf int_f);

		$display("-----------------------------------------------------------------------------------------------------------------------");
		$display("                                     SANITY TEST WITHOUT WAIT                                                          ");
		$display("-----------------------------------------------------------------------------------------------------------------------");
		if($test$plusargs("SANITY_TEST")) begin
			no_transaction = 1;
			sanity_test_1_h = new();
			env_h.gen = sanity_test_1_h;
		end

		$display("-----------------------------------------------------------------------------------------------------------------------");
		$display("                                     CHECK BOUNDARY ADDRESS                                                            ");
		$display("-----------------------------------------------------------------------------------------------------------------------");
		if($test$plusargs("CHECK_BOUNDARY_WITHOUT_WAIT")) begin
			no_transaction = 20;
			check_boundary_h = new();
			env_h.gen = check_boundary_h;
		end

		$display("-----------------------------------------------------------------------------------------------------------------------");
		$display("                                     BACK TO BACK WRITE READ WITHOUT WAIT                                              ");
		$display("-----------------------------------------------------------------------------------------------------------------------");
		if($test$plusargs("BACK_TO_BACK_WRITE_READ_WITHOUT_WAIT")) begin
			no_transaction = 20;
			bck2bck_wr_h1 = new();
			env_h.gen = bck2bck_wr_h1;
		end 

		$display("-----------------------------------------------------------------------------------------------------------------------");
		$display("                                     MULTIPLE WRITE READ WITHOUT WAIT                                                  ");
		$display("-----------------------------------------------------------------------------------------------------------------------");
		if($test$plusargs("MULTIPLE_WRITE_READ_WITHOUT_WAIT")) begin
			no_transaction = 20;
			mul_write_read_h = new();
			env_h.gen = mul_write_read_h;
		end 

		$display("-----------------------------------------------------------------------------------------------------------------------");
		$display("                                        CHECK ERROR WITHOUT WAIT                                                       ");
		$display("-----------------------------------------------------------------------------------------------------------------------");
		if($test$plusargs("ERROR_CHECK_WITHOUT_WAIT")) begin
			no_transaction = 20;
			error_check_h = new();
			env_h.gen = error_check_h;
		end
		
		$display("-----------------------------------------------------------------------------------------------------------------------");
		$display("                                           IN BETWEEN RESET CHECK                                                      ");
		$display("-----------------------------------------------------------------------------------------------------------------------");
		if($test$plusargs("IN_BETWEEN_RESET_CHECK")) begin
			no_transaction = 15;
			reset_check_h = new();
			env_h.gen = reset_check_h;
		end

		$display("-----------------------------------------------------------------------------------------------------------------------");
		$display("                                        SANITY TEST WITH WAIT                                                          ");
		$display("-----------------------------------------------------------------------------------------------------------------------");
		if($test$plusargs("SANITY_TEST_WITH_WAIT")) begin 
				no_transaction = 1;
				sanity_test_2_h = new();
				env_h.gen = sanity_test_2_h;      
		end

		$display("-----------------------------------------------------------------------------------------------------------------------");
		$display("                                     CHECK BOUNDARY ADDRESS WITH WAIT                                                  ");
		$display("-----------------------------------------------------------------------------------------------------------------------");
		if($test$plusargs("CHECK_BOUNDARY_WITH_WAIT")) begin
			no_transaction = 20;
			check_boundary_h2 = new();
			env_h.gen = check_boundary_h2;
		end

		$display("-----------------------------------------------------------------------------------------------------------------------");
		$display("                                      MULTIPLE WRITE READ WITH WAIT                                                    ");
		$display("-----------------------------------------------------------------------------------------------------------------------");
		if($test$plusargs("MULTIPLE_WRITE_READ_WITH_WAIT")) begin
			no_transaction = 20;
			mul_write_read_h2 = new();
			env_h.gen = mul_write_read_h2;
		end 

		$display("-----------------------------------------------------------------------------------------------------------------------");
		$display("                                     BACK TO BACK WRITE READ WITH WAIT                                                 ");
		$display("-----------------------------------------------------------------------------------------------------------------------");
		if($test$plusargs("BACK_TO_BACK_WRITE_READ_WITH_WAIT")) begin
			no_transaction = 20;
			bck2bck_wr_h2 = new();
			env_h.gen = bck2bck_wr_h2;
		end

		$display("-----------------------------------------------------------------------------------------------------------------------");
		$display("                                        CHECK ERROR WITH WAIT                                                          ");
		$display("-----------------------------------------------------------------------------------------------------------------------");
		if($test$plusargs("ERROR_CHECK_WITH_WAIT")) begin
			no_transaction = 20;
			error_check_h2 = new();
			env_h.gen = error_check_h2;
		end



		env_h.connect(int_f); //call connect method of environment class to connect virtual interface and mailbox 
	endfunction 

	//env h1 = new(); //object of environment class 

	task run();
		//h1.connect(int_f); //call connect method from environment 
		env_h.run(); //call run method from environment 
	endtask 

endclass

`endif
