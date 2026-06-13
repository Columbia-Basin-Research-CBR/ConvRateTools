/* autoexec for t003 — caps obs at the unlicensed tier and supplies the two
 * inputs the SNAKE conversion-rate program reads:
 *
 *   sasdata.harvest_for_sas_fac_07  Zone-6 harvest rates by species / run /
 *                                   year (the program renames Harv_rate to
 *                                   Z6_harv_rate and drops stray_rate).
 *   sasdata.upstream_at_BON_v2      adult detections classified to region
 *                                   (output of program 2). The SNAKE step
 *                                   keeps region = "Snake" and aggregates
 *                                   BON / MCN / LGR ladder counts.
 *
 * Column shapes match exactly what program 3 consumes. The keys that join
 * the two datasets (spp / spp_run / adult_year) are arranged so the MERGE
 * yields non-missing harvest and stray rates and the survival-rate
 * divisions produce finite values. */
options obs=100;

libname sasdata ".";

data sasdata.harvest_for_sas_fac_07;
  length spp $20 spp_run $20 My_notes $40;
  input spp $ spp_run $ adult_year Harv_rate stray_rate My_notes $;
datalines;
Chinook Spring 2001 0.04 0.01 spring_chinook
Chinook Spring 2002 0.05 0.01 spring_chinook
Chinook Fall 2002 0.12 0.02 fall_chinook
Steelhead Summer 2002 0.08 0.02 summer_sthd
Steelhead Summer 2003 0.07 0.02 summer_sthd
Chinook Summer 2002 0.06 0.01 drop_me_summer
;
run;

data sasdata.upstream_at_BON_v2(label = "BON MCN WELLS LGR ETC");
  length tag_id $14 species $1 run $1 rear_type $1 region $20 life_stage $10
         rel_site $8 ;
  input tag_id $ species $ run $ rear_type $ adult_year region $ life_stage $
        bonacnt mcnacnt lgracnt rel_site $ gsbypasd lgbypasd lmbypasd ;
datalines;
3D9.1A01 1 1 W 2001 Snake Adult 1 1 1 LGRRBR 0 0 0
3D9.1A02 1 1 W 2001 Snake Adult 1 1 0 GOAVRT 0 0 0
3D9.1A03 1 1 W 2002 Snake Adult 1 1 1 LGRRBR 0 0 0
3D9.1A04 1 1 H 2002 Snake Adult 1 1 1 LGRRBR 0 0 0
3D9.1A05 1 3 W 2002 Snake Adult 1 1 1 LGRRBR 0 0 0
3D9.1A06 1 3 H 2002 Snake Adult 1 1 0 LGRRBR 0 0 0
3D9.1A07 3 3 W 2002 Snake Adult 1 1 1 LGRRBR 0 0 0
3D9.1A08 3 3 H 2002 Snake Adult 1 1 1 LGRRBR 0 0 0
3D9.1A09 3 3 W 2003 Snake Adult 1 1 1 LGRRBR 0 0 0
3D9.1A10 3 3 H 2003 Snake Adult 1 1 0 LGRRBR 0 0 0
3D9.1A11 1 1 W 2001 Snake Adult 1 0 0 GOAVRT 0 0 0
3D9.1A12 1 1 H 2002 Snake Jack  1 1 1 LGRRBR 0 0 0
;
run;
