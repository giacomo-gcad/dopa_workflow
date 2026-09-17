WDPA PREPROCESSING - 202601 VERSION

Bash scripts in this folder MUST  be executed in the following order:

1) exec_wdpa_import.sh
1.a) ./sql/modify_wdpa_wdoecm_structure.sql # Added on 20251218: makes the new structure compatible with all subsequent scripts.
2) exec_wdpa_wdoecm_preprocessing_part_1.sh
3) ./sql/fix_wdpa_geom.sql 		#TO BE RUN MANUALLY SECTION BY SECTION
4) exec_wdpa_wdoecm_preprocessing_part_2.sh
5) exec_buffers_processing.sh 
EDITED 6) exec_prepare_data_x_grass.sh (removed all the parts about buffers)
SKIPPED - 7) exec_make_flat.sh
EDITED 8) exec_pg_to_grass.sh 
EDITED 9) exec_project_pa_bu.sh
SKIPPED 11) exec_wdoecm_preprocessing (only if oecm need to be integrated  in analysis)
SKIPPED 12) exec_link_rasters.sh (only if needed, i.e. if a new GRASS database is used or if some raster datasets are changed

All the remaining scripts in this folder and subfolders are slave scripts, called by the above mentioned ones.

