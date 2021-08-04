%%  RadarSWIC.m
%  Main function for the Radar Swell Wave Inversion Code (RadarSWIC)
%%
function [Df,Sf,Sfth,Fs,Hsw,Ths,Ths_err] = RadarSWIC(freq,PXY1,PXY2,f,fr,aw,sigma,fc,jswaproll,beam1,beam2,d,th,wspd,switc1)
%% Description
%  This function uses Doppler spectra from two beams from two VHF/HF radar 
%  sites, or two beams from one VHF/HF radar site, identifies the 2nd order
%  continuum in each spectrum and inverts it to create an ocean wave spectrum.
%
%  For more details see:
%
%  Al-Attabi, Z., Voulgaris G., and Conley D.,(2021):Evaluation and Validation of
%  HF Radar Swell and Wind wave Inversion, Journal of Oceanic and 
%  Atmopsheric Technology, https://doi.org/10.1175/JTECH-D-20-0186
%
% The function:
%
%  1. Identifies the 2nd order sides of Doppler spectrum and creates the
%     weighted and normalized by the 1st order spectra (Rw)
%  2. Inverts Rw to wind wave spectrum (Sfw) using the appropiate calibration
%     coefficient (aw)
%  3. Estimates the swell part of the spectrum using Lipa et al 1981 method.
%  4. Inverts the swell part of Rw to a spectrum using a Gaussian function
%     with width sigma using Hs, fs, ths from Lipa's inversion method
%  5. Reconstructs total wave spectrum Sf = Sfs+Sfw
%  6. Estimates the 2D directioanl wave spectrum
%
%  Inversion parameters are set in file:  ConfigRSWIC.m
%% Inputs
%  PXY1      - Doppler spectrum from beam1                        (in dB)
%  PXY2      - Doppler spectrum from beam2                        (in dB)
%  freq      - frequency of the radar Doppler spectrum            (in Hz)
%  f         - Wave frequency array for inversion                 (in Hz)
%  fr        - HF radar operating frequency                       (in Mhz)
%  aw        - wind-wave regression coefficient - used for wind-wave inversion
%  sigma     - Gaussian swell spectrum width (empirical fit) - used for swell inversion
%  fc        - frequency separating, separating swell from wind waves region; (in Hz)
%              It limits swell peak freq. below this value; it is also used by the hybrid model ratio test (see Allatabi et al.,2021).
%  jswaproll - if =1 [default] apply JONSWAP roll off below last Rw value
%  beam1     - radar beam angle at which PXY1 is collected        (in deg)
%  beam2     - radar beam angle at which PXY2 is collected        (in deg)
%  d         - depth at which location radar data is used         (in m)
%  th        - range of directional distribution (-180 to 180)    (in deg)
%  wspd      - wind speed (at 10m elevation)                      (in m/s)
%  switc1    - switch used for avoid Bragg peak (switc1=1), or include all data below fc (switc1=999)
%% Outputs
%  Df        - Wave directional spectrum (D(f))
%  Sf        - 1D- total wave energy spectral density (S(f), m2/Hz)
%  Sfth      - 2D- total directional wave spectrum (S(f,theta), m2/Hz/deg)
%  Fs        - Swell wave frequency
%  Hsw       - Swell root mean square wave height (Swell Hrms)
%  Ths       - Swell Wave direction
%  Ths_err   - Estimate of uncertainty in swell direction
%% Uses
%  wn2ndRSWIC.m,          specWindRSWIC.m,     
%  dopLipaS.m,            swell_singular.m,
%  specSwellRSWIC.m,      wspecRSWIC_hybrid.m, 
%  Inverted_2D_DirSpec.m, waveparams3.m
%% Copyright 
%  2021 Zaid Al-attabi, Douglas Cahl, George Voulgaris
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
%% Main Function
addpath('lib')       % add path with required subroutines

% Doppler analysis and wind wave inversion
[~,Rw1,fw1,~,Dw1]  = wn2ndRSWIC(freq,PXY1,switc1);  % Doppler spectrum to norm. 2nd order
[~,Rw2,fw2,~,Dw2]  = wn2ndRSWIC(freq,PXY2,switc1);  % Doppler spectrum to norm. 2nd order

% interpolate to common freq (frequency given in ConfigRSWIC.m)
Rw1       = interp1(fw1,Rw1,f);
Dw1       = interp1(fw1,Dw1,f);
Rw2       = interp1(fw2,Rw2,f);
Dw2       = interp1(fw2,Dw2,f);

% Wind wave inversion
[Sfw,thw] = specWindRSWIC(Rw1,Dw1,aw,Rw2,Dw2,beam1,beam2,1);
thw = 90-thw; % math -> oceanographic notation
thw = mod(thw,360);

% Swell wave inversion
[fs,hsw,ths,thc,thc2] = dopLipaS(freq,PXY1,PXY2,beam1,beam2,fc,d);
Ths_err = abs(thc2-thc);            % estimate of uncertainty in swell direction
beamdiff = wrap180(beam2-beam1);    % beamdiff is the angle between two radar beams

% avoid swell singularities (see Al-Attabi et al 2021 for more details)
[Fs,Hsw,Ths] = swell_singular(fs,hsw,ths,thc,beamdiff,fr);

% swell inversion
[Sfs] = specSwellRSWIC(f,Fs,Hsw,sigma); 

% Hybrid inversion: intelligently combine wind and swell inversions
[Sf,Df] = wspecRSWIC_hybrid(f,Rw1,Sfw,Sfs,fc,thw,Ths,jswaproll); % before

% estimate the inverted peak wave frequency
[params_t,~,~] = waveparams3(fc,Sf,f,Df);
fp = params_t(2);

% 2D wave spectrum, Sf(f,theta)
[Sfth] = Inverted_2D_DirSpec(fp,th,Df,Sf,f,wspd);
