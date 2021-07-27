%% ConfigRSWIC.m
% Configuration file that contains all adjustable parameters for swell and 
% the Radar Wave Inversion Code (RWIC)
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
%% HFR System details
global g fr
fr      = 12;                       % HFR operating frequency in MHz
g       = 9.81;                     % Gravity acceleration (m/s2)
lbragg  = 299.8/2/fr;               % Bragg wavelength (m)
fbragg  = sqrt(g*2*pi/lbragg)/2/pi; % Bragg frequency (Hz)
k0      = 2*pi/(2*lbragg);          % Radar wavenumber (rads/m)

%% Parameters defining details of analysis to be used
dom          = 1;           % use only the side with the largest Bragg peak (for wind and Allatabi swell)
                            % when the difference between the two peaks is <3dB then use both sides.
peak_diff_db = 3;           % for use with dom = 1, the max peak difference to use both peaks
gaus_fit     = 1;           % fit gaussian for Bragg integral halfwidth
maxv         = 2;           % Max velocity (in m/s) defining the search region for Bragg peaks
np           = 5;           % number of points on each side of Bragg peak used for Bragg peak estimation
maxdf        = maxv/lbragg; % Maximum Doppler shift expected (used to search for Bragg peaks, given maxv)

%% Parameters defining where to look for swell and second order spectra
Highf   = 0.35;      % Maximum wave freq (Hz); defines the second order upper limit
Lowf    = 0.025;     % Minimum wave freq (Hz); it defines the limit between 1st and 2nd order Doppler spectra
minf    = 0.02;      % Min halfwidth of Bragg Peak

%% Removes energy at around 0 Hz (+/-flim) 
% This is a common issue in HF systems with high energy at 0 Hz (DC frequencies)
% effects inner sidebands only
flim = 0.046; % Hz (Default 0.046 Hz)

%% Quality Control for 1st and 2nd order sidbands
snr1    = 10;   % Threshold singal to noise ratio of 1st order Bragg peaks
snr2    = 5;    % Threshold singal to noise ratio of 2nd order sidebnfs peaks
dSigma  = 2;    % ratio of 1st order Bragg peaks and 2nd order peaks

%% Inversion output resolution
dth = 6;                % in Degrees
df  = 0.005;            % in Hz
th  = dth:dth:360;
f   = Lowf:df:Highf;