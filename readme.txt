Install mtex included with program as I did few edits to MTEX itself and yet to push it to the other to be included.

all you need to do then is run the startEBSD function as below

startEBSD('full directory of the .ctf file')

This MTEX analysis pipeline for data from Oxford system (I think I got the orientation right but please have a play with it using your data and let me know. For now it accommodates austenite, ferrite, moissanite, silicon ad Nikel (all cubic) but can be modified to include more materials maybe hexagonal.


** make sure to install the mtex included with the code as it edited to work with code, I did not push these changes to MTEX authors for approval yet .. so be patient as I'm improving this code to part of MTEX **

The code gives: 1) EBSD maps with some statistics (I can add more as required).

2) pole figures (won't work if MTEX is not installed properly)

3) Schmid and Taylor factors

4) plot the crystal shape orientation in the maps for illustration

5) plot traces if you have less than 4 grains but can be made to plot the slip traces of a specific grain

6) Local schmid factor (see: https://doi.org/10.1016/j.actamat.2016.12.066)

7) Hough based GNDs (see: https://iopscience.iop.org/article/10.1088/1757-899X/304/1/012003/meta)

8) Anisotropic stiffness matrix, including Young modulus, Posion ration, and shear modulus (see: supplementary material: https://www.sciencedirect.com/science/article/abs/pii/S1359645421005838)

9) create an abaqus model


feel free to remove the comment and try them and let me know how I can help/improve


grainGropu function is good if you want to look to a specific grain and you a have HR-EBSD, it does some fancy calculation for the slip tracing (reference is under review)
