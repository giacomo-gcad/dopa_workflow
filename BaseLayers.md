# Base Layers

+  WDPA : UNEP-WCMC & IUCN (2021). Protected Planet: The World Database on Protected Areas (WDPA) [www.protectedplanet.net](www.protectedplanet.net), [January/2021], Cambridge, UK: UNEP-WCMC and IUCN.

WDPA data are downloaded monthly from [WCMC website](www.protected_planet.net). A script for download is controlled by a CRON command on server.
The dataset downloaded consiist of a ESRI geodatabase, including the following feature classes:

+  WDPA_WDOECM_point_Mmmyyyy
+  WDPA_WDOECM_poly_Mmmyyyy

Since May 2021 the gdb includes also OECM. The field pa_def is used to mark them: pa_def+1 for protected areas, pa_def=0 for OECM.

