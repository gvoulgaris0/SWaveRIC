%% PXYint.m
%  Function that integrates power spectrum over a range of frequencies using the trapezoid rule.
%%
function [P,Speak,S1] = PXYint(freq,PXY,f_low,f_high)
%% [P,Speak,S1] = PXYint(freq,PXY,f_low,f_high)
%
% This function integrates PXY over f_low <= freq <= f_high
% using the trapezoid rule.
%
%% Input
%  freq   - Frequency array (Hz)
%  PXY    - Spectral energy array PXY(f)
%  f_low  - Lower limit of integration (Hz)
%  f_high - Upper limit of integration (Hz)
%
%% Output
%  P      - Value of integral
%  Speak  - Peak energy value
%  S1     - std of values
%
%% Uses
%  trapz.m
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
i = freq >= f_low  &  freq <= f_high;   % find indices within the desired range
f = freq(i);                            % frequency array
S = PXY(i);                             % Power of spectrum
P = trapz(f,S);                         % integral
Speak = max(S);                         % Peak energy
S1    = nanstd(S);                      % integral for first order N side
end

