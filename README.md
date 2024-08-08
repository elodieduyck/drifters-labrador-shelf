# Drifters Labrador Shelf
This folder contains matlab code used to process the drifter datasets and produce the figures used in the paper. It also contains a data folder with the subsets of the different datasets used in the paper.

## Files
- `STARTWITHME.m` sets the file paths used in the rest of the code.
- `RunAll.m` loads the data and runs the computation. If running each script separately, they need to be run in the same order
- `LOAD/`
    - `LOAD_DrifterData.m` loads the EGC DrIFT and GDP data. You can load the original data or use the ones in the data folder
    - `LOAD_ForPlots.m` loads the topography data, selects and rearranges the drifter data in tables for plotting
- `COMP/`
    - `COMP_DefineShelf` defines the smoothed 1000m isobath as shelf boundary
    - `COMP_DistanceToShelfbreak` computes, for each drifter datapoint, the closest point at the shelf boundary, its distance along the shelf, and distance to the drifter datapoint
    - `COMP_DriftersInOut` computes, using the previous results, the drifters crossing onto / away from the shelf
    - `COMP_Pathways` computes the connectivity between different regions of the shelf to define typical pathways for drifters
 - `PLOT/` allows to plot the different figures. The PLOT scripts can be used in any order / independantly of each other, after having run the computation scripts
 - `DATA/` contains the subsets of publicly available datasets used for this study. The scripts can run directly using these datasets.

## Used datasets
- GDP drifter dataset, 6h interpolated from January 1990 to May 2023 (Lumpkin and Centurioni, 2019). Available at https://www.aoml.noaa.gov/phod/gdp/index.php, accessed [2023-10-12] . We used the ASCII files, updated through May 2023. 
- EGC-DrIFT dataset, 6h interpolated SVP drifters. Available on the NIOZ dataverse repository : https://doi.org/10.25850/nioz/7b.b.ff (Duyck et al 2023)
- ETOPO2022 60 arc-second ice surface elevation, available at https://doi.org/10.25921/fd45-gt74 (NOAA, 2022)

For each dataset, the version and subset used can be found in the data folder and is directly usable by the Matlab scripts

## Used libraries
- m_map mapping package for Matlab, available at https://www.eoas.ubc.ca/~rich/map (Pawlowicz, 2020)
- jlab, available at https://www.jmlilly.net/code.html (Lilly 2024)

## Software information
The code was written with Matlab 2023a

## References

Duyck, E., De Jong, M. F. : Full EGC-DrIFT 6h interpolated dataset, NIOZ [Dataset], https://doi.org/10.25850/nioz/7b.b.ff, 2023b. \
Lilly, J. M.: jLab: A data analysis package for Matlab, v.1.7.3, [ computer software], https://doi.org/10.5281/zenodo.4547006, 2024. \
Lumpkin, R., Centurioni, L., Global Drifter Program quality-controlled 6-hour interpolated data from ocean surface drifting buoys, NOAA National Centers for Environmental Information [Dataset], https://doi.org/10.25921/7ntx-z961, Accessed [2023-10-12], 2019. \
NOAA National Centers for Environmental Information: ETOPO 2022 15 Arc-Second Global Relief Model. NOAA National Centers for Environmental Information [Dataset]. https://doi.org/10.25921/fd45-gt74, Accessed [2024-07-05], 2022. \
Pawlowicz, R. : M_Map: A mapping package for MATLAB, v1.4m, [Computer software], available at www.eoas.ubc.ca/~rich/map.html , 2020. 
