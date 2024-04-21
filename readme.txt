Install mtex included with program as I did few edits to MTEX itself and yet to push it to the other to be included.

all you need to do then is run the startEBSD function as below

startEBSD('full directory of the .ctf file')

This MTEX analysis pipeline for data from the Oxford system (I think I got the orientation right, but please have a play with it using your data and let me know) accommodates austenite, ferrite, moissanite, silicon, and Nikel (all cubic) but can be modified to include more materials, maybe hexagonal.


** make sure to install the MTEX included with the code as it is edited to work with the code; I did not push these changes to MTEX authors for approval yet .. so be patient as I'm improving this code to part of MTEX **

The code gives (order in the steps included in the code, which can be accessed via the STP variable when using the startEBSD function): 
1) reorganise and fill in the data

2) EBSD maps with some statistics (function name "GBs")

3) pole figures (function name "PoleFigures"), won't work if MTEX is not installed properly

4) Schmid and Taylor factors (SchmidTaylorEBSD)

5) plot the crystal shape orientation in the maps for illustration (PlotCrystalShape)

6) plot traces if you have less than 4 grains but can be made to plot the slip traces of a specific grain (SlipTraces); see details at https://ora.ox.ac.uk/objects/uuid:f2ba08f3-4a27-4619-92ed-bcd3834dadf0/files/d765371972, pages 106-107.
The function produces a couple of figures, including the legend. The correct oreination of the trace is the one included in the EBSD map. I do not know why, but MATLAB messes up the plotting coordinates. Reach out at abdo.aog@gmail.com if you have questions.

7) Local Schmid factor (see: https://doi.org/10.1016/j.actamat.2016.12.066)

8) Hough based GNDs (see: https://iopscience.iop.org/article/10.1088/1757-899X/304/1/012003/meta)

9) Anisotropic stiffness matrix, including Young modulus, Poisson ratio, and shear modulus (see supplementary material: https://doi.org/10.1016/j.actamat.2021.117203)

10) merging data from xEBSD code with MTEX (currently deactivated)

11) create an Abaqus model

feel free to remove the comments and try them and let me know how I can help/improve

grainGropu function is good if you want to look to a specific grain and you have HR-EBSD; it does some fancy calculations for the slip tracing (see supplementary material: https://doi.org/10.1016/j.actamat.2022.118284, local xSF)
