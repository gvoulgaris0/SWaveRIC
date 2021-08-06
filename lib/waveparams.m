%% waveparams.m
%  Estimation of wave bulk parameters 
%%
function [bulk] = waveparams(f,Sf,th)
%% [bulk] = waveparams(f,Sf,th)
%  Function to calculate common bulk wave parameters from a wave
%  spectrum (Sf(f)), where f is wave frequency. It uses the moments method.
%
%% Inputs
%  f  - wave frequency (Hz)
%  Sf - wave spectrum (m^2/Hz)
%  th - wave direction (degrees, math notation)
%
%% Ouputs
%  Array bulk(1:5), where
%  bulk(1) = Hs  -  Significant wave height (m)
%  bulk(2) = fp  -  peak wave frequency (Hz)
%  bulk(3) = fm  -  mean wave frequency (Hz)
%  bulk(4) = thp -  peak wave direction (degrees, math notation)
%  bulk(5) = thm -  mean wave direction (degrees, math notation)
%
%% Uses
%  trapz.m
%
%% Copyright 
%  2021 Zaid Al-Attabi, Douglas Cahl, George Voulgaris
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
%% Main function
if sum(~isnan(Sf)) == 0
    if nargin > 2
        bulk = nan(5,1)';
    else
        bulk = nan(3,1)';
    end
    return
end

% significant waveheight
i  = ~isnan(Sf);
hs = sqrt(16*trapz(f(i),Sf(i)));
hs = hs./sqrt(2);  % rms waveheight

% mean wave period
m0 = trapz(f(i),Sf(i));
m1 = trapz(f(i),f(i).*Sf(i));
tm = m0/m1;
fm = 1./tm;

if nargin > 2
    % mean wave direction
    i  = ~isnan(Sf) & ~isnan(th);
    thm = atan2d(sum(Sf(i).*sind(th(i))),sum(Sf(i).*cosd(th(i))));
end

% peak energy
[~,i] = max(Sf);
j   = max(i-2,1):min(i+2,length(Sf));
f   = f(j); f = f(:);
Sf  = Sf(j); Sf = Sf(:);
n   = 4;                         % 4th order weighting
fp  = sum(f.*Sf.^n)/sum(Sf.^n);  % peak frequency identofication
if nargin > 2
    th = th(j); th = th(:);
    thp = interp1(f,th,fp,'linear'); % wave direction at peak frequency
    bulk = [hs,fp,fm,thp,thm];
else
    th = [];
    bulk = [hs,fp,fm th th];
end
