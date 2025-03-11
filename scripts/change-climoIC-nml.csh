#!/bin/csh 
### set env variables
module load ncl nco

setenv CESM2_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/cesm2-smyle/
setenv CASEROOT /glade/campaign/cesm/development/espwg/SMYLE-CASES/CESM2-SMYLE-DP/cases/

# ...
set syr = 2005
set eyr = 2005

@ ib = $syr
@ ie = $eyr

foreach year ( `seq $ib $ie` )
foreach mon ( 11 )

# case name counter
set smbr =  2
set embr =  10

@ mb = $smbr
@ me = $embr

foreach mbr ( `seq $mb $me` )
if ($mbr < 10) then
        set CASE = b.e21.BSMYLE_climoIC.f09_g17.${year}-${mon}.00${mbr}
else
        set CASE = b.e21.BSMYLE_climoIC.f09_g17.${year}-${mon}.0${mbr}
endif

cd $CASEROOT/$CASE
echo $CASE
cp /glade/work/nanr/cesm_tags/CASE_tools/cesm2-smyle/user_mods/cesm2smyle.base/climoIC/user_nl_cam .
./xmlchange PROJECT=CESM0020
./xmlchange CONTINUE_RUN=FALSE
./case.submit

end             # mbr loop
end             # mon loop
end             # year loop

exit

