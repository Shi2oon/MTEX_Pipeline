function startEBSD(fname,STP)
clc;    warning('off'); tic; close all
% addpath('P:\Abdo\GitHub\MyEBSD\Routine');   startup_mtex;
set(0, 'DefaultFigureVisible', 'on');       set(0,'defaultAxesFontSize',25)
addpath([pwd '\Routine'])
if exist([erase(fname,'.ctf') '_EBSD.mat'],'file') && ~contains(fname,'XEBSD')
    load([erase(fname,'.ctf') '_EBSD.mat']);
end
if ~exist('STEP','var')
    clearvars -except fname
    STEP = 1;
elseif exist('STP','var')
    STEP = STP;
end

%% prep
% path = pname; % path = fullfile(pname,name); %
while STEP<12
    switch STEP
        case 1
            path = erase(fname, '.ctf');         mkdir(path);
            try
                ebsd = loadEBSD([erase(fname, '.ctf') '.ctf'],'interface','ctf');%...
                %                                 ,'convertEuler2SpatialReferenceFrame');
            catch
                load(fname,'Map_EBSD_MTEX');
                ebsd = Map_EBSD_MTEX;
            end

            CS = ebsd.CSList;
            for iv = 1:length(ebsd.indexedPhasesId)
                if  strcmpi(CS{ebsd.indexedPhasesId(iv)}.mineral,'Ferrite, bcc (New)') ||...
                        strcmpi(CS{ebsd.indexedPhasesId(iv)}.mineral,'Iron-alpha')
                    CS{ebsd.indexedPhasesId(iv)}.opt.type='bcc';
                    ebsd.CSList{ebsd.indexedPhasesId(iv)}.mineral = 'Ferrite';
                    CS{ebsd.indexedPhasesId(iv)}.mineral = 'Ferrite';
                elseif  strcmpi(CS{ebsd.indexedPhasesId(iv)}.mineral,'Austenite, fcc (New)') ||...
                        strcmpi(CS{ebsd.indexedPhasesId(iv)}.mineral,'Iron-Austenite')
                    CS{ebsd.indexedPhasesId(iv)}.opt.type='fcc';
                    ebsd.CSList{ebsd.indexedPhasesId(iv)}.mineral = 'Austenite';
                    CS{ebsd.indexedPhasesId(iv)}.mineral = 'Austenite';
                elseif  strcmpi(CS{ebsd.indexedPhasesId(iv)}.mineral,'Silicon')
                    CS{ebsd.indexedPhasesId(iv)}.opt.type='fcc';
                elseif      strcmpi(CS{ebsd.indexedPhasesId(iv)}.mineral,'Moissanite 6H')
                    CS{ebsd.indexedPhasesId(iv)}.opt.type='fcc';
                    ebsd.CSList{ebsd.indexedPhasesId(iv)}.mineral = 'Moissanite';
                    CS{ebsd.indexedPhasesId(iv)}.mineral = 'Moissanite';
                elseif  strcmpi(CS{ebsd.indexedPhasesId(iv)}.mineral,'Moissanite')
                    CS{ebsd.indexedPhasesId(iv)}.opt.type='fcc';
                elseif  strcmpi(CS{ebsd.indexedPhasesId(iv)}.mineral,'Ni-superalloy') ||...
                        strcmpi(CS{ebsd.indexedPhasesId(iv)}.mineral,'Ni') ||...
                        strcmpi(CS{ebsd.indexedPhasesId(iv)}.mineral,'Nickel-cubic')
                    CS{ebsd.indexedPhasesId(iv)}.opt.type='fcc';
                    ebsd.CSList{ebsd.indexedPhasesId(iv)}.mineral = 'Nickel-cubic';
                    CS{ebsd.indexedPhasesId(iv)}.mineral = 'Nickel-cubic';
                end
            end
            setMTEXpref('xAxisDirection','east');% west for bruker
            %         setMTEXpref('yAxisDirection','south');
            setMTEXpref('zAxisDirection','intoPlane');% outOfPlane for bruker
            STEP = 2;

        case 2 % EBSd maps
            [ebsd,CS,grains,MisGB,Misanglede,TwinedArea] = GBs(ebsd,path,CS);     % EBSD map and GB related
            STEP = 3;
        case 3 % IPF and pole figures 
            [hw,odf,ODFerror] = PoleFigures(path,CS,ebsd,grains);	% (1/100*100%) = 1 from all points
            STEP = 4;
        case 4 % Schmid and Taylor factors 
            [SF,sS,SFM,mP,TraceSy] = SchmidTaylorEBSD(CS,ebsd,Misanglede,grains,path); % taylor and schmid
            STEP = 5;
        case 5 % 
                    PlotCrystalShape(ebsd,CS,grains,MisGB,Misanglede,sS,path); % crystal in ebsd map
            STEP = 6;
        case 6 % traces
            if length(grains)<4
                for iV =1:length(grains)
                    Direction = {'X','Z'};
                    for IO = 1:length(Direction)
                        SlipTraces(ebsd(grains(iV)),grains(iV),[path '\EBSD Maps\'...
                            num2str(iV)],Direction{IO});
                    end
                end
            end
            %
            STEP = 7;
        case 7 % local SF: https://doi.org/10.1016/j.actamat.2016.12.066
            [~,LSF]     = Local_SF(CS,ebsd,grains,path);                                % LSF
            STEP = 8;
            %
        case 8 % GNDS
            [GND]       = GndsCalc(path,CS,ebsd,grains);                                % Gnds
            STEP = 9;
        case 9 % Stifness per grain
            [Stiffness] = StiffnessEBSD(ebsd);
            STEP = 10;
        case 10 % HR-ESBD merge
%             if exist([erase(fname,'.ctf') '_XEBSD.mat']) ~= 0
%                 load([erase(fname,'.ctf') '.mat']);
%                 [Maps] = loadingXEBSD([erase(fname,'.ctf') '_XEBSD.mat']);
%                 if exist('Stiffness')~=0
%                     Maps.C4D = Stiffness; % computed stifness
%                 end
%             end
            STEP = 11;
        case 11
            if length(CS)>1 && length(CS)<10
                if strcmpi(CS{1},'notIndexed')
                    notIndexed(ebsd,path);                      % raw output
                    [ebsd,CS,~]  = IndexAndFill(ebsd,CS);	% fill
                end
            else
                csa{1} = CS;    CS = csa;
            end
            ebsd=fill(ebsd);
            if strcmpi(CS{1},'notIndexed');     CS(1) = [];     end
            ebsd2abaqus(ebsd,fname)                         % Abaqus
            %}
            STEP = 12;
    end
    save([erase(fname,'.ctf') '_EBSD.mat']); close all

end
%% the end
clc;    fprintf('file at %s \nwith %d measurement points took %.1f minutes\n',...
    path,length(ebsd),toc/60);