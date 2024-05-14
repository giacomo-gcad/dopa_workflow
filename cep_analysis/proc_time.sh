#!/bin/bash
# IMPORT GFC TREECOVER TILES IN GRASS

date

# LOCAL VARIABLES
# READ VARIABLES FROM CONFIGURATION FILE
SERVICEDIR="/globes/processing_current/servicefiles"
source ${SERVICEDIR}/cep_processing.conf


PCPATH="/globes/USERS/GIACOMO/protconn/logs/202302"
for logfile in $(ls ${PCPATH}/*.log)
do
	 echo -n ${logfile:43:30}"|" && cat ${logfile} |grep "performed"
done

exit
