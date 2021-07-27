%% hfr_noise.m
%  Function to estimate the noise level from a spectrum
%%
function  [Noise,fp,fn] = hfr_noise(freq,PXY,fbragg,maxdf)
%% [Noise,fp,fn] = hfr_noise(freq,PXY,fbragg,maxdf,np)
%
% This function calculates the noise level (Noise) in dB of an HF radar
% spectra (PXY) with the energy in dB units. The approximate positions of
% the positive (fp) and negative (fn) Bragg peaks are also estimated. 
%
%% Input
%
%    freq   - Doppler frequency of radar spectra (in Hz)
%    PXY    - Doppler spectral energy (in dB)
%    fbragg - Bragg frequency of radar system (in Hz)
%    maxdf  - Maximum expected doppler shift of Bragg peak (in Hz) from theoretical positions
%
%% Output
%    Noise  - Noise level calculated from the outer edge of the side with
%             the smaller Bragg peak (in dB)
%    fp     - approximate location of positive Bragg peak (in Hz)
%    fn     - approximate location of negative Bragg peak (in Hz)
%
%% Uses
% spectral_noise.m - Copyright (C) 2013 Kirk North, GNU public license
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

%% Find largest Bragg peak
i = ( freq > -fbragg - maxdf  &  freq < -fbragg + maxdf ) | ... % negative side
    ( freq > +fbragg - maxdf  &  freq < +fbragg + maxdf );      % positive side
ptest = PXY;
ptest(~i) = nan;
[~,pm]=max(ptest); % peak with max energy near Bragg peaks (within maxv)

PM = pm-2 : pm+2;  % using 2 points on either side
PXYlin = 10.^(PXY./10);
fpeak = sum(PXYlin(PM).*freq(PM)) / sum(PXYlin(PM)); % SNR weighted average frequency

%% Objective Spectral Noise; estimated for the smaller Bragg peak side of the spectrum
if isnan(fpeak)
    Noise=nan;
    return
else
    if freq(PM)<0    % negative peak
        fn = fpeak;
        fp = fn+2*fbragg;
        if max(freq) < 1.5*fp % check the peak isn't too close to the edge
            error('Cannot determine Noise level in Doppler spectrum')
%             Noise = nan; 
%             return
        else
            [Noise,~,~,~,~]= spectral_noise(PXY(freq>1.5*fp),1);
        end
    else             % positive peak
        fp = fpeak;
        fn = fp-2*fbragg;
        if min(freq) > 1.5*fn % check the peak isn't too close to the edge
            error('Cannot determine Noise level in Doppler spectrum')
%             Noise = nan;
%             return
        else
            [Noise,~,~,~,~]= spectral_noise(PXY(freq<1.5*fn),1);
        end
    end
end
end

