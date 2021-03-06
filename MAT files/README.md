# Descriptions of .MAT files

## paired_data.mat
Structure containing information about photo analysis process: which photos have been processed and the processed information, such as digital number values of extracted panels and water pixels. See instructions for updating *paired_data* on GitHub main PAD directory README. The current file is too large to store on GitHub, so here is a link to download paired_data.mat from Google Drive: https://drive.google.com/file/d/1sHulP0lo-ZsdKGPhR22eJ__ToZIK1_-0/view?usp=sharing

Fields of *paired_data*:\
	1.	Photo file name\
	2.	Photo date/time\
	3.	Photo latitude\
	4.	Photo longitude\
	5.	Turbidity date/time\
	6.	Turbidity (NTU)\
	7.	TSS (g/L) — calibrated using Dr. Emily Eidam’s grab samples\
	8.	Panel selection flag — whether the panels and water pixels have been extracted\
	9.	Panel info — (if selection flag = 1) information on the extracted water and panel pixels stored in MATLAB structure *panel_info* (see contents)

## 13panels.mat
Structure containing information on extracted 13 panels from close up image taken by the MAPIR camera with the following fields:\
	1.	Coordinates of the corners of the panel (top left, top right, bottom left, bottom right)\
	2.	Binary mask of the panel within the image\
	3.	Color of panel\
	4.	Selected pixel values in R band\
	5.	Selected pixel values in G band\
	6.	Selected pixel values in N band\
	7.	Mean of selected pixel values in R band\
	8.	Mean of selected pixel values in G band\
	9.	Mean of selected pixel values in N band


## bwref.mat
Contains two variables that store the reflectances of the white and black panels, averaged over all spectrometer wavelengths (350-1090 nm):\
	1.	*blackref* — average reflectance of black panel\
	2.	*whiteref* — average reflectance of white panel


## normref.mat
Structure containing information on average reflectances for six colored panels, separated by red, green, and near-infrared bands. Average reflectance was calculated over the following wavelengths for each band:
* Red: 661-669 nm
* Green: 543-551 nm
* Near-infrared: 843-853 nm

*norm_ref* contains the following fields:\
	1.	Color of panel\
	2.	Reflectance values in R band\
	3.	Reflectance values in G band\
	4.	Reflectance values in N band\
	5.	Mean of reflectance values in R band\
	6.	Mean of reflectance values in G band\
	7.	Mean of reflectance values in N band


## pad_boatmountedctd_2019.mat (Provided by Dr. Emily Eidam, UNC-CH)
Three structures containing PAD field data, a time series boat-mounted sensors. Each structure named *rsk* represents a different day:\
	⁃	rsk1 = August 11, 2019\
	⁃	rsk2 = August 12, 2019\
	⁃	rsk3 = August 13, 2019\
	Relevant fields include:\
	1.	td — time and date\
	2.	cond — conductivity (mS/cm)\
	3.	pres — pressure (dbar)\
	4.	tb — turbidity (NTU)


## PAD2019ctd_tss.mat (Provided by Dr. Emily Eidam, UNC-CH)
Structure containing vectors of PAD field data, point measurements taken over 10 days (1 row/day). Relevant fields include:\
	1.	td — time and date\
	2.	cond — conductivity (mS/cm)\
	3.	pres — pressure (dbar)\
	4.	tusurf — turbidity at surface (NTU)\
	5.	lat — latitude\
	6.	lon — longitude\
	7.	tsslo — TSS measurement 1 (mg/L)\
	8.	tsshi — TSS measurement 2 (mg/L)\
	9.	tss_surf_mean — mean TSS (mg/L)


## photos_RAW.mat
Structure containing file information of RAW photos from PAD 2019, including the following fields:\
	1.	path including containing folder, filename, and extension\
	2.	full path name\
	3.	time and date photo was taken\
	4.	local file path where Kawther saved the images — used to pull images for photo processing, these paths are copied to *paired_data*


## refRGNTu.mat
Output of plotTuNormRef. Structure containing information from *paired_data* processed photos on water extraction after converted to reflectance using six-panel calibration curve, as well as the turbidity value paired with the photo. Fields:\
	1.	Water reflectance in R band\
	2.	Water reflectance in G band\
	3.	Water reflectance in N band\
	4.	Turbidity (NTU)\
	5.	Photo date and time
