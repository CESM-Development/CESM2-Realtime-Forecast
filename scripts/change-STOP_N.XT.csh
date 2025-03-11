#!/bin/csh 
### set env variables
module load ncl nco

setenv CESM2_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/cesm2-smyle/
setenv CASEROOT /glade/campaign/cesm/development/espwg/SMYLE-CASES/CESM2-SMYLE-DP/cases/

# ...
set syr = 2023
set eyr = 2023

@ ib = $syr
@ ie = $eyr

foreach year ( `seq $ib $ie` )
foreach mon ( 11 )
#foreach mon ( 08 )

# case name counter
set smbr =  1
set embr =  20

@ mb = $smbr
@ me = $embr

foreach mbr ( `seq $mb $me` )
if ($mbr < 10) then
	#set CASE = b.e21.BSMYLE-XT.f09_g17.${year}-${mon}.00${mbr}
        set CASE = b.e21.BSMYLE-XT-beta.f09_g17.${year}-${mon}.00${mbr}
else
	#set CASE = b.e21.BSMYLE-XT.f09_g17.${year}-${mon}.0${mbr}
        set CASE = b.e21.BSMYLE-XT-beta.f09_g17.${year}-${mon}.0${mbr}
endif

cd $CASEROOT/$CASE
echo $CASE
./xmlchange STOP_N=2
./xmlchange REST_N=2
./case.submit

end             # mbr loop
end             # mon loop
end             # year loop

exit

