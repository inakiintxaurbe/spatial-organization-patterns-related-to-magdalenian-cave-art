# spatial-organization-patterns-related-to-magdalenian-cave-art
This repository contains the codes from DOI: https://doi.org/10.1007/s12520-024-02007-3.

#   Author: Iñaki Intxaurbe Alberdi 
#   Department of Graphic Design and Engineering Projects
#   (Universidad del País Vasco/Euskal Herriko Unibertsitatea)
#   PACEA UMR 5199
#   (Université du Bordeaux)
#   Date: 2024-06-15
#   Copyright (C) 2024  Iñaki Intxaurbe

First, in the "0 DATA" folder, you can find an .xlsx file containing the iconographic data for the graphic units (GU) analysed in this study. This table summarises the database created for analysis. The photogrammetric files for each GU could not be included in this repository due to the large volume of data. The models of the GUs are essential for the "Script.py" code in the next folder ("1 GIS") to function properly. These photogrammetric models were made in standard files (.obj for the 3D model, .tif for the texture, and .mtl for the mapping), and were archived after being georeferenced using common markers with the cave's point cloud. Later, the 3D model (.obj) for each GU was converted to a .wrl file, so that they could be processed through ArcGIS.


Next, in the "1 GIS" folder, we have stored the Python code for use in ArcGIS. For installation instructions, you can refer to the supplementary materials from the article with DOI https://doi.org/10.1007/s10816-022-09552-y, available through the following link: https://static-content.springer.com/esm/art%3A10.1007%2Fs10816-022-09552-y/MediaObjects/10816_2022_9552_MOESM1_ESM.pdf

In any case, We need the following files (With the name that we indicate): 
-CeilingsMax.wrl (the entire 3D of the cave, modified to show its paleo-state), 
-CeilingsMin.wrl (3D of the "internal ceilings" in the cave, the obstacles between 
-the ground and the highest Z), GroundOK.wrl (the ground level, presumably utilised 
-by the societies in the past), GU.wrl (3D of the analysed depiction), 
-Access.shp (the entrance used in the past).
-PUT THE FILES WITH THE CODE "Script.py" IN THE SAME FOLDER, "C/:Paleospeleology". (you need to create it)

<img width="1133" alt="image" src="https://github.com/inakiintxaurbe/spatial-organization-patterns-related-to-magdalenian-cave-art/assets/88764409/4d6fad67-e9ce-4016-9528-4a8c44fc4f84">

The "0 Output" folder, included within the "1 GIS" folder, contains a table that summarises the statistical data obtained by applying the code from this repository to each of the GUs analysed in this research.

Unfortunately, it was not possible to store the generated data for each of the GUs because of its size (each GU contains an average size of 1.5 Gb). 

* you can find some files to test the script in the following link: https://github.com/inakiintxaurbe/GIS_Test_Santimami-e_Old_Chamber_of_Paintings

To make it work, you need to install the script "paleospeleology.py" in ArcGIS Catalog.

<img width="1280" alt="image" src="https://github.com/inakiintxaurbe/GIS_Test_Santimami-e_Old_Chamber_of_Paintings/assets/88764409/ed4adac9-64e7-46ed-8e52-fcc0051d7694">
<img width="1280" alt="image" src="https://github.com/inakiintxaurbe/GIS_Test_Santimami-e_Old_Chamber_of_Paintings/assets/88764409/9833b795-40b0-4983-9ad8-3f7988f8f831">

Next, we launch the code:

<img width="1280" alt="image" src="https://github.com/inakiintxaurbe/GIS_Test_Santimami-e_Old_Chamber_of_Paintings/assets/88764409/76ad9b47-7e31-42f1-a79e-9bc112a7c8f7">
<img width="1280" alt="image" src="https://github.com/inakiintxaurbe/GIS_Test_Santimami-e_Old_Chamber_of_Paintings/assets/88764409/026f0820-17b6-4c4b-923a-a5e04f21c190">

After the analysis, we will obtain 5 folders with different files.

<img width="1280" alt="image" src="https://github.com/inakiintxaurbe/GIS_Test_Santimami-e_Old_Chamber_of_Paintings/assets/88764409/6700aeda-1910-4482-8de8-ca376c14d9a5">

The first folder called "Accessibility" contains some files of interest.

<img width="1280" alt="image" src="https://github.com/inakiintxaurbe/GIS_Test_Santimami-e_Old_Chamber_of_Paintings/assets/88764409/4c721c23-1f79-4d91-93f3-448a96d50d79">

