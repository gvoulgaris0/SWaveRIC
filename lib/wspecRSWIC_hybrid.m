%% wspecRSWIC_hybrid.m
%  Function to combine the inverted swell and wind wave spectra to a single
%  wave spectrum. S(f) = Sw(f)+ Ss(f)
%
function [Sf,th] = wspecRSWIC_hybrid(f,Rw,Sfw,Sfs,fc,thw,ths,jswaproll)
% [Sfw,Sfs,Sf,th] = wspecRWIC(f,Rw,Sf_wind,Sf_swell,fc,thw,ths,jswaproll); % this was used
%
% Function to combine the swell and wind wave spectra to a single wave spectrum.
% It uses sideband ratio (Rw(f<fc)/Rw(f>fc) to decide if both spectra need to be
% merged into one. Otherwise the wind spectrum is returned.
%
% If Sf_swell and Sf_wind are combined, the left limit of the wind spectrum
% (Sf_wind) is assumed to be at the frequency bin where the Gaussian swell
%  spectrum (Sf_swell) decays to energies below the wind spectrum (Sf_wind.
% A JONSWAP roll-off is assumed for Sf_wind to the right of this point.
% The swell spectrum (Sf_swell) is used for all frequencies below this condition.
%
% The wave direction (th) is calculated in the same way from wind
% wave direction (thw) if swell wave direction (ths) is given. Otherwise
% thw is returned.
%
%% Inputs
%  f         - wave frequencies (Hz)
%  Rw        - 2nd order sideband ratio weighted by Barrick's weighting function
%  Sf_wind   - wind wave spectrum from radar inversion(m^2/Hz)
%  Sf_swell  - swell wave spectrum from swell radar inversion (m^2/Hz)
%  fc        - cutoff frequency, if the ratio of R(f<=fc) / R(f>fc) >= 0.3,
%              then Sf_wind and Sf_swell are combined, otherwise Sf_wind
%              is returned
%  Hsw       - swell rms waveheight
%  thw       - wind wave propagation direction as function of f
%  ths       - swell propagation direction [optional]
%  Fs        - swell frequency
%  jswaproll - =1 apply JONSWAP roll off below last Rw value
%
%% Ouputs
%  Sf        - S(f) Wave spectral energy density(m^2/Hz)
%  th        - only calculated if input includes swell propagation direction (ths)
%              otherwise returns wind wave direction (thw)
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
%% Main function

Rwind       = nansum(Rw(f > fc));   % wind wave frequencies
Rswell      = nansum(Rw(f <= fc));  % swell wave frequencies
Ratio       = Rswell/Rwind;         % Ration of swell energy to wind energy
RatioLim    = 0.3;                  % Minimum ratio to use swell inversion               

% remove wind inversion at swell frequencies
[~,j] = min(abs(f-(fc)));
j = j - 1;
if jswaproll == 1  % JONSWAP Roll-off instead of straight to 0
    Sfw(1:j) = Sfw(j+1)*exp(-((f(1:j)-f(j+1))/f(j+1)).^2 /(2*0.07^2));
else
    Sfw(1:j) = 0;
end

% see if swell exists
if Ratio > RatioLim && max(Sfs) > 0 % Swell dominated conditions for deep waters
    hybrid = 1; % use hybrid (swell inversion < fc, wind inversion > fc) 
else
    hybrid = 0; % wind inversion only
end


if hybrid == 1 % swell and wind
    Sf  = Sfs + Sfw;    % Combine both spectra (Hybrid)
    th = thw;           % Wind wave direction
    if nargin > 6 && ~isempty(ths) % included wind and swell direction (thw and ths)
%         th(1:j) = ths;             % swell direction from Lipa (unused in Al-attabi et al., 2021)
    end
else % wind inversion
    Sf  = Sfw;  % Wind wave spectrum
    th = thw;   % Wind wave direction
end
end   % End of function
