function [stiffvalues] = lStiffness(materials)
%New code for stiffness matrices - CMM 2019. Gives the correct stiffness matrix for the phases. Most data either from xebsdv2,
%or from crosscourt materials.txt (probably Simons and Wagg).
%http://dsk.ippt.pan.pl/docs/abaqus/v6.13/books/usb/default.htm?startat=pt05ch22s02abm02.html
phasestiffness(1).name='Silver';
phasestiffness(1).stiff=[123.99,93.67,	93.67,	0,  0,	0;
    93.67,	123.99,	93.67,  0,	0,	0;
    93.67,	93.67, 123.99,	0,	0,	0;
    0,	0,	0,46.12, 0,	0;
    0,	0,  0,	0,46.12,  0;
    0,  0,	0,	0,	0,46.12];

phasestiffness(2).name='Corundum';
phasestiffness(2).stiff=[497.350000000000,163.970000000000,112.200000000000,-23.5800000000000,0,0;
    163.970000000000,497.350000000000,112.200000000000,23.5800000000000,0,0;
    112.200000000000,112.200000000000,499.110000000000,0,0,0;
    -23.5800000000000,23.5800000000000,0,147.390000000000,0,0;
    0, 0,0,0,147.390000000000,-23.5800000000000;
    0, 0,0,0,-23.5800000000000,166.690000000000];

phasestiffness(3).name='Aluminium';
phasestiffness(3).stiff=    [106.750000000000,60.4100000000000,60.4100000000000,0,0,0;
    60.4100000000000,106.750000000000,60.4100000000000,0,0,0;
    60.4100000000000,60.4100000000000,106.750000000000,0,0,0;
    0,0,0,28.3400000000000,0,0;
    0,0,0,0,28.3400000000000,0;
    0,0,0,0,0,28.3400000000000];

phasestiffness(4).name='Diamond';
phasestiffness(4).stiff=[1040,170,170,0,0,0;
    170,1040,170,0,0,0;
    170,170,1040,0,0,0;
    0,0,0,550,0,0;
    0,0,0,0,550,0;
    0,0,0,0,0,550];

phasestiffness(5).name='Chromium';
phasestiffness(5).stiff=[339.800000000000,58.6000000000000,58.6000000000000,0,0,0;
    58.6000000000000,339.800000000000,58.6000000000000,0,0,0;
    58.6000000000000,58.6000000000000,339.800000000000,0,0,0;
    0,0,0,99,0,0;
    0,0,0,0,99,0;
    0,0,0,0,0,99];

phasestiffness(6).name='Copper';
phasestiffness(6).stiff=[168.300000000000,122.100000000000,122.100000000000,0,0,0;
    122.100000000000,168.300000000000,122.100000000000,0,0,0;
    122.100000000000,122.100000000000,168.300000000000,0,0,0;
    0,0,0,75.7000000000000,0,0;
    0,0,0,0,75.7000000000000,0;
    0,0,0,0,0,75.7];

phasestiffness(7).name='Lithium';
phasestiffness(7).stiff=[13.5,	11.44,	11.44,	0	,0	,0	;
    11.44	,13.5	,11.44	,0	,0	,0	;
    11.44	,11.44	,13.5	,0	,0	,0	;
    0	,0	,0	,8.78	,0	,0	;
    0	,0	,0	,0	,8.78	,0	;
    0	,0	,0	,0	,0	,8.78];

phasestiffness(8).name='Iron-alpha';
phasestiffness(8).stiff=[230	,135    ,135    ,0      ,0      ,0;
                        135     ,230    ,135    ,0      ,0      ,0;
                        135     ,135    ,230    ,0      ,0      ,0;
                        0       ,0      ,0      ,117    ,0      ,0;
                        0       ,0      ,0      ,0      ,117    ,0;
                        0       ,0      ,0      ,0      ,0      ,117];

phasestiffness(9).name='Iron-Austenite';
phasestiffness(9).stiff=[231.400000000000,134.700000000000,134.700000000000,0,0,0;
    134.700000000000,231.400000000000,134.700000000000,0,0,0;
    134.700000000000,134.700000000000,231.400000000000,0,0,0;
    0,0,0,116.400000000000,0,0;
    0,0,0,0,116.400000000000,0;
    0,0,0,0,0,116.400000000000];

phasestiffness(10).name='Iron-beta';
%no stiffness matrix
phasestiffness(11).name='Iron-delta';
%no stiffness matrix

