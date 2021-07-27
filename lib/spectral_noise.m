%% spectral_noise.m
%  Determine the noise level of a spectrum using the method of 
%  Hildebrand and Sekhon (1974). Copyright (C) 2013 Kirk North
%%
function [P,Q,n,SnR2,maxSn] = spectral_noise(Sn,p)  
%% [P,Q,n,SnR2,maxSn] = spectral_noise(Sn,p)
%  
%  Function that determines the noise level in power spectra using the
%  method described in:  
% 
%  Hildebrand, P. H. and R. S. Sekhon, 1974,Objective determination of the 
%  noise level in Doppler spectra. Journal of Applied Meteorology,13: 808-811.
% 
%% Input
%  Sn  - Doppler spectrum
%  p   - Number of spectral estimates smoothed
%        (p=1 for non smoothed spectra)
%
%% Output
%  P    - mean noise level of spectrum Sn below SnR2
%  Q    - variance of the spectral values below SnR2
%  n    - number of points in the spectrum below SnR2
%  SnR2 - Signal-to-noise critical threshold
%  maxSn- maximum value in the spectrum Sn
%
%  The signal-to-noise threshold SnR2 is the critical value where the
%  criterion for white noise has been met, while P is the mean of all the
%  values in Sn below this critical value. Sn should be a vector and in
%  linear units (e.g. mW), where P, SnR2, and maxSn will then be in linear
%  units. Sn need not be a Doppler  spectrum, but it must be a power
%  spectrum. N is the number of independent spectral values, or simply
%  LENGTH(Sn). p is the number of points over which a moving average of
%  the spectrum was taken. If the spectrum has not been smoothed, then p=1.
%
%% Copyright (C) 2013 Kirk North
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
%  along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%% Main Fuction
maxSn = nanmax(Sn);
N = length(Sn);   % Number of spectral estimates
Sn = sort(Sn, 'descend');
SnR2 = Sn(end); % Set signal-to-noise threshold to lowest value in spectrum.
for i = 1:N
    n = sum(isfinite(Sn(i:end)));
    P = nansum(Sn(i:end)) / n;          % Mean noise level for current iteration.
    Q = nansum(Sn(i:end).^2) / n - P^2; % Variance of noise level for current iteration.
    R2 = P^2 / (Q * p);
    if (R2 > 1)                         % White noise criteria has been met.
        SnR2 = Sn(i);
        break
    end
end
end