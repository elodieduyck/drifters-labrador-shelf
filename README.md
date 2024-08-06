# Drifters Labrador Shelf

This folder contains matlab code used to process the drifter datasets and produced the figures used in the paper

## Files
STARTWITHME.m sets the file paths used in the rest of the code. 

LOAD_DrifterData.m loads the EGC DrIFT and GDP data. You can load the original data or use the ones in the data folder
LOAD_ForPlots.m loads the topography data, selects and rearranges the drifter data in tables for plotting

COMP_DefineShelf Defines the smoothed 1000m isobath as shelf boundary
COMP_DistanceToShelfbreak computes, for each drifter datapoint, the closest point at the shelf boundary, its distance along the shelf, and distance to the drifter datapoint
COMP_DriftersInOut computes, using the previous results, the drifters crossing onto / away from the shelf
COMP_Pathways computes the connectivity between different regions of the shelf to define typical pathways for drifters

The scripts above have to be launched in that order before being able to use the PLOT scripts. The PLOT scripts can be used in any order / independantly of each other

## Used datasets
- GDP drifter dataset, 6h interpolated from January 1990 to May 2023 
https://www.aoml.noaa.gov/phod/gdp/index.php
cit, accessed [] 
The used data, with a subset in the Subpolar North Atlantic, is found in the data folder
- EGC-DrIFT dataset, 6h interpolated SVP drifters. Can be found here: 
- Etopo 2022 60s ice surface topography. The subset used can be found in the data folder

## Used libraries
- mmap mapping package for Matlab https://www.eoas.ubc.ca/~rich/map -> m_proj, m_plot, m_contour, m_contourf
- jlab https://www.jmlilly.net/code.html -> latlon2uv 

## Software information
The code was written with Matlab 2023a