The file "EstimatedPositionArtist.shp" contains the data for the "Distance to ground" and "Posture" variables:

<img width="611" alt="image" src="https://github.com/inakiintxaurbe/GIS_Test_Santimami-e_Old_Chamber_of_Paintings/assets/88764409/313c38dc-759a-4a80-961f-6492f30fca75">

The "Time.shp" file contains the data for the "Estimated Time of Arrival" variable:

<img width="438" alt="image" src="https://github.com/inakiintxaurbe/GIS_Test_Santimami-e_Old_Chamber_of_Paintings/assets/88764409/d9f97bc1-7941-43ab-9530-8f114ff5de26">

The "LCP.shp" file contains the data for the variables "Difficulty value of access" and "Least cost path lentgh":

<img width="642" alt="image" src="https://github.com/inakiintxaurbe/GIS_Test_Santimami-e_Old_Chamber_of_Paintings/assets/88764409/ae847331-9195-49fa-8de7-ca3647447ee8">

The fifth folder called "Visibility and Capacity" contains other files of interest.

<img width="1280" alt="image" src="https://github.com/inakiintxaurbe/GIS_Test_Santimami-e_Old_Chamber_of_Paintings/assets/88764409/af5ca2e8-0832-49e6-a802-ef5be99267f3">

The files "VisibilityStanding.tif", "VisibilityStooping.tif" and "VisibilityLyingDown.tif" contain the data for the variables "Viewers upright",	"Seated viewers" and	"viewers lying down".
The "Total viewers" variable is the sum of the last three variables. In the atribute table, the "Value" 1 is considered a low value of visibility (from that position can be seen between 0.01 and 33.33 % of the GU),
the "Value" 2 is considered a medium value of visibility (from that position can be seen between 33.33 and 66.66 % of the GU) and 3 is high value (between 66.66 and 100 % of the GU).
To count a person, we round a number: 4.58 vould be considered as minimun 5 viewers.

<img width="1279" alt="image" src="https://github.com/inakiintxaurbe/GIS_Test_Santimami-e_Old_Chamber_of_Paintings/assets/88764409/9f386624-ca60-4944-991b-754e519e7a6e">

The other 3 folders "Rock-Art", "Metadata" and "Topography" contain other interesting files to perform other studies (e.g., the file "Slope.tif" creates a plan of the ground, and the "LSSelect.shp" show the selected Lines of Sight in ArcScene.

<img width="795" alt="image" src="https://github.com/inakiintxaurbe/GIS_Test_Santimami-e_Old_Chamber_of_Paintings/assets/88764409/55905df8-6a1c-4a07-9e13-3276c5669f18">

There are other files in the folders.

We have not uploaded the other folders, because of their weight.

Finally, we have a folder called "2 Statistics" that contains an .xlsx table that combines the iconographic information of each figure extracted from the database summarised in the "0 Data" folder, as well as the results of the spatial analyses explained in (but unfortunately not yet stored in) the "1 GIS" folder.

We've also stored the code in R, used in multivariate analyses via the RStudio software (as well as the installed packages). This file is executable using the table contained in this folder.

We need to open the R code with Rstudio, as well as to download the table containing the summarized data.

<img width="893" alt="image" src="https://github.com/inakiintxaurbe/spatial-organization-patterns-related-to-magdalenian-cave-art/assets/88764409/d66bce31-0eed-4188-b9f2-a4bdcbb877d4">

(the 16th line must be changed according to the direction of the downladed table)

<img width="579" alt="image" src="https://github.com/inakiintxaurbe/spatial-organization-patterns-related-to-magdalenian-cave-art/assets/88764409/26521335-c085-44ea-bab6-363f9543fd5d">

Attention! We must change the direction of the bars.

<img width="891" alt="image" src="https://github.com/inakiintxaurbe/spatial-organization-patterns-related-to-magdalenian-cave-art/assets/88764409/b90f2365-f291-4550-a5b5-30fdb1891941">

After that, we select all and run the code:

<img width="894" alt="image" src="https://github.com/inakiintxaurbe/spatial-organization-patterns-related-to-magdalenian-cave-art/assets/88764409/d0b684d9-dfa7-4669-852b-8715aba80479">

We can observe the results in "Plot".

<img width="892" alt="image" src="https://github.com/inakiintxaurbe/spatial-organization-patterns-related-to-magdalenian-cave-art/assets/88764409/3c666493-d023-49f7-a3b4-3f865a30d05b">

The scripts can be edited by other researchers, according to their interests and problems. The results originated using this script can also be shared in this repository.
