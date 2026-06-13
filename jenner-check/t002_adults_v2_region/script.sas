*** adults V2.sas;

title1 "adults V2.sas";
***options obs=100000;
options linesize=133 pagesize=60 orientation=landscape;
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
