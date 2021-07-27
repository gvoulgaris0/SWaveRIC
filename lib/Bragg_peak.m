%% Bragg_peak.m
% Function for estimating the Bragg peak in a Doppler spectrum
%%
function [fpeak,j] = Bragg_peak(freq,PXY,np,flow,fhigh)
%% [fpeak,PM] = find_Bragg_peak(freq,PXY,np,flow,fhigh)
%
% This function finds the frequency (fpeak) of a Bragg peak, and the
% indices (j) of the spectral bins used. It uses a centroid method with a 4th order weighting. 
% The centroid is estimated using np number of points on either side of the peak; 
% the latter is searched for within the range defined by flow and fhigh.
%
%% Input
%    freq  - Doppler frequency of radar spectra (in Hz)
%    PXY   - Doppler spectral energy (in linear units)
%    np    - Number of points on each side of peak to use for peak frequency calculation
%    flow  - Lower frequency limit for peak search (in Hz)
%    fhigh - Upper frequency limit for peak search (in Hz) 
%
%% Output
%
%   fpeak  - location of Bragg peak
%   j      - indices used to calculate peak frequency
%
%% Copyright 2019 Zaid Alattabi, Douglas Cahl, George Voulgaris
%
% This file is part of RadarWIC.
%
% RadarWIC is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <https://www.gnu.org/licenses/>.
%
%%
i           = freq >= flow  & freq <= fhigh;
ptest       = PXY;
ptest(~i)   = 0;
[~,j]       = max(ptest);    % peak with max energy near Bragg peaks (within maxv)

j           = j-np : j+np;   % np points on either side
f           = freq(j);
S           = PXY(j);
n           = 4;             % 4th order weighting
fpeak       = sum(f.*S.^n) / sum(S.^n); % SNR^n weighted average frequency

end
