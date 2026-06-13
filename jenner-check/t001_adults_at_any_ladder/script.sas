*** adults at any ladder 1.sas;

title1 "adults at any ladder 1.sas";
***options obs=100000;
options linesize=133 pagesize=60 orientation=landscape;

      data sasdata.upstream_at_BON_v1(label = "BON, MCN, etc adult detects 01-10-2008 V1");
         	set mergdata.all_to_01_2008 (where = (bonacnt = 1 or mcnacnt = 1 or lgracnt = 1 or WELLSACNT = 1));
         	by tag_id;
          	if first.tag_id;
		adult_year = year (datepart( (max (obsdat8, obsdat9, obsdat10, obsdat27) ) ) );
		if adult_year < 2000 then delete;
		age_at_return = adult_year - migr_yr;
		if age_at_return >= 1 and age_at_return <= 7 ;
	label obsdat8 = "Date @ BON ladders";
	label obsdat9 = "Date @ LGR ladders";
	label obsdat10 = "Date @ MCN ladders";
	label obsdat27	= " Date @ WELLSACNT" ;
	label migr_yr = " Downstream migration year";
	label bonacnt = ">= 1 if at BON ladders";
	label tag_km   = "River KM of tagging";
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
