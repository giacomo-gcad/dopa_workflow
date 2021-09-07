#!/bin/bash

SERVICEDIR="/globes/processing_current/servicefiles"
source ${SERVICEDIR}/wdpa_preprocessing.conf

# ## PART 1: LINK RASTERS MOLLWEIDE
# # set variables
# PERMANENT_MAPSET="${DATABASE}/${LOCATION_MO}/PERMANENT"

# # execute link_rasters_mollweide.sh
# grass ${PERMANENT_MAPSET} --exec sh ./slave_link_rasters_mollweide.sh ${ORIGDATA} ${DERIVDATA}

# wait

# ## PART 2: LINK RASTERS WGS84LL
# # set variables
# PERMANENT_MAPSET="${DATABASE}/${LOCATION_LL}/PERMANENT"

# # execute link_rasters_wgs84ll.sh 
# grass ${PERMANENT_MAPSET} --exec sh ./slave_link_rasters_wgs84ll.sh ${ORIGDATA} ${DERIVDATA}

# wait

## PART 3 : IMPORT SST TIME SERIES
# set variables
PERMANENT_MAPSET="${DATABASE}/${LOCATION_LL}/PERMANENT"

# execute link_rasters_sst.sh
grass ${PERMANENT_MAPSET} --exec sh ./slave_link_rasters_sst.sh ${ORIGDATA}

date
