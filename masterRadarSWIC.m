%% masterRadarSWIC.m
%
%  This is an example master script that shows how to utilize the RadarSWIC.m  model.
%  It uses examples of spectra from two beams of two HF systems (or two beams from one HF radar system).
%  the files are located in subdirectory 'data/'
%  More adjustable parameters are located in script configRSWIC.m
%  see comments inside the script for more details.
%
%% Copyright 
%  2021 Zaid Al-attabi, Douglas Cahl, George Voulgaris
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
%% HF radar and inversion specific parameters
%  note: HF/VHF radar operating frequency is set in ConfigRSWIC.m
%
%  The inversion is very sensitive to the swell cutoff frequency fc. 
%  fc = 0.12 better for G, fc = 0.11 better for F
fc          = 0.115;    % frequency (in Hz) separating swell from wind waves region
wind_fc     = 1;        % alternatively use wind speed to calculate the appropriate frequency cutoff 
max_fc      = 0.12;     % maximum frequency cutoff (used when wind speed is low which will give a very high frequency)
% depth  = 53.8;   % Constant water depth of inversion location (meters) if not using tidally varying depth
jswaproll = 1;   % =1 apply JONSWAP roll off below fc; =0 forces inversion to zero below fc
switc1 = 1;      % switch for avoid Bragg peak (switc1=1), or include all data below fc (switc1=999)
%% Inversion Model Calibration coefficients for wind-wave inversion (see Al-attabi et al., 2021)
aw     = 0.3;    % wind cal. coefficient used for wind inversion
sigma  = 0.011;  % swell spectral width coefficient (empirical fit) - for creating a Gaussian swell spectrum  
%% Inversion Model Inputs:
%  PXY1         - Doppler spectrum from beam1                        (in dB)
%  PXY2         - Doppler spectrum from beam2                        (in dB)
%  freq         - frequency of the radar Doppler spectrum            (in Hz)  
%  f            - Wave frequency                                     (in Hz)
%  fc           - frequency separating                               (in Hz) 
%  depth        - depth at which location radar data is used         (in m) 
%  th           - range of directional distribution (-180 to 180)    (in deg)
%  wspd         - wind speed (at 10m elevation)                      (in m/s)
%  fr           - HF radar operating frequency                       (in Mhz)
%  beam1        - radar beam angle at which PXY1 is collected        (in deg)
%  beam2        - radar beam angle at which PXY2 is collected        (in deg)
%% radar beam angles needed for swell inversion
beam1 = 78.28; % PEN station beam angle for PXY1 - site 1
beam2 = 178.2; % PER station beam angle for PXY2 - site 2
%% Load your HF radar spectrum input
%  load(spec_site1);         % load Doppler spectrum file from radar (freq,PXY1)
%  load(spec_site2);         % load Doppler spectrum file from radar (freq,PXY2)
%  load(wspd)                % load wind speed (optional)
%  load(depth)               % load water depth at time of HF radar acquisition (may change with tides)
%% Inversion Model Output:
%  Sf        - 1D- Wave energy spectral density (S(f))
%  Df        -  Wave directional as fucntion of wave frequncy (D(f))
%  Sfth      - 2D- directional wave spectrum (S(f,theta))
%  Hsw       - Root Mean sSuare (RMS) Swell wave height (Swell Hrms)
%  Fs        - Swell wave frequency 
%  Ths       - Swell Wave direction
%  params_x  = [Hrms, fp, fm, Thetap, Thetam]
%              where x (= w,s or t) denotes the part of spectrum so that:
%              w  for wind waves:       Sfw, thw, params_w
%              s  for swell waves:      Sfs, n/a, params_s
%              h  for combined (total): Sfh, thw, params_h
%% Load config params
ConfigRSWIC;
if ~exist('wspd','var') % check for wind speed data
    wspd = [];
elseif wind_fc == 1 % use wind speed for frequency cutoff
    fc = (g./(2*pi))*(1./(1.5*wspd)); 
    if fc > max_fc
        fc = max_fc;
    end
end
%% Swell Wave Inversion - RadarSWIC (see Al-attabi et al., 2021)
[Df,Sf,Sfth,Fs,Hsw,Ths,Ths_err] = RadarSWIC(freq,PXY1,PXY2,f,fr,aw,sigma,fc,jswaproll,beam1,beam2,depth,th,wspd,switc1);
% disp(Ths_err)  % This is an estimate of uncertainty in swell propagation direction
%% wave parameters
[paramsT,paramsS,paramsW] = waveparams3(fc,Sf,f,Df); % [Total, Swell (f<fc), Wind (f>fc)]
paramsL = [Hsw,Fs,Fs,Ths,Ths]; % Wave params from Lipa method
%% Display wave parameters
Comment1='Swell Wave Inversion model RadarSWIC as described in Al-attabi et al (2021)';
Comment2=['Calibration factors: aw = ',num2str(round(aw,2)),];
Comment3=['Swell broadening sigma = ',num2str(round(sigma,3)),' Swell/Wind fc(Hz)=',num2str(round(fc,2))];
disp(Comment1)
disp(Comment2)
disp(Comment3)
X0 = sprintf('%s','               Hs    fp   fm   th_p  th_m');
X1 = sprintf('%s %2.2f  %2.2f %2.2f %5.1f %5.1f','Wind       : ',paramsW);
X2 = sprintf('%s %2.2f  %2.2f %2.2f %5.1f %5.1f','Swell      : ',paramsS);
X3 = sprintf('%s %2.2f  %2.2f %2.2f %5.1f %5.1f','Total      : ',paramsT);
X4 = sprintf('%s %2.2f  %2.2f %2.2f %5.1f %5.1f','Swell_Lipa : ',paramsL);
disp(X0)
disp(X4)
disp(X3)
disp('Wave Partitions')
disp(X1)
disp(X2)