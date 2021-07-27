%% ConditionDopRSWIC.m
%
%  Script that:       
%   1. Loads all setup parameters from the ConfigRWIC.m file
%   2. Identifies and removes noise level from Doppler spectrum 
%   3. Locates 1st order Bragg peaks 
%   4. Applies a Gaussian curve fitting to the Bragg peaks
%      (used for Bragg peak integration and 2nd order sideband low frequency limits)
%   5. Integrates Bragg peaks using the Gaussian halfwidth from fit
%% Uses
%    ConfigRSWIC.m, hfr_noise.m, Bragg_peak.m, Gauss_fit.m, PXYint.m
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
%% Load the configuration parameters
ConfigRSWIC;

%% Remove noise near zero (DC) frequencies
i = freq >= -flim & freq <= flim;
PXY(i) = min(PXY);

%% Noise and approximate locations of Bragg peaks, PXY must be in dB
[Noisedb,fp,fn] = hfr_noise(freq,PXY,fbragg,maxdf);

%% Convert from dB to linear units
PXY    = 10.^(0.1*PXY);
Noise  = 10.^(0.1*Noisedb);
PXY_or = PXY;                       % Used for plotting purposes

%% Remove noise and set negative values (if any) to zero
PXY        = PXY-Noise;
PXY(PXY<0) = (1.381e-23)*300; % noise temperature at 300K (27C,80f), -203.8269 dBW/Hz

%% 2nd estimate of Bragg peak locations (in Hz) from de-noised Doppler spectra.
[fn,in] = Bragg_peak(freq,PXY,np,fn-maxdf/2,fn+maxdf/2 );  % negative peak
[fp,ip] = Bragg_peak(freq,PXY,np,fp-maxdf/2,fp+maxdf/2 );  % positive peak

%% Fit a Gaussian Curve around each peak
% Subtraction can destroy swell peak if Gaussian is poorly fitted (removed 10/19/2018 DLC)
%
sigmap = Gauss_fit(freq(ip),PXY(ip));
sigman = Gauss_fit(freq(in),PXY(in));
if ~isreal(sigmap)
    sigmap = df*(np-1); % defaults back to np
end
if ~isreal(sigman)
    sigman = df*(np-1); % defaults back to np
end
%
%% ---------------- identification of 1st order regions ------------------
% It checks to make sure that the width of 1st order peak as estimated by the
% Gaussian fit is not too wide or too narrow (in case of a double peak being
% present).
%
% Check for the negative 1st order Bragg peak
hfn    = 0.5*2.355*sigman;       % halfwidth of Bragg peak (from Gaussian, in Hz)
hfn    = hfn + df;               % add an extra bin on the end to make sure we capture all points within the halfwidth
hfn    = min(hfn,Lowf);          % in case of a poor Gaussian fit (too wide), hf  = Lowf
hfn    = max(hfn,minf/2);        % in case too narrow
Lowfn  = min(2.355*sigman,Lowf); % lowest swell freq.  - check to make sure its' not too wide
Lowfn  = max(Lowfn,minf);        % check to make sure it's not too narrow

% Check for the positive 1st order Bragg peak
hfp = 0.5*2.355*sigmap;
hfp = hfp + df;
hfp = min(hfp,Lowf);
hfp = max(hfp,minf/2);
Lowfp = min(2.355*sigmap,Lowf);
Lowfp = max(Lowfp,minf);

% Estimate the Bragg peak integrals
[S1N,S1Npeak,S1n] = PXYint(freq,PXY,fn-hfn,fn+hfn);
[S1P,S1Ppeak,S1p] = PXYint(freq,PXY,fp-hfp,fp+hfp);