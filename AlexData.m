clear; clc; close all; warning off
addpath(erase(pwd,'\MyCode'));  
startup_mtex; 
addpath([pwd '\Routine']);    addpath([pwd '\Data']);
%import_wizard('EBSD')
%AnnotateR2p4

%% Data List
for i=1:13%:15
    clc; close all; clearvars -except i
    if      i==1;        Alex_Grains_REFEL_3_3_60
    elseif  i==2;        Alex_Grains_refel_8_60
    elseif  i==3;        Alex_Grains_refel_Si_region_1
    elseif  i==4;        Alex_Grains_Starceram_181218
    elseif  i==5;        Alex_Indent_001_berko_3rd_face
    elseif  i==6;        Alex_Indent_6H_750_irr_1000nm_080219
    elseif  i==7;        Alex_Indent_6H_Ne_1000nm_110219
    elseif  i==8;        Alex_Indent_1700x2000nmBerkoindent
    elseif  i==9;        Alex_Indent_berko_2nd_face
    elseif  i==10;       Alex_Indent_Ne_1000nm_indent_25
    elseif  i==11;       Alex_Indent_Si_1000nm_unirr_32
    elseif  i==12;       Alex_Indent_Si_unirr_indent3_2
    elseif  i==13;       Alex_Indent_unirr_6H_1000nm       
    end
    
    % Script for EBSD Data
    startEBSD
end