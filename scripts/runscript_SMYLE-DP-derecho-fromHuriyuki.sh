#!/bin/bash

useyear=2023
restyear=2025
usemonth=11

curdir='/glade/work/nanr/cesm_tags/CASE_tools/cesm2-smyle-DP/'
srcdir='/glade/work/nanr/cesm_tags/CASE_tools/cesm2-smyle/'
compset='BSMYLE'
usecompset='BSMYLE'
resoln='f09_g17'
tagdir='/glade/work/nanr/cesm_tags/cesm2.1.4-SMYLE/'
caseroot='/glade/campaign/cesm/development/espwg/SMYLE-CASES/CESM2-SMYLE-DP/cases/'

main_case_root='b.e21.'$usecompset'.'$resoln'.'${useyear}'-'${usemonth}'.001'

for mbr in $(seq -f "%03g" 2 20)
do

echo "setting up member ${mbr}"

runname=b.e21.$usecompset.$resoln.$useyear-$usemonth.$mbr
casedir=$caseroot/$runname
rundir=/glade/derecho/scratch/nanr/SMYLE-DP/${main_case_root}/run.${mbr}/

echo $rundir

cd $tagdir/cime/scripts

./create_newcase --case $casedir --res $resoln --compset $compset --run-unsupported
#./create_newcase --case $casedir --res $resoln --compset $compset 

cd $casedir

# ./xmlchange --append --file env_build.xml --id CAM_CONFIG_OPTS --val="-co2_cycle"
./xmlchange --append --file env_build.xml --id CAM_CONFIG_OPTS --val="-cosp "

./xmlchange JOB_WALLCLOCK_TIME=12:00:00 --subgroup case.run
./xmlchange RUN_TYPE=hybrid
./xmlchange GET_REFCASE=FALSE
./xmlchange RUN_REFCASE=b.e21.SMYLE_IC.f09_g17.${useyear}-${usemonth}.01
./xmlchange RUN_REFDATE=${useyear}-${usemonth}-01
./xmlchange RUN_STARTDATE=${useyear}-${usemonth}-01
./xmlchange DOUT_S_ROOT=/glade/derecho/scratch/nanr/SMYLE-DP/archive/fromHiroyuki/$runname/
./xmlchange CIME_OUTPUT_ROOT=/glade/derecho/scratch/nanr/SMYLE-DP
./xmlchange RUNDIR=$rundir
./xmlchange OCN_TRACER_MODULES="iage cfc ecosys"
./xmlchange OCN_CHL_TYPE="diagnostic"
./xmlchange CCSM_BGC="CO2A"
./xmlchange CONTINUE_RUN=TRUE
 
./xmlchange PROJECT=P93300313
./xmlchange STOP_N=24
./xmlchange REST_N=24
./xmlchange STOP_OPTION=nmonths
./xmlchange RESUBMIT=3

#./xmlchange NTASKS=-3
./xmlchange NTASKS_WAV=1

./case.setup
./preview_namelists

./xmlchange EXEROOT='/glade/derecho/scratch/nanr/SMYLE-DP/exerootdir/bld'
./xmlchange BUILD_COMPLETE=TRUE

# 
cp $srcdir/user_mods/cesm2smyle.base/SourceMods/src.cam/* ./SourceMods/src.cam/
cp $srcdir/user_mods/cesm2smyle.base/SourceMods/src.clm/* ./SourceMods/src.clm/
cp $srcdir/user_mods/cesm2smyle.base/SourceMods/src.pop/* ./SourceMods/src.pop/
cp $srcdir/user_mods/cesm2smyle.base/user_nl_* .

mkdir -p $rundir

echo "made it this far"
  
  # Lastly - copy Initial conditions
    ics="/glade/derecho/scratch/nanr/SMYLE/archive/fromHiroyuki/b.e21.BSMYLE.f09_g17.${useyear}-${usemonth}.$mbr/rest/"

    ls ${rundir}

    # pre-stage ICs
    cp ${ics}/${restyear}-${usemonth}-01-00000/rpointer.* ${rundir}/
    ln -s ${ics}/${restyear}-${usemonth}-01-00000/b.e21.* ${rundir}/

    ./case.submit

done
