`ifndef APB_INTERFACE_SV
`define APB_INTERFACE_SV 

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

`define check_unknown_signal(SIGNAL) \
	assert property (not_unknown_signal(SIGNAL)) $info (`"SIGNAL is not unknown during transfer`"); \
	else $error (`"SIGNAL is unknown during trasnfer`");

`include "define.sv"
interface intf(input bit pclk,input bit presetn);
	
	//declaration of signals
	logic pslverr; //slave error signal 
	logic pready; //ready signal 
	logic [(`DATA_WIDTH-1):0] prdata; //read data 
	logic psel; //slave select signal 
	logic penable; //enable signal 
	logic pwrite; //write signal : if pwrite=1 write transfer : if pwrite=0 read transfer 
	logic [(`ADDR-1):0] paddr; //address 
	logic [(`DATA_WIDTH-1):0] pwdata; //write data 

	//clocking block for driver 
	//paddr, pwdata, psel, penable, pwrite it will be input for DUT because it will pass to DUT through interface 
	//so it will be output of driver and input of DUT 
	clocking drv_cb @(posedge pclk);
		default input #1 output #1;
		output paddr;
		output pwdata;
		output psel;
		output penable;
		output pwrite;
		input pready;
	endclocking 

	//clocking block for monitor 
	//All signals as an input because everything will be sampled by monitor 
	clocking mon_cb @(posedge pclk);
		default input #0 output #1;
		input paddr;
		input pwdata;
		input psel;
		input penable;
		input pwrite;
		input prdata;
		input pready;
		input pslverr;
	endclocking

	//modport for RTL to provide the direction accroding to the RTL 
	modport DRIVER (clocking drv_cb);

	//modport for TB to provide the direction according to the Testbench 
	modport MONITOR (clocking mon_cb);

	//--------------------------------------------------------------------------------------------------------------------------//
	//------------------------------------------ ASSERTIONS FOR APB PROTOCOL ---------------------------------------------------//
	//--------------------------------------------------------------------------------------------------------------------------//

	//Property to check whether all signals are stable or not during the PENABLE asserted : Transition from SETUP PHASE TO ACCESS PHASE  
	property stable_signal_during_setup2access_phase;
		@(posedge pclk) disable iff (!presetn)
			$rose(penable) |-> $stable(paddr) ##0 $stable(pwdata) ##0 $stable(pwrite) ##0 $stable(psel) throughout (!pready);
	endproperty

	assert property (stable_signal_during_setup2access_phase) 
		$info ("After PENABLE asserted PADDR, PWRITE, PWDATA, PSEL are stable till the PREADY is asseted");
	else 
		$error ("After PENABLE asserted PADDR, PWRITE, PWDATA, PSEL are not stable till the PREADY is asserted");

	//Property to check whether any signal goes unknown (x or z) during the transfer 
	property not_unknown_signal (signal); 
		@(posedge pclk) disable iff (!presetn) 
			!$isunknown(signal);
	endproperty

	psel_unknown_check : `check_unknown_signal(psel);
	penable_unknown_check : `check_unknown_signal(penable);
	pready_unknown_check : `check_unknown_signal(pready);
	pslverr_unknown_check : `check_unknown_signal(pslverr);
	pwrite_unknown_check : `check_unknown_signal(pwrite);
	paddr_unknown_check : `check_unknown_signal(paddr);
	pwdata_unknown_check : `check_unknown_signal(pwdata);
	prdata_unknown_check : `check_unknown_signal(prdata);

	//---------------------------------------------------------------------------------------------------------------------------//
	//-------------------------------- made sequence according to the state diagram of APB Protocol -----------------------------//
	//---------------------------------------------------------------------------------------------------------------------------//
	
	//sequence for IDEL PHASE :  where PSEL is LOW 
	sequence idel_phase;
		!psel;
	endsequence 

	//sequence for SETUP PHASE : where PSEL is HIGH but PENABLE is LOW 
	sequence setup_phase; 
		psel && !penable; 
	endsequence 

	//sequence for ACCESS PHASE with wait state : where PSEL is HIGH, PENABLE is HIGH but PREADY should not be asserted so it is LOW 
	sequence access_phase_with_wait;
		psel && penable && !pready;
	endsequence 

	//sequence for ACCESS PHASE without wait state : where PSEL is HIGH, PENABLE is HIGH and PREADY is also HIGH  
	sequence access_phase_without_wait;
		psel && penable && pready;
	endsequence 

	//----------------------------------------------------------------------------------------------------------------------------//
	//------------------- check the transition from each state according to the state diagram of APB Protocol --------------------//
	//----------------------------------------------------------------------------------------------------------------------------//

	//property for check that PSEL is asserted and after one clock cycle PENABLE is asserted 
	property penable_asserted;
		@(posedge pclk) disable iff (!presetn) 
			first_match ($rose(psel)) |=> penable;
	endproperty 

	assert property (penable_asserted) 
		$info ("PENABLE is asserted after one clock cycle of PSEL");
	else 
		$error ("PENABLE is not asserted after one clock cycle of PSEL");

	//Property for IDEL PHASE : state transition should be happen from IDEL PHSE to IDEL PHASE or IDEL PHASE to SETUP PHASE 
	property check_idel_phase;
		@(posedge pclk) disable iff (!presetn) 
			idel_phase |=> idel_phase or setup_phase;
	endproperty

	assert property (check_idel_phase) 
		$info ("Asssertion Targeted for PSEL : As Transfer is there, PSEL is asserted");
	else 
		$error ("Assertion Targated for PSEL : PSEL is not asserted");

	//Property for SETUP PHASE : state transition should be happen from SETUP PHASE to ACCESS PHASE without wait or ACCESS PHASE with wait
	//As there in no specified in Specification that till how much clock cycle transfer can go to wait state so here I specified that till 10 
	//clock cycles only trasfer can go into wait state 
	property penable_pready;
		@(posedge pclk) disable iff (!presetn) 
			$rose(penable) |=> ##[0:10] pready;
	endproperty 
	
	assert property (penable_pready) 
		$info ("Assertion Targated for PREADY : PREADY is asserted after PENABLE is asserted");
	else 
		$error ("Assertion Targated for PREADY : PREADY is not asserted after PENABLE is asserted");

	//Property for ACCESS PHASE without wait : state transition should be happen from ACCESS PHASE without wait to IDEL PHASE or SETUP PHASE 
	property check_access_phase_without_wait;
		@(posedge pclk) disable iff (!presetn)
			access_phase_without_wait |=> idel_phase or setup_phase;
	endproperty 

	assert property (check_access_phase_without_wait)
		$info ("APB_03 and APB_05  || If Transfer : Transition from ACCESS PHASE WITHOUT WAIT to SETUP PHASE || If no Tranfer : Transition from ACCESS PHASE WITHOUT WAIT to IDEL PHASE");
	else 
		$error ("PROTOCOL VIOLATION : APB_03 and APB_05 || Transition From ACCESS PHASE WITHOUT WAIT to ACCESS PHASE WITHOUT WAIT or to SETUP PHASE is not happen");

	//Property to check that whenever PREADY is asserted on the next clock cycle PENABLE must be deasserted  
	property pready_penable;
		@(posedge pclk) disable iff (!presetn)
			$rose(pready) |=> $fell(penable);
	endproperty 

	assert property (pready_penable)
		$info ("Assertion Targated for PENABLE : After one clock cycle of PREADY -> PENABLE is deasserted");
	else 
		$info ("Assertion Targated for PENABLE : After one clock cycle of PREADY -> PENABLE is not deasserted");
	
	//Property to check reset whenever presetn is active low : psel, penable and pwrite should be LOW and paddr and pwdata should be 0. 
	//As as per the design specifications reset is synchronous so will check all the signal on next edge of clock 
	property check_reset;
		@(posedge pclk)
			(!presetn) |=> ((!psel) ##0 (!penable) ##0 (!pwrite) ##0 (paddr==0) ##0 (pwdata==0));
	endproperty 

	assert property (check_reset)
		$info ("APB_07 || Active low reset working perfectly : psel, penable, paddr and pwdata are zero");
	else 
		$error("PROTOCOL VIOLATION : APB_07 || Active low reset is not working perfectly");

	//To keep a count of the number of times the property PASS or FAIL
	cover property (stable_signal_during_setup2access_phase);
	
	cover property (not_unknown_signal(psel));
	cover property (not_unknown_signal(penable));
	cover property (not_unknown_signal(pready));
	cover property (not_unknown_signal(pwrite));
	cover property (not_unknown_signal(pslverr));
	cover property (not_unknown_signal(paddr));
	cover property (not_unknown_signal(pwdata));
	cover property (not_unknown_signal(prdata));
	
	cover property (penable_asserted);
	cover property (check_idel_phase);
	cover property (penable_pready);
	cover property (check_access_phase_without_wait);
	cover property (pready_penable);
	cover property (check_reset);
	
endinterface 
`endif 