phasestiffness(12).name='Hematite';
phasestiffness(12).stiff=[242.430000000000,54.6400000000000,15.4200000000000,-12.4700000000000,0,0;
    54.6400000000000,242.430000000000,15.4200000000000,12.4700000000000,0,0;
    15.4200000000000,15.4200000000000,227.340000000000,0,0,0;
    -12.4700000000000,12.4700000000000,0,85.6900000000000,0,0;
    0,0,0,0,85.6900000000000,-12.4700000000000;
    0,0,0,0,-12.4700000000000,93.8950000000000];

phasestiffness(13).name='Magnetite';
phasestiffness(13).stiff=[273,106,106,0,0,0;
    106,273,106,0,0,0;
    106,106,273,0,0,0;
    0,0,0,97.1000000000000,0,0;
    0,0,0,0,97.1000000000000,0;
    0,0,0,0,0,97.1000000000000];

phasestiffness(14).name='Magnesium';
phasestiffness(14).stiff=[59.5000000000000,26.1200000000000,21.8000000000000,0,0,0;
    26.1200000000000,59.5000000000000,21.8000000000000,0,0,0;
    21.8000000000000,21.8000000000000,61.5500000000000,0,0,0;
    0,0,0,16.3500000000000,0,0;
    0,0,0,0,16.3500000000000,0;
    0,0,0,0,0,16.6900000000000];

phasestiffness(15).name='Manganese-gamma';
%no stiffness matrix

phasestiffness(16).name='Molybdnenum-bcc';
phasestiffness(16).stiff=[463.700000000000,157.800000000000,157.800000000000,0,0,0;
    157.800000000000,463.700000000000,157.800000000000,0,0,0;
    157.800000000000,157.800000000000,463.700000000000,0,0,0;
    0,0,0,109.200000000000,0,0;
    0,0,0,0,109.200000000000,0;
    0,0,0,0,0,109.200000000000];

phasestiffness(17).name='Halite';
phasestiffness(17).stiff=[49.4700000000000,12.8800000000000,12.8800000000000,0,0,0;
    12.8800000000000,49.4700000000000,12.8800000000000,0,0,0;
    12.8800000000000,12.8800000000000,49.4700000000000,0,0,0;
    0,0,0,12.8700000000000,0,0;
    0,0,0,0,12.8700000000000,0;
    0,0,0,0,0,12.8700000000000];

phasestiffness(18).name='GaAs';
phasestiffness(18).stiff=[48.8000000000000,41.4000000000000,41.4000000000000,0,0,0;
    41.4000000000000,48.8000000000000,41.4000000000000,0,0,0;
    41.4000000000000,41.4000000000000,48.8000000000000,0,0,0;
    0,0,0,14.8000000000000,0,0;
    0,0,0,0,14.8000000000000,0;
    0,0,0,0,0,14.8000000000000]; %DO CHECK WHETHER THESE ARE CORRECT - will depend on manufacturing route.

phasestiffness(19).name='Nickel-cubic';
phasestiffness(19).stiff=[249 152 152 0 0 0;
    152 249 152 0 0 0;
    152 152 249 0 0 0;
    0 0 0 124 0 0;
    0 0 0 0 124 0;
    0 0 0 0 0 124];

phasestiffness(20).name='Olivine';
phasestiffness(20).stiff=[324,59,79,0,0,0;
    59,198,78,0,0,0;
    79,78,249,0,0,0;
    0,0,0,66.7000000000000,0,0;
    0,0,0,0,81,0;
    0,0,0,0,0,79.3000000000000];

phasestiffness(21).name='Quartz';
phasestiffness(21).stiff=[86.8000000000000,7.04000000000000,11.9100000000000,-18.0400000000000,0,0;
    7.04000000000000,86.8000000000000,11.9100000000000,18.0400000000000,0,0;
    11.9100000000000,11.9100000000000,105.750000000000,0,0,0;
    -18.0400000000000,18.0400000000000,0,58.2000000000000,0,0;
    0,0,0,0,58.2000000000000,-18.0400000000000;
    0,0,0,0,-18.0400000000000,39.8800000000000];

phasestiffness(22).name='Silicon';
phasestiffness(22).stiff=[165,64,64,0,0,0;
    64,168,64,0,0,0;
    64,64,165,0,0,0;
    0,0,0,79.2,0,0;
    0,0,0,0,79.2,0;
    0,0,0,0,0,79.2];

phasestiffness(23).name='Titanium-alpha';
phasestiffness(23).stiff=[162.4,92,69,0,0,0;
    92,162.4,69,0,0,0;
    69,69,180.7,0,0,0;
    0,0,0,46.7,0,0;
    0,0,0,0,46.7,0;
    0,0,0,0,0,35.2];


