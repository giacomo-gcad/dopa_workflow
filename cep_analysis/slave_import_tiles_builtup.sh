#!/bin/bash
##IMPORT BUILT UP TILES FOR SIX DIFFERENT YEARS (GHSL BUILTUP-S R2023A version)

til=$1
indir_root=$2
infile_root=$3
MAPSET=${4}

echo "#!/bin/bash
	r.external --o --q input=${indir_root}1975/${infile_root}${til}.tif output=builtup1975_${til}
	r.external --o --q input=${indir_root}1980/${infile_root}${til}.tif output=builtup1980_${til}
	r.external --o --q input=${indir_root}1990/${infile_root}${til}.tif output=builtup1990_${til}
	r.external --o --q input=${indir_root}2000/${infile_root}${til}.tif output=builtup2000_${til}
	r.external --o --q input=${indir_root}2010/${infile_root}${til}.tif output=builtup2010_${til}
	r.external --o --q input=${indir_root}2020/${infile_root}${til}.tif output=builtup2020_${til}
	
	exit
	" > ./dyn/import_builtup_${til}.sh
    chmod u+x ./dyn/import_builtup_${til}.sh
    grass ${MAPSET} --exec ./dyn/import_builtup_${til}.sh
	echo "Tile ${til} imported"
exit


