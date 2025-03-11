#!/bin/csh -fx
### set env variables
module load ncl nco

setenv CESM2_TOOLS_ROOT /glade/work/$USER/cesm_tags/CASE_tools/cesm2-smyle-DP/
#setenv ARCHDIR1  /glade/scratch/$USER/SMYLE-EXTEND/archive/
#setenv ARCHDIR1  /glade/derecho/scratch/$USER/SMYLE-DP/archive/
setenv ARCHDIR1  /glade/derecho/scratch/$USER/SMYLE-DP-climoIC/archive/
#setenv ARCHDIR1  /glade/derecho/scratch/sglanvil/SMYLE-DP/archive/
setenv TSERIES  /glade/campaign/cesm/development/espwg/CESM2-DP/timeseries
setenv LOGSDIR  /glade/campaign/cesm/development/espwg/CESM2-DP/logs
setenv POPDDIR  /glade/campaign/cesm/development/espwg/CESM2-DP/popd

set USE_ARCHDIR = $ARCHDIR1

set syr = 2005
set eyr = 2005
#set syr = 2014
#set eyr = 2014

@ ib = $syr
@ ie = $eyr

foreach year ( `seq $ib $ie` )
#foreach mon ( 02 05 )
foreach mon ( 11 )


# case name counter
set smbr =  1
set embr =  30

@ mb = $smbr
@ me = $embr

foreach mbr ( `seq $mb $me` )
if ($mbr < 10) then
        set CASE = b.e21.BSMYLE-XT.f09_g17.${year}-${mon}.00${mbr}
        set CASE = b.e21.BSMYLE-XT-beta.f09_g17.${year}-${mon}.00${mbr}
        set CASE = b.e21.BSMYLE_climoOcnAtmIC.f09_g17.2005-11.00${mbr}
else
        set CASE = b.e21.BSMYLE-XT.f09_g17.${year}-${mon}.0${mbr}
        set CASE = b.e21.BSMYLE-XT-beta.f09_g17.${year}-${mon}.0${mbr}
        set CASE = b.e21.BSMYLE_climoOcnAtmIC.f09_g17.2005-11.0${mbr}
endif

if (! -d $TSERIES/$CASE/cpl/hist) then
	mkdir -p $TSERIES/$CASE/cpl/hist
endif
cp $USE_ARCHDIR/$CASE/cpl/hist/* $TSERIES/$CASE/cpl/hist/

if (! -e $LOGSDIR/$CASE.logs.tar) then
   cd $USE_ARCHDIR
   tar -cvf $LOGSDIR/$CASE.logs.tar $CASE/logs/*.gz
else
   echo "logs done"
endif
#if (! -e $RESTDIR/$CASE.rest.tar) then
   #cd $USE_ARCHDIR
   #tar -cvf $RESTDIR/$CASE.rest.tar $CASE/rest/
#else
   #echo "rest done"
#endif
if (! -e $POPDDIR/$CASE.popd.tar) then
   cd $USE_ARCHDIR
   tar -cvf $POPDDIR/$CASE.popd.tar $CASE/ocn/hist/*.pop.d*
else
   echo "popd done"
endif

end             # mon loop
end             # member loop
end             # year loop

exit

