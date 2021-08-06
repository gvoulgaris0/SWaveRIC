%% swell_singular.m
%  Function to remove invalid swell inversion. Swell inversion fails at 
%  high cross angles. The limit is dependent on HF operating frequency. 
%  For radar frequencies of 4, 12, and 48 MHz singularities occur for swell 
%  cross angles |θ_s |>60^o,75^o and 85^o, 
%%
function [fsi,Hswi,Thsi] = swell_singular(fs,Hsw,Ths,thc2,beamdiff,fr)
%% Inputs
%  fs:          - swell frequency (Hz) 
%  Hsw:         - swell rms waveheight (m) 
%  Ths:         - swell direction (degrees) 
%  thc2:        -(degrees) swell cross angle to beam 1
%  fr           - HF radar operating frequency  (in Mhz)
%  beamdiff     - the angle between two rdara beams

%% Outputs 
%  fsi:          - swell frequency (Hz) 
%  Hswi:         - swell rms waveheight (m) 
%  Thsi:         - swell direction (degrees) 
%
%% Copyright 2021, Zaid Al-Attabi, Douglas Cahl, George Voulgaris
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
%% Main  % empirical eq
A = 23; % 23 (in deg)
SS = A*log10(fr)+48; % empirical estimate of range of possible swell inversion

thc3 = thc2+beamdiff;  % diff between b1 and b2, abs(b1-b2)
thc3 = wrap180(thc3);
thc3(thc3>90) = thc3(thc3>90)-180;
thc3(thc3<-90)= thc3(thc3<-90)+180;

thc2 = wrap180(thc2);
thc2(thc2>90) = thc2(thc2>90)-180;
thc2(thc2<-90)= thc2(thc2<-90)+180;

% remove solutions if above limit
L   = find(abs(thc2)>=SS); 
thc3(L) = nan;
Lx  = find(abs(thc3)>=SS); 
i = [L;Lx];

Hswi = Hsw;
Hswi(i) = nan;

fsi = fs;
fsi(i) = nan;

% 
Thsi =Ths;
Thsi(i) = nan;

% direction conventions  0-360 with x-axis = 0
Thsi = 90-Thsi;
Thsi = mod(Thsi,360);

end % end of main function
