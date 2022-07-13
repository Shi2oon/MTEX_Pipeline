Install mtex included with program as I did few edits to MTEX itself and yet to push it to the other to be included.

all you need to do then is run the startEBSD function as below

startEBSD('full directory of the .ctf' file)

This MTEX analysis pipeline for data from Oxford system (I think I got the orientation right but please have a play with it using your data and let me know. For know it accommodates austenite, ferrite,  moissanite, silicon ad Nikel (all cubic) but can be modified to include more and more materials maybe hexagonal.


The code gives: 1) EBSD maps with some statistics (I can add more as required).
2) pole figures (although I commented it out because it takes a lot of time)
3) Schmid and Taylor factors

4) plot the crystal shape orientation in the maps for illustration 

5) plot traces if you have less than 4 grains but can be made to plot the slip traces of a specific grain

6) Local schmid factor (see: https://doi.org/10.1016/j.actamat.2016.12.066)

7) Hough-based GNDs

8) Anisotropic stiffness matrix, including Young modulus, Posion ration, and shear modulus 
9) create an abaqus module (have not used for a while, may need some changes) 



most of these options are commented out because they take time, but feel free to remove the comment and try them and let me know how I can help/improve
