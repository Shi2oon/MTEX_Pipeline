function Xplot(LN,fSize)
%% Plotting and save
    %% GNDs
    Singleplot(LN.Tot ,log10(LN.GND),'GNDs','\rho_{GNDs} [log(m/m^{3})]',fSize,[LN.Dir '\GNDs'])
    
    %% Rotation
    Singleplot(LN.Tot ,LN.W12,'\omega_{12}','\omega_{12} [rad]',fSize,[LN.Dir '\W_12']);
    Singleplot(LN.Tot ,LN.W13,'\omega_{13}','\omega_{13} [rad]',fSize,[LN.Dir '\W_13']);
    Singleplot(LN.Tot ,LN.W21,'\omega_{21}','\omega_{21} [rad]',fSize,[LN.Dir '\W_21']);
    Singleplot(LN.Tot ,LN.W23,'\omega_{23}','\omega_{23} [rad]',fSize,[LN.Dir '\W_23']);
    Singleplot(LN.Tot ,LN.W31,'\omega_{31}','\omega_{31} [rad]',fSize,[LN.Dir '\W_31']);
    Singleplot(LN.Tot ,LN.W32,'\omega_{32}','\omega_{32} [rad]',fSize,[LN.Dir '\W_32']);
    
    %% Stress
    Singleplot(LN.Tot,abs(LN.S11),'\sigma_{11}','\sigma_{11} [GPa]',fSize,[LN.Dir '\S_11']);
    Singleplot(LN.Tot,abs(LN.S12),'\sigma_{12}','\sigma_{12} [GPa]',fSize,[LN.Dir '\S_12']);
    Singleplot(LN.Tot,abs(LN.S13),'\sigma_{13}','\sigma_{13} [GPa]',fSize,[LN.Dir '\S_13']);
    Singleplot(LN.Tot,abs(LN.S22),'\sigma_{22}','\sigma_{22} [GPa]',fSize,[LN.Dir '\S_22']);
    Singleplot(LN.Tot,abs(LN.S23),'\sigma_{23}','\sigma_{23} [GPa]',fSize,[LN.Dir '\S_23']);
    
    %% Kplot(Xum,SGPa,ti,label,fSize,SavDir) do it manually instead, eq
    % included in createFit function K = f1.k  ± (1-gof.adjrsquare)  MPa\surdm
    Kplot(LN.Tot,abs(LN.S11),'\sigma_{11}','\sigma_{11} [GPa]',fSize,[LN.Dir '\S_11']);
    Kplot(LN.Tot,abs(LN.S12),'\sigma_{12}','\sigma_{12} [GPa]',fSize,[LN.Dir '\S_12']);
    Kplot(LN.Tot,abs(LN.S13),'\sigma_{13}','\sigma_{13} [GPa]',fSize,[LN.Dir '\S_13']);
    Kplot(LN.Tot,abs(LN.S22),'\sigma_{22}','\sigma_{22} [GPa]',fSize,[LN.Dir '\S_22']);
    Kplot(LN.Tot,abs(LN.S23),'\sigma_{23}','\sigma_{23} [GPa]',fSize,[LN.Dir '\S_23']);
    
    %% Strain
    Singleplot(LN.Tot,abs(LN.E11),'\epsilon_{11}','\epsilon_{11} [Abs.]',fSize,[LN.Dir '\E_11']);
    Singleplot(LN.Tot,abs(LN.E12),'\epsilon_{12}','\epsilon_{12} [Abs.]',fSize,[LN.Dir '\E_12']);
    Singleplot(LN.Tot,abs(LN.E13),'\epsilon_{13}','\epsilon_{13} [Abs.]',fSize,[LN.Dir '\E_13']);
    Singleplot(LN.Tot,abs(LN.E22),'\epsilon_{22}','\epsilon_{22} [Abs.]',fSize,[LN.Dir '\E_22']);
    Singleplot(LN.Tot,abs(LN.E23),'\epsilon_{23}','\epsilon_{23} [Abs.]',fSize,[LN.Dir '\E_23']);
    Singleplot(LN.Tot,abs(LN.E33),'\epsilon_{33}','\epsilon_{33} [Abs.]',fSize,[LN.Dir '\E_33']);
end

