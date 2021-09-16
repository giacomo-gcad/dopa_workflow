#!/bin/bash
##PROCESS GLOBAL FOREST CHANGE (GAIN AND LOSSYEAR)

TIL=$1
TILESIZE=$2
TREE_LIST_FILE=$3
base_indir=$4 
base_outdir=$5
temp_dir=$6
rootstring=$7

## Building input variables
tree_indir=${base_indir}"/treecover"
gain_indir=${base_indir}"/gain"
lossyear_indir=${base_indir}"/lossyear"

## Building output variables
tree_outdir_ll=${base_outdir}"/treecover_over30_ll"
gain_outdir_ll=${base_outdir}"/gain_over30_ll"
lossyear_outdir_ll=${base_outdir}"/lossyear_over30_ll"

mkdir -p ${tree_outdir_ll}
mkdir -p ${gain_outdir_ll}
mkdir -p ${lossyear_outdir_ll}

for FIL in $(cat ${TREE_LIST_FILE}|awk "NR >= (${TIL}+1) && NR <= (${TIL}+${TILESIZE})")
    do
	tr_inp=${tree_indir}/${FIL}
	mask=${temp_dir}/mask_${FIL:35:47}
	tr_out2=${tree_outdir_ll}/${FIL}
	ga_inp=${gain_indir}/${rootstring}"gain_"${FIL:35:47}
	ga_out1=${gain_outdir_ll}/${rootstring}"gain_"${FIL:35:47}
	ly_inp=${lossyear_indir}/${rootstring}"lossyear_"${FIL:35:47}
	ly_out1=${lossyear_outdir_ll}/${rootstring}"lossyear_"${FIL:35:47}
    echo "
gdal_calc.py -A ${tr_inp} --outfile=${mask} --type Byte --co COMPRESS=DEFLATE --co TILED=YES --co BLOCKXSIZE=512 --co BLOCKYSIZE=512 --calc=\"0*(A<=29)+1*(A>29)*(A<=100)\" --NoDataValue=255 --overwrite
gdal_calc.py -A ${tr_inp} -B ${mask} --outfile=${tr_out2} --type Byte --co COMPRESS=DEFLATE --co TILED=YES --co BLOCKXSIZE=512 --co BLOCKYSIZE=512 --calc=\"A*B\" --NoDataValue=255 --overwrite
gdal_calc.py -A ${ga_inp} -B ${mask} --outfile=${ga_out1} --type Byte --co COMPRESS=DEFLATE --co TILED=YES --co BLOCKXSIZE=512 --co BLOCKYSIZE=512 --calc=\"A*B\" --NoDataValue=255 --overwrite
gdal_calc.py -A ${ly_inp} -B ${mask} --outfile=${ly_out1} --type Byte --co COMPRESS=DEFLATE --co TILED=YES --co BLOCKXSIZE=512 --co BLOCKYSIZE=512 --calc=\"A*B\" --NoDataValue=255 --overwrite
"> ./dyn/mask_gfc_${FIL:35:43}.sh
    chmod u+x ./dyn/mask_gfc_${FIL:35:43}.sh
    ./dyn/mask_gfc_${FIL:35:43}.sh
done
exit
