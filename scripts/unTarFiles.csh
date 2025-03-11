#!/bin/csh -f
#
foreach mbr (`seq 1 20`)
    set mbr_padZeros = `printf %03d $mbr`
    ls -l $SCRATCH/SMYLE/archive/b.e21.BSMYLE-XT.f09_g17.2020-11.${mbr_padZeros}.rest.tar
    #tar -xvf $SCRATCH/SMYLE/archive/b.e21.BSMYLE.f09_g17.2022-11.${mbr_padZeros}.rest.tar
end
exit

