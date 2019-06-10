addpath('C:\Users\Abdul Mohammed\Documents\GitHub\mtex-5.2.beta2');     startup_mtex;
addpath('C:\Users\Abdul Mohammed\Documents\GitHub\STABiX');             path_management
addpath('C:\Users\Abdul Mohammed\Documents\GitHub\MyCode');
addpath('C:\Users\Abdul Mohammed\Documents\GitHub\MyCode\Data');
addpath('C:\Users\Abdul Mohammed\Documents\GitHub\MyCode\Analysis');
addpath('C:\Users\Abdul Mohammed\Documents\GitHub\Play trace');        

%% YAML: is a human friendly data serialization standard for all programming languages.”
username_get

%% libraries
demo            %Start and run other GUIs.
A_gui_plotmap   %map GUI Analysis of slip transmission across GBs for an EBSD map.
A_gui_plotGB_Bicrystal %Analysis of slip transfer in a bicrystal.
%Preprocess of CPFE models for indentation or scratch in a SX.
A_preCPFE_windows_indentation_setting_SX
%Preprocess of CPFE models for indentation or scratch in a BX.
A_preCPFE_windows_indentation_setting_BX 
A_gui_gbinc     %Calculation of grain boundaries inclination.

%% Bicrystal
% The grain boundary trace angle is obtained through the EBSD measurements 
% (grain boundary endpoints coordinates) and the grain boundary inclination 
% can be assessed by a serial polishing (chemical-mechanical polishing or 
% FIB sectioning), either parallel or perpendicular to the surface of the sample
sym_operators   % define the symmetry operators for cubic and hexagonal crystals
eulers2g        % calculate the orientation matrix from Euler angles
g2eulers        % calculate Euler angles from the orientation matrix
misorientation  % calculate the misorientation angle

%% Slip Transmission Anlysis
% Geometrical Criteria
N_factor        % N factor from Livingston and Chalmers in 1957
LRB_parameter   % LRB factor from Shen et al. in 1986
mprime          % m? parameter from Luster and Morris in 1995, resistance factor=1-m'
residual_Burgers_vector % br the residual Burgers vector 
                        % M.J. Marcinkowski and W.F. Tseng 1970
misorientation  % The misorientation or disorientation
                % K.T. Aust and N.K. Chen 1954
lambda          % function from Werner and Prantl 1990
      lambda_plot_values % to plot pseudo-3D view of the the function
lambda_modified % modified by Beyerlein et al.
      
% Stress Criteria
resolved_shear_stress     % Schmid Factor (m),max J.R. Seal et al 2012 & W.Z. Abuzaid et al
generalized_schmid_factor % Generalized Schmid Factor (GSF)  C.N. Reid 1973
resolved_shear_stress     % Resolved Shear Stress at the head of the 
                          % accumulated dislocations

% Combination of Criteria and others
s_factor       % Geometrical function weighted by the accumulated shear stress or the
                % Schmid factor T.R. Bieler et al 2014            
slip_systems    % List of slip and twin systems for BCC/FCC/HCP phase material