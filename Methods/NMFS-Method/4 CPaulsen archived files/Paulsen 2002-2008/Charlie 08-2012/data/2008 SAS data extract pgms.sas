*** adults at any ladder 1.sas;

title1 "D:\userfile\ptagis\sasdata\COMPASS upstream 2007\adults at any ladder 1.sas";
***options obs=100000;
options linesize=133 pagesize=60 orientation=landscape;
options sysprintfont = "SAS Monospace" regular 8;
libname sasdata "D:\userfile\ptagis\sasdata\COMPASS Upstream 2008-01-10";
libname mergdata "G:\";

      data sasdata.upstream_at_BON_v1(label = "BON, MCN, etc adult detects 01-10-2008 V1");
         	set mergdata.all_to_01_2008 (where = (bonacnt = 1 or mcnacnt = 1 or lgracnt = 1 or WELLSACNT = 1));
         	by tag_id;
          	if first.tag_id;
		adult_year = year (datepart( (max (obsdat8, obsdat9, obsdat10, obsdat27) ) ) );
		if adult_year < 2000 then delete;
		age_at_return = adult_year - migr_yr;
		if age_at_return >= 1 and age_at_return <= 7 ;
	label obsdat1 = "Date @ LGR Juv.";
	label obsdat2 = "Date @ Goose Juv.";
	label obsdat3 = "Date @ LOMO Juv.";
	label obsdat4 = "Date @ MCN Juv";
	label obsdat5 = "Date @ JDA juv";
	label obsdat6 = "Date @ BONN juv";
	label obsdat7 = "Date @ Towed array";
	label obsdat8 = "Date @ BON ladders";
	label obsdat9 = "Date @ LGR ladders";
	label obsdat10 = "Date @ MCN ladders";
	label obsdat11 = "Date @ Rocky reach juv";
	label obsdat12 = "Date @ Prosser adult/juv";
	label obsdat13    = " Date @ CATHAPCNT " ; 	   
	label obsdat14	= " Date @ CLARKAPCNT" ; 	   
	label obsdat15	= " Date @ CLEARWJCNT" ; 	   
	label obsdat16	= " Date @ EASTAPCNT" ; 	   
	label obsdat17	= " Date @ ICEHRACNT" ; 	   
	label obsdat18	= " Date @ JACKAPCNT" ; 	   
	label obsdat19	= " Date @ PRIESTACNT" ; 	   	   
	label obsdat20	= " Date @ RAPRAPCNT" ; 	   
	label obsdat21	= " Date @ RATTLEJCNT" ; 	   
	label obsdat22	= " Date @ ROCKYACNT" ; 	   	   
	label obsdat23	= " Date @ SALMONJCNT" ; 	   
	label obsdat24	= " Date @ SNAKEJCNT" ; 	   
	label obsdat25	= " Date @ TMUMATACNT" ; 	   
	label obsdat26	= " Date @ TMUMATJCNT" ; 	   
	label obsdat27	= " Date @ WELLSACNT" ; 	
	label lmbypasd = "1 if trans. at LOMO";
	label lmtoriv  = "1 if to river at LOMO";
	label mcbypasd = " 1 if trans at MCN";
	label mctoriv = " 1 if to river at MCN";
	label migr_yr = " Downstream migration year";
	label mor_in  = " 1 if mortality";
	label mort_date = " date of mortality";
	label mort_site = "Site of mortality";
	label priestjcnt = ">=1 if at Prist Juv.";
	label bonacnt = ">= 1 if at BON ladders";
	label recap_in = "1 if recap (distinct from OBS)";
	label rel_date = "Date of release, may not = tag_date";
	label tag_km   = "River KM of tagging";
	label tag_len  = "length @ tagging, mm";
	label tag_mon  = "Month of tagging";
	label tag_site = "site of tagging, may not = release site";
	label tag_wt        = "Weight at tagging, grams";
	label tagyear = "Year of tagging";
	label coord_id       = "Tagging coordinator";
	run;

proc contents ;
run;
proc means  n min mean max sum std;
run;
proc freq  ;
	tables adult_year age_at_return species rear_type run migr_yr tag_km
	site  coord_id;
run;

*** adults V2.sas;

title1 "D:\userfile\ptagis\programs\COMPASS Upstream 2008-01-10\adults V2.sas";
***options obs=100000;
options linesize=133 pagesize=60 orientation=landscape;
options sysprintfont = "SAS Monospace" regular 8;
libname sasdata "D:\userfile\ptagis\sasdata\COMPASS Upstream 2008-01-10";
	ods html style=journal;
	ods graphics on;

      data sasdata.upstream_at_BON_v2(label = "BON MCN WELLS LGR ETC");
         	set sasdata.upstream_at_BON_v1;
	length region $20. life_stage  $10. ;
		if species = "1" or species = "3" ; 
		if run = "1" or run= "2" or run = "3" or run = "5" ;
		if adult_year > 1999 ;
		if bonacnt > 0 ;
 		tag_km_1 = substr(tag_km, 1, 3);
		if tag_km_1 = "522" then region = "Snake";
		if tag_km_1 = "539" and region = " " then region = "Yakima";
		if tag_km_1 > "539" and region = " " then region = "Upper Col";
		if region = " " then delete;
		drop  tag_km_1 ;
		if age_at_return < 1 then delete;
		if age_at_return > 6 then delete;
		if age_at_return = 1 then life_stage = "Jack" ;
		else life_stage = "Adult";
	run;
