#! /bin/csh -fxv 

setenv CESM2_TOOLS_ROOT /glade/work/nanr/cesm_tags/CASE_tools/cesm2-smyle/
setenv CESMROOT /glade/work/nanr/cesm_tags/cesm2.1.4-SMYLE

if ($HOST != casper10) then
echo "ERROR:  Must be run on Casper"
#exit
endif


#foreach  ye9r ( 1954 1964 1974 1984 1994 2004 )
set syr = 1958
set eyr = 1958

@ ib = $syr
@ ie = $eyr

foreach year ( `seq $ib $ie` )
	#foreach mon ( 11 )
foreach mon ( 02 05 08 )

set case = b.e21.SMYLE_climoIC.f09_g17.${year}-${mon}.01

#set icdir = /glade/p/cesm/cseg/inputdata/ccsm4_init/{$case} 
set Picdir = /glade/campaign/cesm/development/espwg/SMYLE/inputdata/cesm2_init/{$case}/
set icdir  = /glade/campaign/cesm/development/espwg/SMYLE/inputdata/cesm2_init/{$case}/${year}-${mon}-01
if (! -d ${Picdir}) then
 mkdir ${Picdir}
endif
if (! -d ${icdir}) then
 mkdir ${icdir}
endif


set doThis99 = 1
if ($doThis99 == 1) then

# atm, lnd initial conditions
# Climo names:  cam.i.nc  cice.nc  clm2.nc  mosart.r.nc  ncdump  pop.r.nc
set atmfname = cam.i.nc
set lndfname = clm2.nc
set roffname = mosart.r.nc

# directories
set findir = /glade/u/home/liyuanpu/Steve/

# rename atm, land IC files

set atmfout = ${case}.cam.i.${year}-${mon}-01-00000.nc
set lndfout = ${case}.clm2.r.${year}-${mon}-01-00000.nc
set roffout = ${case}.mosart.r.${year}-${mon}-01-00000.nc

echo $atmfout

set doThis = 1

if ($doThis == 1) then
cp $findir/${atmfname} $icdir/$atmfout
cp $findir/${lndfname} $icdir/$lndfout
cp $findir/${roffname} $icdir/$roffout
ncatted -a OriginalFile,global,a,c,$atmfname $icdir/$atmfout
ncatted -a OriginalFile,global,a,c,$lndfname $icdir/$lndfout
ncatted -a OriginalFile,global,a,c,$roffname $icdir/$roffout

endif

# ocn/ice
# years used for ICs:   0306 (1958) - 0366 (2018)

set icefout = ${case}.cice.r.${year}-${mon}-01-00000.nc
set lndfout = ${case}.clm2.r.${year}-${mon}-01-00000.nc
set roffout = ${case}.mosart.r.${year}-${mon}-01-00000.nc

set icefname   = cice.nc
set poprfname  = pop.r.nc
set poprofname = b.e21.SMYLE_IC.f09_g17.2005-11.01.pop.ro.2005-11-01-00000
set poprhfname = b.e21.SMYLE_IC.f09_g17.2005-11.01.pop.rh.ecosys.nyear1.2005-11-01-00000.nc
set popwwfname = b.e21.SMYLE_IC.f09_g17.2005-11.01.pop.ww3.r.2005-11-01-00000

set poprfout  = ${case}.pop.r.${year}-${mon}-01-00000.nc
set poprofout = ${case}.pop.ro.${year}-${mon}-01-00000 
set poprhfout = ${case}.pop.rh.ecosys.nyear1.${year}-${mon}-01-00000.nc
set popwwfout = ${case}.ww3.r.${year}-${mon}-01-00000

echo $icefname
echo $poprfname

set doThis2 = 0
if ($doThis2 == 1) then

cp $findir/${poprfname}    $icdir/${poprfout}
cp $findir/${icefname}     $icdir/${icefout}

## use the 2005-11 overflow, ecosys and ww3 files
set findir2 = /glade/campaign/cesm/development/espwg/SMYLE/inputdata/cesm2_init/b.e21.SMYLE_IC.f09_g17.2005-11.01/2005-11-01/

cp $findir2/${poprofname}  $icdir/${poprofout}
cp $findir2/${poprhfname}  $icdir/${poprhfout}
cp $findir2/${popwwfname}  $icdir/${popwwfout}

ncatted -a OriginalFile,global,a,c,$icefname    $icdir/$icefout
ncatted -a OriginalFile,global,a,c,$poprfname   $icdir/$poprfout
#ncatted -a OriginalFile,global,a,c,$poprofname  $icdir/$poprofout
ncatted -a OriginalFile,global,a,c,$poprhfname  $icdir/$poprhfout

# create rpointer files

echo "$case.cice.r.$year-${mon}-01-00000.nc"  > ${icdir}/rpointer.ice
echo "./$case.pop.ro.$year-${mon}-01-00000"   > ${icdir}/rpointer.ocn.ovf
echo "$case.cam.r.$year-${mon}-01-00000.nc"   > ${icdir}/rpointer.atm
echo "$case.cpl.r.$year-${mon}-01-00000.nc"   > ${icdir}/rpointer.drv
#echo "$case.clm2.r.$year-${mon}-01-00000.nc"  > ${icdir}/rpointer.clm
echo "$case.clm2.r.$year-${mon}-01-00000.nc"  > ${icdir}/rpointer.lnd
echo "$case.mosart.r.$year-${mon}-01-00000.nc"   > ${icdir}/rpointer.rof
echo "$case.pop.rh.ecosys.nyear1.$year-${mon}-01-00000.nc"   > ${icdir}/rpointer.ocn.tavg.5
echo "$case.pop.rh.$year-${mon}-01-00000.nc"   > ${icdir}/rpointer.ocn.tavg

echo "./$case.pop.r.$year-${mon}-01-00000.nc"    >> ${icdir}/rpointer.ocn.restart
echo "RESTART_FMT=nc"                          >> ${icdir}/rpointer.ocn.restart

endif	# doThis2

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

endif	# doThis99

# ==================================
# generate perturbed cam.i.restarts
# ==================================
setenv CYLC_TASK_CYCLE_POINT ${year}-${mon}-01
cd ${CESM2_TOOLS_ROOT}/restarts/
./generate_cami_ensemble_offline.climoIC.50mbrs.py

end
end

exit
 
 



