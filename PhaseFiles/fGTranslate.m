function [ stiffvalues] = fGTranslate(mineral)
%fGTranslate - translates the names of phases from astro to MTEX to load
%the correct cif file.
%CMM 2019
%Utilises MTEX codes - working with v5

   
    %Here is a library that compares names from BRUKER to MTEX 5.1.1 and up
    %There are some phases which have problems: fcc Moly, and hcp Nickel
    %These are presently not included
    
    %Here's how to add phases: 
    %put in the name from bruker/oxford with quotes, and a comma, and the name of the cif file
    phasenames={'Silver' , 'Silver'; 
    'Corundum' , 'Corundum';
    'Aluminium' , 'Aluminium';
    'Aluminum' , 'Aluminium';
    'Diamond', 'Diamond';
    'Chromium' , 'Chromium';
    'Chromium - alpha' ,  'Chromium';
    'Copper', 'Copper';
    
    'Iron', 'Iron-alpha';
    'Austenite', 'Iron-Austenite';
    'Ferrite', 'Iron-alpha';
    'Austenite, fcc (New)', 'Iron-Austenite';
    'Ferrite, bcc (New)', 'Iron-alpha';
    'Iron-beta', 'Iron-beta';
    'Iron-delta', 'Iron-delta';
    'Titanium aluminide (1/1)', 'TiAl-Gamma'; 
    'Aluminium titanium (1/3)', 'Ti3Al'; 
    'Ti3Al', 'Ti3Al'; 
    'Ti_3Al', 'Ti3Al'; 
    'Titanium aluminide (1/3)', 'TiAl3'; 
    'TiAl3', 'TiAl3';
    'TiAl_3', 'TiAl3';
    
    'Hematite', 'Hematite';
    'Magnetite', 'Magnetite';
    'Magnesium' , 'Magnesium';
    'Manganese-gamma','Manganese-gamma';
    'Molybdenum','Molybdnenum-bcc'; %(CATCH IF FCC)
    'Halite','Halite';
    'GaAs','GaAs';
    'Nickel','Nickel-cubic';
    %'Nickel','Nickel-hexagonal'; %(CATCH Is this a thing??)
    'Olivine','Olivine';
    'Quartz','Quartz';
    'Silicon','Silicon';
    'Titanium','Titanium-alpha';
    'Titanium-beta','Titanium-beta';
    'Baddeleyite','Baddeleyite'
    'Zirconium','Zirconium-bcc';
    'Zirconium - alpha','Zirconium-hcp';
    'Moissanite', 'Moissanite';
    'Tungsten', 'Tungsten';
    'Lithium','Lithium'};
    
 
    phasenamenumber = strcmp(phasenames(:,1), mineral); % find the row with the right name
    cifs=char(phasenames(phasenamenumber,2)); %use the other column to translate

    [stiffvalues] = lStiffness(cifs);
end
