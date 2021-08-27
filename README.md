# ESTIMATING TURBIDITY USING UAV IMAGERY IN THE PAD: HELPFUL INFORMATION

## Preparing image data for analysis (Creating and updating paired_data.mat)

**The MATLAB structure that stores information for each image, as well as the paired turbidity information, is *paired_data* (stored as paired_data.mat)
_paired_data_ stores the following information (in order of fields)**\
	1.	Photo file name\
	2.	Photo date/time\
	3.	Photo latitude\
	4.	Photo longitude\
	5.	Turbidity date/time\
	6.	Turbidity (NTU)\
	7.	TSS (g/L) — calibrated using Dr. Emily Eidam’s grab samples\
	8.	Panel selection flag — whether the panels and water pixels have been extracted\
	9.	Panel info — (if selection flag = 1) information on the extracted water and panel pixels stored in MATLAB structure *panel_info* (see contents)

__*panel_info* stores the following information (in order of fields)__\
	1.	Name of selected element (panel color or water)\
	2.	Coordinates of the corners of the element\
	3.	Binary mask of the element within the image\
	4.	Selected pixel values in R band\
	5.	Selected pixel values in G band\
	6.	Selected pixel values in N band\
	7.	Mean of selected pixel values in R band\
	8.	Mean of selected pixel values in G band\
	9.	Mean of selected pixel values in N band

__(RAW) Photo data are currently stored locally on Kawther’s computer and on D drive__\
__If additional RAW photos are added to the directory to be included in processing:__\
	1.	createPairedData.m: Change new to be 0 (since paired_data has already been created and new photos need to be added to it)\
	2.	createPairedData.m: Run script.\
	3.	pad_boatmountedctd_2019.mat: Load file.\
	4.	pad_boatmountedctd_2019.mat: Choose appropriate boat-mounted turbidity data file (labeled as *rsk*)\
	⁃	rsk1 = August 11, 2019\
	⁃	rsk2 = August 12, 2019\
	⁃	rsk3 = August 13, 2019\
	5.	smoothTu.m: Pass one of the above *rsk* variables to this function (given the date of new RAW photos) and run function.\
	6.	pairTiffTurbidity.m: Run script.\
	7.	paired_data is ready for photo analysis!

## Processing the photos (Selecting useful photos, panel/water extraction)
**The _paired_data_ structure is automatically updated as photos are processed.**\
	1.	photoAnalysis.m: Run script.\
	2.	Follow prompts given in MATLAB Command Window. Note:\
	⁃	The corners of the square/rectangular selection **must** be selected in the order prompted (top left, top right, bottom left, bottom right).\
	⁃	To make a selection when prompted, type the number associated with your choice and press enter to send the command.\
	⁃	If a mistake is made during selection (ie. selected corners in wrong order), you can discard the photo selection when asked to save (at the end of the photo’s selection process).
	
## Plotting turbidity vs. reflectance of all processed photos
**Estimate reflectance using all six panels weighted equally:**\
	1.	plotTuNormRef.m: Run script.\
	2.	Three plots will appear illustrating example digital number vs. reflectance curves in each band using the six panels and their mean reflectances over red, green, and near-infrared band wavelengths. These curves are used to estimate the reflectance of the water in each band.\
	3.	Another plot will appear showing reflectance in the red band vs. turbidity for all processed photos.\
**Note: To estimate reflectance using only the black and white panels (averaged over all wavelengths), run plotTuNormRefBW.m instead.**

## Machine Learning Models
**Two machine learning models are used in this application: Support Vector Machine (SVM) regression and Random Forest regression. Each model is trained in two ways: 1) using the R, G, and N band reflectances to predict turbidity and 2) using the RGN bands plus a feature averaging the three band reflectances to predict turbidity.**\
	1.	plotTuNormRef.m: Run script. (Outputs refRGNTu)\
	2.	makeDataTable.m: Pass refRGNTu to this function and run. (Outputs train and test, which contain training and testing data for the models using stratified sampling by date)\
	3.	regressionModels.m: Run script.\
	4.	RSME values of each model are displayed!
