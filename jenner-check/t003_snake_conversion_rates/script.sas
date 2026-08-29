**SNAKE V5-BON-MCN-LGR 01-18-08.sas;
** re-do so survival uses only MCN detects for MCN-LGR survival - no harvest for chinook up there;
*** 04-04 - updated with SSH Z6 rates ;
title1 "SNAKE V5-BON-MCN-LGR 01-18-08.sas";

options linesize=133 pagesize=60 orientation=landscape;
	ods html style=journal;
	ods graphics on;
data harvest;
	length spp $20. spp_run $20. ;
	set sasdata.harvest_for_sas_fac_07;
	Z6_harv_rate = Harv_rate;
	drop Harv_rate stray_rate;
	if spp = "Chinook" and spp_run = "Summer" then delete;
	label Z6_harv_rate = "Z6 H_W Avg per Ellis 12-07 for SPC FAC  03-29 SSH 12-07 2007 FAC";
run;
proc sort;
	by spp spp_run adult_year;
run;
proc print;
	title2 "harvest_for_sas";
run;
      data upstream_at_BON_v3(label = "BON MCN WELLS LGR ETC V3 - SNAKE");
		length spp $20. spp_run $20. transported $16. ;
         	set sasdata.upstream_at_BON_v2;
		if adult_year >= 2001 ;
 		if region = "Snake" ;
	if species = "1" then spp = "Chinook";
	if species = "3" then spp = "Steelhead";
	if species = "3" then spp_run = "Summer" ;
	if species = "1" and run = "3" then spp_run = "Fall";
	if spp_run = "Fall" and rear_type = "W" then rear_type = "U" ;
	if species = "1" and (run = "1") then spp_run = "Spring";
	if species = "1" and (run = "2") then spp_run = "Spring";
/*** no unknowns - cant do harvest
	if species = "1" and run = "5" and coord_id = "DMM" then spp_run = "Spring-Summer";
	if species = "1" and run = "5" and coord_id = "EWB" then spp_run = "Spring-Summer";
***********/
	if spp_run = " " then spp_run = "Unknown";
	if spp_run = "Unknown" then delete;
	transported = "0 - Inriver" ;
	if rel_site = "LGRRBR" or gsbypasd = 1 or lgbypasd = 1 or lmbypasd = 1
		then transported = "1 - Transported" ;
	if lgracnt = 1 and mcnacnt = 0 then delete;  ** No fish missed at MCN for MCN-LGR ;
run;
proc sort;
	by spp spp_run transported ;
run;
proc summary data = upstream_at_BON_v3(where = (bonacnt = 1));
	by spp spp_run ;
	class adult_year life_stage rear_type transported;
	var bonacnt mcnacnt lgracnt;
	output out = Snake_at_BONA
	sum = bon_sum mcn_sum lgr_sum ;
run;
proc sort;
	by spp spp_run adult_year transported  rear_type ;
run;
data Snake_at_BONA;
	merge Snake_at_BONA
		harvest (drop = My_notes);
	by spp spp_run adult_year;
	if spp ne " ";
	if spp_run ne " ";
	if adult_year ne . ;
	if transported ne " ";
	if life_stage ne " " ;
	if rear_type = " ";  ** 01-18 - only H/W combos ;
	If spp = "Chinook" and spp_run ne "Fall" then Low_Col_Stray_Rate = 0.02;
	If spp = "Chinook" and spp_run = "Fall" then Low_Col_Stray_Rate = 0.033;
	If spp = "Steelhead" then do;
		if adult_year = 2002 then Low_Col_Stray_Rate = 0.038;
		if adult_year = 2003 then Low_Col_Stray_Rate = 0.053;
		if adult_year > 2003 then Low_Col_Stray_Rate = 0.047;
	end;
	label Low_Col_Stray_Rate = "Stray rate rer 12/2007 draft BiOp";
	drop _type_ _freq_ ;

***  bon_sum mcn_sum lgr_sum *** ;
	raw_bon_mcn_rate =   mcn_sum /  bon_sum ;
	label raw_bon_mcn_rate = "Unadjusted BON to MCN survival rate" ;
	format raw_bon_mcn_rate 6.4;

	raw_bon_lgr_rate =  lgr_sum /  bon_sum ;
	label raw_bon_lgr_rate = "Unadjusted BON to LGR survival rate" ;
	format raw_bon_lgr_rate 6.4;

	adj_bon_mcn_rate = raw_bon_mcn_rate / ( (1 - Low_Col_Stray_Rate ) * ( 1 - Z6_harv_rate ) ) ;
	label adj_bon_mcn_rate  = "BON to MCN, adjusted for harvest and straying estimates " ;
	format adj_bon_mcn_rate 6.4;

	adj_bon_lgr_rate = raw_bon_lgr_rate / ( (1 - Low_Col_Stray_Rate ) * ( 1 - Z6_harv_rate ) ) ;
	label adj_bon_lgr_rate  = "BON to LGR, adjusted for harvest and straying estimates " ;
	format adj_bon_lgr_rate 6.4;

	raw_mcn_lgr_rate =  lgr_sum /  mcn_sum ;
	label raw_mcn_lgr_rate = "MCN to LGR rate, no adjustments for harvest, straying";
	format raw_mcn_lgr_rate 6.4;
	drop more_notes;

run;
run;
proc print;
	title2 "Snake_at_BONA";
run;
proc export data= Snake_at_BONA replace
	dbms = csv
	outfile = "./Snake_BON_to_MCN_to_LGR_2008_01_18.csv";
run;
