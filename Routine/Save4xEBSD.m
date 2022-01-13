function [Values]=Save4xEBSD(pname,fname)
DirxEBSD  = [erase(fname,'.ctf') '_XEBSD.mat'];
DirSave   = [erase(fname,'.ctf') '.mat']; 
        
if  exist(DirxEBSD) == 0 % check if its been already processed
        addpath('P:\Abdo\GitHub\xEBSDv3');
     if  exist([erase(fname,'ctf') 'h5']) == 2
            input_deck1(pname,fname,  'h5');          % type 'OIM' or 'Bruker' or 'HKL' or 'h5'   
     else
            input_deck1(pname,fname,'Bruker');      % type 'OIM' or 'Bruker' or 'HKL' or 'h5' 
     end 
end

load(DirSave);     
load(DirxEBSD,'Maps','GND','iPut','Data','Astro_Loc');      	

if  exist('GND') == 1  
    if isempty(GND) ~=1;    Values.GND = GND.total; end  % from xEBSD;
end
% rotation
Values.W11  = Maps.W11_F1;   Values.W12 = Maps.W12_F1;	Values.W13 = Maps.W13_F1;           
Values.W21  = Maps.W21_F1;   Values.W22 = Maps.W22_F1;	Values.W23 = Maps.W23_F1;    
Values.W31  = Maps.W31_F1;  	Values.W32 = Maps.W32_F1;   Values.W33 = Maps.W33_F1;  
Values.PH_2 = Maps.PH_2;

if     exist('Astro_Loc') == 0  % old version of xEBSD
% stress
Values.S11 = Maps.S11_2;	Values.S12 = Maps.S12_2;    Values.S13 = Maps.S13_2;         	
Values.S22 = Maps.S22_2;    Values.S23 = Maps.S23_2;   	Values.S33 = Maps.S33_2;  
%strain
Values.E11 = Maps.S11_2; 	Values.E12 = Maps.S12_2;    Values.E13 = Maps.S13_2;          	
Values.E22 = Maps.S22_2;    Values.E23 = Maps.S23_2;  	Values.E33 = Maps.S33_2;
%
Values.Stiffness  = iPut.stiffnessvalues;
Values.X   = Data.X;        Values.Y   = Data.Y;
    
elseif exist('Astro_Loc') == 1 %NEW xEBSD version
load(DirxEBSD,'Map_stress_sample','Map_strain_sample','C_rotated','Map_A0_sample');
% displacement gradient tensor
Values.A11 = Map_A0_sample(:,:,1,1);        Values.A12 = Map_A0_sample(:,:,1,2);  
Values.A13 = Map_A0_sample(:,:,1,3);        Values.A21 = Map_A0_sample(:,:,2,1);  
Values.A22 = Map_A0_sample(:,:,2,2);        Values.A23 = Map_A0_sample(:,:,2,3);  
Values.A31 = Map_A0_sample(:,:,3,1);        Values.A32 = Map_A0_sample(:,:,3,2); 
Values.A33 = Map_A0_sample(:,:,3,3);
% stress
Values.S11 = Map_stress_sample(:,:,1,1);    Values.S12 = Map_stress_sample(:,:,1,2);
Values.S13 = Map_stress_sample(:,:,1,3);    Values.S22 = Map_stress_sample(:,:,2,2);
Values.S23 = Map_stress_sample(:,:,2,3);    Values.S33 = Map_stress_sample(:,:,3,3);
% strain
Values.E11 = Map_strain_sample(:,:,1,1);    Values.E12 = Map_strain_sample(:,:,1,2);
Values.E13 = Map_strain_sample(:,:,1,3);    Values.E22 = Map_strain_sample(:,:,2,2);
Values.E23 = Map_strain_sample(:,:,2,3);    Values.E33 = Map_strain_sample(:,:,3,3); 
%
Values.Stiffness  = C_rotated;       
Values.X   = Data.XSample;               	Values.Y   = Data.YSample;
end     

Values.stepsize =(abs(Values.X(1,1)-Values.X(1,2)));