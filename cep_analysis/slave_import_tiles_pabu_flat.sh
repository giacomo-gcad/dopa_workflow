#!/bin/bash
##IMPORT PABU TILES AS INDIVIDUAL RASTER LAYERS

til=$1
PABU_MAPSET_PATH=$2
tiles_path=$3

echo "#!/bin/bash
	## IMPORT CEP TILE AS EXTERNAL LINK
	r.external --o --q input=${tiles_path}/${til}.tiff output=ceptile_${til}
	exit
	" > ./dyn/import_pabu_${til}.sh
    chmod u+x ./dyn/import_pabu_${til}.sh
    grass ${PABU_MAPSET_PATH} --exec ./dyn/import_pabu_${til}.sh
	echo "Tile ${til} imported"
exit