phasestiffness(24).name='Titanium-beta'; %https://doi.org/10.3390/met8100822
phasestiffness(24).stiff=[134,110,110,0,0,0;
    110,134,110,0,0,0;
    110,110,110,0,0,0;
    0,0,0,55,0,0;
    0,0,0,0,55,0;
    0,0,0,0,0,55];

phasestiffness(25).name='Baddeleyite'; %WILLI PABST, GABRIELA TICHÁ, EVA GREGOROVÁ, 2004
phasestiffness(25).stiff=[327,100,62,0,0,0;
    100,327,62,0,0,0;
    62,62,264,0,0,0;
    0,0,0,64,0,0;
    0,0,0,0,64,0;
    0,0,0,0,0,64];

phasestiffness(26).name='Zirconium-bcc'; %"Lattice dynamics of hcp and bcc zirconium", Jerel L. Zarestky, 1979
phasestiffness(26).stiff=[143.4,72.8,65.3,0,0,0;
    72.8,143.4,65.3,0,0,0;
    65.3,65.3,164.8,0,0,0;
    0,0,0,32,0,0;
    0,0,0,0,32,0;
    0,0,0,0,0,75.3];

phasestiffness(27).name='Zirconium-hcp'; %xebsd2
phasestiffness(27).stiff=[143.4,72.8,65.3,0,0,0;
    72.8,143.4,65.3,0,0,0;
    65.3,65.3,164.8,0,0,0;
    0,0,0,32,0,0;
    0,0,0,0,32,0;
    0,0,0,0,0,35.3];

phasestiffness(28).name='Moissanite';
phasestiffness(28).stiff=[504	,98	,56	,0	,0	,0	;
    98	,504	,56	,0	,0	,0	;
    56	,56	,566	,0	,0	,0	;
    0	,0	,0	,170	,0	,0	;
    0	,0	,0	,0	,170	,0	;
    0	,0	,0	,0	,0	,154];

phasestiffness(29).name='Tungsten'; %crosscourt, not xebsd2
phasestiffness(29).stiff=[522.39, 204.37, 204.37, 0	,0	,0;
    204.37	,522.39	,204.37	,0	,0	,0;
    204.37	,204.37	,522.39	,0	,0	,0;
    0	,0	,0	,160.83	,0	,0;
    0	,0	,0	,0	,160.83	,0;
    0	,0	,0	,0	,0	,160.83];

% Titanium aluminide (1/1)
phasestiffness(30).name  = 'TiAl-Gamma'; 
phasestiffness(30).stiff = [200	62	84	0	0	0
                            62	200	84	0	0	0
                            84	84	174	0	0	0
                            0	0	0	112	0	0
                            0	0	0	0	112	0
                            0	0	0	0	0	41];
                        
% Aluminium titanium (1/3)
phasestiffness(31).name  = 'Ti3Al'; 
phasestiffness(31).stiff = [192	85	63	0	0	0
                            85	192	63	0	0	0
                            63	63	234	0	0	0
                            0	0	0	60	0	0
                            0	0	0	0	60	0
                            0	0	0	0	0	54];
                        
% titanium Aluminium  (1/3)
phasestiffness(32).name  = 'TiAl3'; 
phasestiffness(32).stiff = [189	64	64	0	0	0
                            64	189	64	0	0	0
                            64	64	189	0	0	0
                            0	0	0	73	0	0
                            0	0	0	0	73	0
                            0	0	0	0	0	73];

      
%OLD CODE
%{                
stiffnessheaders={'Titanium (Alpha)','Titanium','Silicon','Copper','Iron (Alpha)','Iron-alpha','Tungsten','Zirconium (Alpha)','Zirconium','Nickel','Titanium-beta'};

stiffarray={mti,mti,msi,mcu,mfe,mfe,mw,mzr,mzr,mni,mw};  %note I have made beta W stiffness for now - this needs fixign!              
      
t=strcmpi(stiffnessheaders,materials);
x=stiffarray(t);
stiffvalues=cell2mat(x);
%}                

t = strcmp({phasestiffness(:).name}, materials); % find the field with the right name
stiffvalues=phasestiffness(t).stiff; %use the field for the stiffness matrix

if strcmpi('GaAs',materials)==1 %Quick catch for GaAs values
    disp('Please check if stiffness matrix for Gallium Arsenide phase is correct')
end

end


