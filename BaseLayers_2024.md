# Base Layers

DOPA indicators are reported at three different levels (protected area, country and ecoregion) that are built from the following datasets, used for the set up of the corresponding three base layers used for analysis.

### World Database of Protected Areas (WDPA) 
UNEP-WCMC & IUCN (2023). Protected Planet: The World Database on Protected Areas (WDPA) [www.protectedplanet.net](www.protectedplanet.net), [February/2023], Cambridge, UK: UNEP-WCMC and IUCN.

WDPA database is downloaded monthly from [WCMC website](www.protected_planet.net). A script for download is controlled by a CRON command on server.
The dataset downloaded consist of an ESRI geodatabase, including the following feature classes:

- WDPA_WDOECM_point_Mmmyyyy
- WDPA_WDOECM_poly_Mmmyyyy

Since May 2021 the gdb includes also OECM. The field pa_def is used to mark them: pa_def=1 for protected areas, pa_def=0 for OECM.
Starting from July 2022, OECM are routinely included in the DOPA workflow.


### Administrative boundaries
Administrative boundaries are built from the combination of GISCO datasets for country boundaries and EEZ exclusive economic zones. GISCO datasets are preprocessed before being used as base layers. The pre-processing workflow of GISCO data is described [here](https://github.com/andreamandrici/dopa_workflow/tree/master/preprocessing#countries-v2020).

- Global Administrative Unit Layers (GAUL), revision 2015 (2017-02-02) (no more available for download)
- Exclusive Economic Zones: [Exclusive Economic Zones (EEZ) v9](http://www.marineregions.org/downloads.php)

### Ecoregions
- Terrestrial Ecoregions of the World(TEOW) ([Olson et al., 2001](https://www.worldwildlife.org/publications/terrestrial-ecoregions-of-the-world))
- Marine Ecoregions of the World, including the Marine Ecoregions Of the World (MEOW, [Spalding _et al._, 2007](!https://doi.org/10.1641/B570707](https://doi.org/10.1641/B570707))) and the Pelagic provinces of the world (PPOW, [Spalding _et al._, 2012](http://dx.doi.org/10.1016/j.ocecoaman.2011.12.016))


