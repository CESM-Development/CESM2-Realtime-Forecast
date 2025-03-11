#!/bin/csh -fx
### set env variables
module load ncl nco

setenv CESM2_TOOLS_ROOT /glade/work/$USER/cesm_tags/CASE_tools/cesm2-smyle-DP/
#setenv ARCHDIR1  /glade/scratch/$USER/SMYLE-EXTEND/archive/
setenv ARCHDIR1  /glade/derecho/scratch/$USER/SMYLE-DP/archive/
#setenv ARCHDIR1  /glade/derecho/scratch/sglanvil/SMYLE-DP/archive/
setenv TSERIES  /glade/campaign/cesm/development/espwg/CESM2-DP/timeseries/
setenv LOGSDIR  /glade/campaign/cesm/development/espwg/CESM2-DP/logs
setenv POPDDIR  /glade/campaign/cesm/development/espwg/CESM2-DP/popd
setenv RESTDIR  /glade/campaign/cesm/development/espwg/CESM2-DP/restarts/

set USE_ARCHDIR = $ARCHDIR1

set syr = 2020
set eyr = 2020
#set syr = 2014
#set eyr = 2014

@ ib = $syr
@ ie = $eyr

@ restyear = $syr + 11
echo $restyear

foreach year ( `seq $ib $ie` )
#foreach mon ( 02 05 )
foreach mon ( 11 )


# case name counter
set smbr =  1
set embr =  20

@ mb = $smbr
@ me = $embr

foreach mbr ( `seq $mb $me` )
if ($mbr < 10) then
        set CASE = b.e21.BSMYLE.f09_g17.${year}-${mon}.00${mbr}
else
        set CASE = b.e21.BSMYLE.f09_g17.${year}-${mon}.0${mbr}
endif

if (! -e $RESTDIR/$CASE.$restyear.rest.tar) then
   cd $USE_ARCHDIR
   tar -cvf $RESTDIR/$CASE.$restyear.rest.tar $CASE/rest/$restyear-*
else
   echo "rest done"
endif

end             # mon loop
end             # member loop
end             # year loop

exit

