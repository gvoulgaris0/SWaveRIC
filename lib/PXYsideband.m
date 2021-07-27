%% PXYsideband.m
%  This function calculates the wave frequencies (fw) from the second order
%  sidebands. It also returns the energy (E) and the weighted energy (Ew) of
%  the second order sidebands. The Doppler frequencies of the sideband are
%  given by f. 
%%
function [fw,E,Ew,f] = PXYsideband(freq,PXY,f_low,f_high,fpn,Wi,switc1)

%% Input
%  fbragg - Theoretical Bragg frequency of radar (Hz)
%  freq   - Doppler frequency in Hz of radar spectra
%  PXY    - Doppler spectra in linear units
%  f_low  - only process sideband at or above this frequency
%  f_high - only process sideband at or below this frequency
%  fpn    - location of Bragg peak corresponding to this sideband
%  Wi     - sideband number 1-4 from lowest to highest frequency
%  switc1 - [optional, default =1] if =999, keeps all 2nd order data 
%             above f_low and below fwmin (see code). For testing
%             purposes.
%
%% Output
%  fw    - wave frequencies corresponding to this sideband (in Hz) 
%  E     - Doppler energy of this sideband
%  Ew    - E, weighted by Barrick's weighting function
%  f     - Doppler frequencies corresponding to this sideband (in Hz)
%
%% Uses
%  Weightf_barrick.m 
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
%%
global fr g
lbragg  = 299.8/2/fr;           % Bragg wavelength (m)
fbragg  = sqrt(g*2*pi/lbragg)/2/pi; % Bragg frequency (Hz)
if nargin < 7
    switc1 = 1;
end
i  = freq >= f_low  &  freq <= f_high; % find indices of freq within range
f  = freq(i);                          % Corresponding frequencies
fw = abs(f-fpn);                       % wave frequencies
E  = PXY(i);
if switc1 ~= 999
    % find first minimum after Bragg peak, sideband starts there
    j     = islocalmin(E);  % identifies indices of local minima
    fw1   = fw(j);          % corresponding wave frequencies at identified local minima
    fwmin = min(fw1);       % local min closest to Bragg peak (lowest wave frequency)
    % keep only sideband above local minimum
    if ~isempty(fwmin) 
        j  = fw >= fwmin;
        fw = fw(j);
        E  = E(j);      % unweighted second order energy
        f  = f(j);
    end
end
% check for inner or outer sidebands
if Wi == 2 || Wi == 3
    Wn = -1;    % inner sidebands
else
    Wn = 1;     % outer sidebands
end
% Deep-water weighting function
W  = weightf_barrick(fbragg,fw,Wn); % Barrick weighting function
Ew = E./W;      % Weighted second order energy