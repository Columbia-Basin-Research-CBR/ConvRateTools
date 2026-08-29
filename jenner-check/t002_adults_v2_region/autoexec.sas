/* autoexec for t002 — caps obs at the unlicensed tier and recreates the
 * intermediate dataset that "adults V2" reads, sasdata.upstream_at_BON_v1.
 * This is the output of program 1 in the same source file; here it is
 * supplied directly with the exact columns the V2 step consumes:
 * species, run, adult_year, bonacnt, tag_km (char, KM coded as e.g. 522.x),
 * age_at_return, rear_type. tag_km is the field program 2 slices with
 * substr() to assign Snake / Yakima / Upper Col regions. */
options obs=100;

libname sasdata ".";

data sasdata.upstream_at_BON_v1(label = "BON, MCN, etc adult detects 01-10-2008 V1");
  length tag_id $14 species $1 run $1 rear_type $1 tag_km $12
         site $8 coord_id $8 rel_site $8;
  input tag_id $ species $ run $ rear_type $ adult_year migr_yr
        age_at_return bonacnt mcnacnt lgracnt
        tag_km $ site $ coord_id $ rel_site $ ;
datalines;
3D9.1BF22A1 1 1 W 2005 2003 2 1 1 0 522.001 LGR  DMM LGRRBR
3D9.1BF22A2 1 1 W 2005 2003 2 1 1 1 522.014 LGR  DMM LGRRBR
3D9.1BF22A3 3 3 H 2006 2004 2 1 1 0 539.050 MCN  EWB ROCKRR
3D9.1BF22A4 1 1 H 2004 2002 2 1 0 0 539.100 PRD  EWB PRDRBR
3D9.1BF22A5 1 2 W 2005 2003 2 1 1 1 522.300 LGR  DMM LGRRBR
3D9.1BF22A6 3 3 W 2006 2004 2 1 1 0 540.500 MCN  EWB MCNRBR
3D9.1BF22A7 1 3 W 2004 2002 2 1 1 0 522.700 LGR  DMM LGRRBR
3D9.1BF22A8 1 1 W 2007 2005 2 1 1 1 522.900 LGR  DMM LGRRBR
3D9.1BF22A9 3 3 H 2005 2003 2 1 1 0 539.600 MCN  EWB ROCKRR
3D9.1BF22B3 1 1 H 2006 2004 2 1 1 0 545.200 PRD  EWB PRDRBR
3D9.1BF22B4 3 3 W 2007 2005 2 1 1 0 550.300 MCN  EWB MCNRBR
3D9.1BF22B5 1 1 W 2007 2006 1 1 1 1 522.450 LGR  DMM LGRRBR
;
run;
