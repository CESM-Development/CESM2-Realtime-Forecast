#!/bin/csh 
### set env variables
module load ncl nco

setenv CESM2_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/cesm2-smyle/
setenv CASEROOT /glade/campaign/cesm/development/espwg/SMYLE-CASES/CESM2-SMYLE-MDP/cases/

# ...
set syr = 1970
set eyr = 1970

@ ib = $syr
@ ie = $eyr

foreach year ( `seq $ib $ie` )
foreach mon ( 11 )
#foreach mon ( 08 )

# case name counter
set smbr =  8
set embr =  9

@ mb = $smbr
@ me = $embr

foreach mbr ( `seq $mb $me` )
if ($mbr < 10) then
        set CASE = b.e21.BSMYLE.f09_g17.MDP.${year}-${mon}.00${mbr}
else
        set CASE = b.e21.BSMYLE.f09_g17.MDP.${year}-${mon}.0${mbr}
endif

cd $CASEROOT/$CASE
echo $CASE
./xmlchange STOP_N=26
./xmlchange REST_N=26
#./case.submit

end             # mbr loop
end             # mon loop
end             # year loop

exit

