WORKFLOW FOR GFC DATA-PREPROCESSING

1. exec_mask_gfc.sh	
masks the three datasets (treecover, gain and lossyear) with threshold trecover>30 and renames tiles using CEP eid tiles numbers
(rename_gain_tiles.sh, rename_treecover_tiles.sh and rename_lossyear_tiles.sh are called by the script)

2. import_gfc_in_grass.sh
link each tile of the three datasets in GRASS DB (mapset=GFC) with r.external

