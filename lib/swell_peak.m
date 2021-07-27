
function [fp,Ep,Sp,i]=swell_peak(freq,PXY,f_low,f_high)
%function [fp,Ep,Sp,j]=swell_peak(freq,PXY,f_low,f_high)
%
%% [fp,Ep,Sp,i]=swell_peak(freq,PXY,f_low,f_high)
%
% Function to find the location of the swell peak (fp) using a 4th order
% SNR weighting. It looks for swell peaks in PXY within the range f_low - f_high. 
% The largest peak that is a a weighted peak is identified. The integral of
% the swell peak over 5 points (2 points either side of the max) and the 
% energy at the swell peak  frequency (Ep) is calculated.
%
%% Input
% freq      - Doppler frequency in Hz of radar spectra
% PXY       - Doppler spectra in linear units
% f_low     - low freq. for swell region (f_low < swell <= f_high)
% f_high    - high freq. for swell region
%
%% Output
% fp        - Swell peak frequency (in Hz) SNR^4 weighting with two points on each side of swell peak
% Ep        - Max Doppler enegy at swell frequency peak
% Sp        - Integrated Doppler energy over 5 points centered at the swell peak
% i         - Indices of the integration for E_wang
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
np = 2; % Use 2 points on each side for centroid frequency and integral

 i = find(freq >= f_low  &  freq <= f_high); % find indices of swell region
if isempty(i)
    fp = nan;
    Ep = nan;
    Sp = nan;
    return
end
f = freq(i(1):i(end) + np);     % Actual freqs
S = PXY((i(1):i(end) + np));    % Power in swell region



%-------------------------------------------------------------------------
if length (S)<3
    locs = [];
else
    [pks,locs] = findpeaks(S); % make sure it's a local peak
end
if isempty(locs)
    fp = nan;
    Ep = nan;
    Sp = nan;
    return
end
%-------------------------------------------------------------------------
[~,loci] = max(pks);          % biggest local peak
j = locs(loci);
%
jmin = max(1,j-np);
jmax = min(length(S),j+np);
j = jmin:jmax;
f = f(j);
S = S(j);
f = f(:);
S = S(:);
%
n = 5;                         % 4th order weighting
fp = sum(f.*S.^n)/sum(S.^n);   % ^n weighted frequency (SNR weighted) around peak
Sp = trapz(f,S);               % integral
Ep = interp1(f,S,fp,'linear'); % Energy at swell peak frequency from ^n weighting (4th order)
end