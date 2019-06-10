function [II,J]=decideSubPlot(numbers)

if      numbers/2==1 || round(numbers/2)==1
        II=1;       J=2;    %2
elseif  numbers/2==2 || round(numbers/2)==2
        II=2;       J=2;    %4
elseif  numbers/2==3 || round(numbers/2)==3
        II=2;       J=3;    %6
elseif  numbers/2==4 || round(numbers/2)==4
        II=2;       J=4;    %8
elseif  numbers/3==3 
        II=3;       J=3;    %9
elseif  numbers/2==5
        II=5;       J=2;    %10
elseif  numbers/2==6 || round(numbers/2)==6
        II=3;       J=4;    %12
end
        
        
        