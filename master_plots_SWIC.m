%% master_plots_SWIC.m
%  Example script on how to use the RadarSWIC code to invert the HF Radar signal
%  It uses data from two beams from two radar sites or two beams from single 
%  radar site as described in Alattabi et al., 2021 to reproduce Figures x and y in the paper.
%
%% Copyright 
%  2021 Zaid Alattabi, Douglas Cahl, George Voulgaris
%
%  This program is free software: you can redistribute it and/or modify
%  it under the terms of the GNU General Public License as published by
%  the Free Software Foundation, either version 3 of the License, or
%  (at your option) any later version.
%
%  This program is distributed in the hope that it will be useful,
%  but WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%  GNU General Public License for more details.
%
%  You should have received a copy of the GNU General Public License
%  along with this program.  If not, see <https://www.gnu.org/licenses/>.
%
%% Use data from PEN and PER beams pointed at bouy site (see Alattabui et al., 2021)
addpath('lib')
basedir = 'data/';

fdir    = dir(basedir);
for i = 3:length(fdir)
    clear fd PXY1 PXY2
    fn = fdir(i).name;
    if strcmp(fn(1:3),'dop')
        % load data file
        disp(fn)
        load([basedir fn])
        
        % run RadarWIC
        masterRadarSWIC  
        % save results of inversion
        save([basedir fn(12) '_inv.mat'],'th','f','Df','Sf','Sfth','Fs','Hsw','Ths');       
        eval(['aX2' fn(12) ' = f;'])
        eval(['aY2' fn(12) ' = Sf;']);
        eval(['aZ2' fn(12) ' = Sfth;']);
        eval(['aT2' fn(12) ' = th;']);
        eval(['aD2' fn(12) ' = Df;']);   
        % load in situ spectra for plot / comparison
        insitu = load([basedir 'insitu_' fn(12) '.mat']);
        eval(['aX1' fn(12) ' = insitu.fo;']);
        eval(['aY1' fn(12) ' = insitu.Sf;']);
        eval(['aZ1' fn(12) ' = insitu.Sfth;']);
        eval(['aT1' fn(12) ' = insitu.th;']);  
        eval(['aD1' fn(12) ' = insitu.Df;']);  
      
    end
end

%% Comparisons 1D insitu Sf Df and inv Sf Df  (events A-H)
% f
X1 = aX1A;
X2 = aX2A;

% Sf A-B
Y1 = aY1A;
Y2 = aY2A;
Y3 = aY1B;
Y4 = aY2B;

% Df A-B
Y5 = aD1A;
Y6 = aD2A;
Y7 = aD1B;
Y8 = aD2B;

% Sf C-D
Y9 = aY1C;
Y10 = aY2C;
Y11 = aY1D;
Y12 = aY2D;

% Df C-D
Y13 = aD1C;
Y14 = aD2C;
Y15 = aD1D;
Y16 = aD2D;

% Sf E-F
Y17 = aY1E;
Y18 = aY2E;
Y19 = aY1F;
Y20 = aY2F;

% Df E-F
Y21 = aD1E;
Y22 = aD2E;
Y23 = aD1F;
Y24 = aD2F;

% Sf G-H
Y25 = aY1G;
Y26 = aY2G;
Y27 = aY1H;
Y28 = aY2H;

% Df G-H
Y29 = aD1G;
Y30 = aD2G;
Y31 = aD1H;
Y32 = aD2H;


createfigure8x2(X1,Y1,X2,Y2, Y3, Y4, Y5, Y6, Y7, Y8, ...
                Y9, Y10, Y11, Y12, Y13, Y14, Y15, Y16, ...
                Y17, Y18, Y19, Y20, Y21, Y22, Y23, Y24, ...
                Y25, Y26, Y27, Y28, Y29, Y30, Y31, Y32);

%% Comparisons 2D insitu Sfth and inv Sfth (events A-H)
xdata1 = aX1A;
ydata1 = aT1A;

xdata2 = aX2A;
ydata2 = aT2A;

% select insitu wave freq same length as inverted wave freq f_inv
% ix = find(aX1A<=max(aX2A));
% aX1A = aX1A(ix);

zdata1 = aZ1A';
zdata2 = aZ2A';
zdata3 = aZ1B';
zdata4 = aZ2B';

zdata5 = aZ1C';
zdata6 = aZ2C';
zdata7 = aZ1D';
zdata8 = aZ2D';

zdata9 = aZ1E';
zdata10 = aZ2E';
zdata11 = aZ1F';
zdata12 = aZ2F';


zdata13 = aZ1G';
zdata14 = aZ2G';
zdata15 = aZ1H';
zdata16 = aZ2H';

createfigure4x4(xdata1, ydata1, zdata1, zdata2, zdata3, zdata4, ...
                                 zdata5, zdata6, zdata7, zdata8, ...
                                 zdata9, zdata10, zdata11, zdata12, ...
                                 zdata13, zdata14, zdata15, zdata16,xdata2,ydata2);
                             
                             
%%                             