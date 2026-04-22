#!/bin/bash
##IMPORT BUILT UP TILES FOR SIX DIFFERENT YEARS (GHSL BUILTUP-S R2023A version)

til=$1
indir_root=$2
infile_root=$3
MAPSET=${4}

echo "#!/bin/bash
	r.external --o --q input=${indir_root}/${infile_root}${til}.vrt output=builtup2020_${til}
	exit
	" > ./dyn/import_builtup_${til}.sh
    chmod u+x ./dyn/import_builtup_${til}.sh
    grass ${MAPSET} --exec ./dyn/import_builtup_${til}.sh
	echo "Tile ${til} imported"
exit