proc sort;
	by region species run life_stage ;
run;
proc contents ;
run;
proc means  n min mean max sum std;
run;
proc freq  ;
	tables adult_year age_at_return species * run species * rear_type run migr_yr tag_km
	site  coord_id life_stage * region ;
run;

**SNAKE V5-BON-MCN-LGR 01-18-08.sas;
** re-do so survival uses only MCN detects for MCN-LGR survival - no harvest for chinook up there;
*** 04-04 - updated with SSH Z6 rates ;
title1 "D:\userfile\ptagis\programs\COMPASS Upstream 2008-01-10\SNAKE V5-BON-MCN-LGR 01-18-08.sas";

options linesize=133 pagesize=60 orientation=landscape;
options sysprintfont = "SAS Monospace" regular 8;
libname sasdata "D:\userfile\ptagis\sasdata\COMPASS Upstream 2008-01-10";
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
	outfile = "D:\userfile\ptagis\programs\COMPASS Upstream 2008-01-10\Snake_BON_to_MCN_to_LGR_2008_01_18.csv";
run;

**UC V5-BON-MCN 01-24-08.sas;
** re-do so survival uses only MCN detects for MCN-LGR survival - no harvest for chinook up there;
*** 04-04 - updated with SSH Z6 rates ;
title1 "D:\userfile\ptagis\programs\COMPASS Upstream 2008-01-10\UC V5-BON-MCN 01-24-08.sas";

options linesize=133 pagesize=60 orientation=landscape;
options sysprintfont = "SAS Monospace" regular 8;
libname sasdata "D:\userfile\ptagis\sasdata\COMPASS Upstream 2008-01-10";
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
      data upstream_at_BON_v3(label = "BON MCN WELLS LGR ETC V3 - UC");
		length spp $20. spp_run $20. transported $16. ;
         	set sasdata.upstream_at_BON_v2;
		if adult_year >= 2002 ;
 		if region = "Upper Col" ;
	if species = "1" then spp = "Chinook";
	if species = "3" then spp = "Steelhead";
	if species = "3" then spp_run = "Summer" ;
	if species = "1" and run = "3" then spp_run = "Fall";
	if spp_run = "Fall" and rear_type = "W" then rear_type = "U" ;
	if species = "1" and (run = "1") then spp_run = "Spring";
******below UC Only 01-24-08;
	if species = "1" and (run ne "1") then delete;
	if rear_type ne "H" then delete ; **UC ONLY **;
	if spp_run = " " then spp_run = "Unknown";
	if spp_run = "Unknown" then delete;
	transported = "0 - Inriver" ;
	if rel_site = "LGRRBR" or gsbypasd = 1 or lgbypasd = 1 or lmbypasd = 1  
		then transported = "1 - Transported" ;
***NOT FOR UC***	if lgracnt = 1 and mcnacnt = 0 then delete; 
run;
proc contents ;
run;
proc means  n min mean max sum std;
run;
proc freq  ;
	tables adult_year age_at_return spp * run spp * rear_type run migr_yr tag_km
	site  coord_id life_stage * region ;
run;
**** NOTE LEAVE TRANS REAR_TYPE IN  - EASIER FOR NOW BUT NO LGR **;
proc sort;
	by spp spp_run transported ;
run;
proc summary data = upstream_at_BON_v3(where = (bonacnt = 1));
	by spp spp_run ;
	class adult_year life_stage rear_type transported;
	var bonacnt mcnacnt ;
	output out = UC_at_BONA
	sum = bon_sum mcn_sum ;
run;
proc sort;
	by spp spp_run adult_year transported  rear_type ;
run;
data UC_at_BONA;
	merge UC_at_BONA 
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
/*******NOT FOR UC
	raw_bon_lgr_rate =  lgr_sum /  bon_sum ;
	label raw_bon_lgr_rate = "Unadjusted BON to LGR survival rate" ;
	format raw_bon_lgr_rate 6.4;
******************/
	adj_bon_mcn_rate = raw_bon_mcn_rate / ( (1 - Low_Col_Stray_Rate ) * ( 1 - Z6_harv_rate ) ) ;
	label adj_bon_mcn_rate  = "BON to MCN, adjusted for harvest and straying estimates " ;
	format adj_bon_mcn_rate 6.4;
/*******************************
	adj_bon_lgr_rate = raw_bon_lgr_rate / ( (1 - Low_Col_Stray_Rate ) * ( 1 - Z6_harv_rate ) ) ;
	label adj_bon_lgr_rate  = "BON to LGR, adjusted for harvest and straying estimates " ;
	format adj_bon_lgr_rate 6.4;

	raw_mcn_lgr_rate =  lgr_sum /  mcn_sum ;
	label raw_mcn_lgr_rate = "MCN to LGR rate, no adjustments for harvest, straying";
	format raw_mcn_lgr_rate 6.4;
*****************************/
	drop more_notes;

run;
run;
proc print;
	title2 "UC_at_BONA";
run;
proc export data= UC_at_BONA replace
	dbms = csv
	outfile = "D:\userfile\ptagis\programs\COMPASS Upstream 2008-01-10\UC_BON_to_MCN_2008_01_24.csv";
run;

