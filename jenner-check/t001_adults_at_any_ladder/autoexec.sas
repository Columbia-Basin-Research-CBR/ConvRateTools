/* autoexec for t001 — caps obs at the unlicensed tier and creates the
 * PTAGIS-shaped source that the original program reads from
 * mergdata.all_to_01_2008. Columns and types match exactly what
 * "adults at any ladder 1" consumes: tag_id (BY var), the obsdat*
 * detection datetimes, the per-site adult-count flags, plus the
 * migration / tagging / biological fields used downstream. */
options obs=100;

libname mergdata ".";
libname sasdata ".";

data mergdata.all_to_01_2008;
  length tag_id $14 species $1 run $1 rear_type $1 tag_km $12
         site $8 coord_id $8 rel_site $8 mort_site $8;
  format obsdat8 obsdat9 obsdat10 obsdat27 mort_date datetime20.;
  input tag_id $ species $ run $ rear_type $ migr_yr
        bonacnt mcnacnt lgracnt wellsacnt priestjcnt
        obsdat8_dt :datetime20. obsdat9_dt :datetime20.
        obsdat10_dt :datetime20. obsdat27_dt :datetime20.
        gsbypasd lgbypasd lmbypasd mcbypasd lmtoriv mctoriv
        recap_in mor_in tag_km $ site $ coord_id $ rel_site $
        tag_km_num tag_len tag_mon tag_wt tagyear ;
  obsdat8  = obsdat8_dt;
  obsdat9  = obsdat9_dt;
  obsdat10 = obsdat10_dt;
  obsdat27 = obsdat27_dt;
  drop obsdat8_dt obsdat9_dt obsdat10_dt obsdat27_dt;
datalines;
3D9.1BF22A1 1 1 W 2003 1 1 0 0 0 01JUL2005:08:00:00 . . . 0 0 0 0 0 0 0 0 522.001 LGR  DMM LGRRBR 522.001 145 5 22 2003
3D9.1BF22A1 1 1 W 2003 1 1 0 0 0 02JUL2005:09:00:00 . . . 0 0 0 0 0 0 0 0 522.001 LGR  DMM LGRRBR 522.001 145 5 22 2003
3D9.1BF22A2 1 1 W 2003 1 1 1 0 0 04JUL2005:08:30:00 06JUL2005:10:00:00 . . 0 0 0 0 0 0 0 0 522.014 LGR  DMM LGRRBR 522.014 150 5 23 2003
3D9.1BF22A3 3 3 H 2004 1 1 0 0 0 12AUG2006:07:00:00 . . . 0 0 0 0 0 0 0 0 539.050 MCN  EWB ROCKRR 539.050 220 4 110 2004
3D9.1BF22A4 1 1 H 2002 1 0 0 0 0 21JUN2004:06:00:00 . . . 0 1 0 0 0 0 0 0 539.100 PRD  EWB PRDRBR 539.100 160 5 30 2002
3D9.1BF22A5 1 2 W 2003 1 1 1 0 0 28JUN2005:05:30:00 30JUN2005:11:00:00 . . 0 0 0 0 0 0 0 0 522.300 LGR  DMM LGRRBR 522.300 152 5 25 2003
3D9.1BF22A6 3 3 W 2004 1 1 0 0 0 03SEP2006:09:30:00 . . . 0 0 0 0 0 0 0 0 540.500 MCN  EWB MCNRBR 540.500 215 4 105 2004
3D9.1BF22A7 1 3 W 2002 1 1 0 0 0 18OCT2004:14:00:00 . . . 0 0 0 0 0 0 0 0 522.700 LGR  DMM LGRRBR 522.700 175 6 60 2002
3D9.1BF22A8 1 1 W 2005 1 1 1 0 0 09JUL2007:07:45:00 11JUL2007:08:15:00 . . 0 0 0 0 0 0 0 0 522.900 LGR  DMM LGRRBR 522.900 148 5 21 2005
3D9.1BF22A9 3 3 H 2003 1 1 0 0 0 25AUG2005:06:30:00 . . . 0 0 0 0 0 0 0 0 539.600 MCN  EWB ROCKRR 539.600 230 4 120 2003
3D9.1BF22B0 1 1 W 1998 1 1 0 0 0 02JUL2000:08:00:00 . . . 0 0 0 0 0 0 0 0 522.111 LGR  DMM LGRRBR 522.111 140 5 18 1998
3D9.1BF22B1 1 1 W 2003 0 0 0 0 0 . . . . 0 0 0 0 0 0 0 0 522.222 LGR  DMM LGRRBR 522.222 144 5 20 2003
3D9.1BF22B2 1 1 W 2003 1 1 0 0 0 05JUL2010:08:00:00 . . . 0 0 0 0 0 0 0 0 522.333 LGR  DMM LGRRBR 522.333 146 5 21 2003
;
run;
