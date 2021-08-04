%% wn2ndRSWIC.m
%  This function returns the 2nd order Doppler spectrum used for HF radar wave inversion.
%  The spectrun is normalized by the 1st order energy (R)and also weighted 
%  using Barrick's weighting function (Rw). The corresponding ocean wave frequencies are given as fw
%%
function [R,Rw,fw,D,Dw,debug] = wn2ndRSWIC(freq,PXY,switc1)
%% Inputs
%  freq:        Array of Doppler frequencies for the Doppler spectrum (in Hz)
%  PXY(1:freq): Array of Spectral Energy (in dB), do not send arrays of NaN
%  switc1:      option passed to PXYsideband.m 
%
%% Outputs
%  fw:       Ocean wave frequencies (in Hz)
%  R:        (no units) normalized (no weighted) 2nd order sideband
%  Rw:       (no units) weighted (by Barrick's weighting function)and normalized 2nd order sideband
%  D:        (no units) Ratio of normalized 2nd order sidebands around a peak [(R_right_of_peak)/(R_left_of_peak)]
%  Dw:       (no units) Ratio of normalized & weighted 2nd order sideband around a peak [(Rw_right_of_peak)/(Rw_left_of_peak)]
%  debug:    Structure variable to be used for debugging purposes
%
%% Debugging parameteres
%  Extra data to be used for debugging purposes for each sideband.
%  debug.fw1-n  the ocean wave frequency from the Doppler spectra for sideband n
%  debug.E1-n   Doppler energy for sideband n
%  debug.R1-n   normalized (by 1st order) 2nd order sideband for sideband n
%  debug.Rw1-n  normalized and weighted 2nd order sideband for sideband n
%                where n=1,2,3,or 4
%                with 1 and 2 indicating negative frequencies
%                     3 and 4 positive frequencies
%                     1 and 3 left of the adjacent Bragg peak
%                     2 and 4 right of the adjacent Bragg peak
%  debug.SNR1   signal to noise ratio for 1st order
%  debug.SNR2   signal to noise ratio for 2nd order
%  debug.sigma1 width of Bragg peak
%  debug.Noise  Noise level
%  debug.S11    ratio of std of Bragg peak region (to get wind direction/local wind wave direction)
%  debug.braggpeaksSNR  Bragg peak SNR for positive and negative side peaks
%
%% Uses
%  ConditionDopRSWIC.m, PXYsideband.m
%
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
%% Main function
ConditionDopRSWIC;   % Noise identification, Bragg peak identification etc.
% continuum R calculations
% fw - wave frequency (in Hz)
% R  - 2nd order (no units)
% Rw - 2nd order weighted by Barrick's weighting function (no units)
% Indices 1 to 4 are used to denote sidebands counting from lowest f to highest:
%    1-neg. freg. left of negative peak, 2-neg. side right of negative peak
%    3-pos. freq. left of positive peak, 4-pos. side right of positive peak
%

% second order sidebands
[fw1,E1,Ew1,fi1] = PXYsideband(freq,PXY,fn-Highf,fn-Lowfn,fn,1,switc1);
[fw2,E2,Ew2,fi2] = PXYsideband(freq,PXY,fn+Lowfn,fn+Highf,fn,2,switc1);
[fw3,E3,Ew3,fi3] = PXYsideband(freq,PXY,fp-Highf,fp-Lowfp,fp,3,switc1);
[fw4,E4,Ew4,fi4] = PXYsideband(freq,PXY,fp+Lowfp,fp+Highf,fp,4,switc1);

% save debug data
debug.E1  = E1;      debug.E2  = E2;      debug.E3  = E3;      debug.E4  = E4;
debug.Ew1 = Ew1;     debug.Ew2 = Ew2;     debug.Ew3 = Ew3;     debug.Ew4 = Ew4;
debug.R1  = E1/S1N;  debug.R2  = E2/S1N;  debug.R3  = E3/S1P;  debug.R4  = E4/S1P;
debug.Rw1 = Ew1/S1N; debug.Rw2 = Ew2/S1N; debug.Rw3 = Ew3/S1P; debug.Rw4 = Ew4/S1P;
debug.fw1 = fw1;     debug.fw2 = fw2;     debug.fw3 = fw3;     debug.fw4 = fw4;
debug.fi1 =fi1;      debug.fi2 =fi2;      debug.fi3 =fi3;      debug.fi4 =fi4;
debug.Noise = Noise; debug.S11 = [S1n S1p];
debug.braggpeaksSNR = [S1Npeak S1Ppeak]./Noise;
debug.PXY_or = PXY_or; debug.PXY = PXY;
debug.fn = fn;         debug.fp = fp;

% blanks energy at around 0 Hz (+/-flim)
E2i  = E2;
fw2i = fw2;
E2i(fi2 > -flim) = 0;    % negative peak inner sideband limit
E2i  = interp1(fw2i,E2i,fw1,'linear');

E3i = E3;
E3i(fi3 < flim) = 0;
fw3i = fw3;
E3i  = interp1(fw3i,E3i ,fw4,'linear');

debug.SNR2_n   = 10*log10(max(max([E1,E2i]))./Noise);
debug.SNR1_n   = 10*log10(max(S1Npeak)./Noise);
debug.dSigma_n = debug.SNR1_n - debug.SNR2_n;

debug.SNR2_p   = 10*log10(max(max([E3i,E4]))./Noise);
debug.SNR1_p   = 10*log10(max(S1Ppeak)./Noise);
debug.dSigma_p = debug.SNR1_p - debug.SNR2_p;

%%
% use all 4 sidebands
if debug.SNR1_n > snr1 && debug.SNR2_n > snr2 && debug.dSigma_n > dSigma && debug.SNR1_p > snr1 && debug.SNR2_p > snr2 && debug.dSigma_p > dSigma
    E1  = interp1(fw1,E1 ,fw4,'linear'); % extrap all frequencies to match fw4 (pos outer)
    E2  = interp1(fw2,E2 ,fw4,'linear');
    E3  = interp1(fw3,E3 ,fw4,'linear');
    Ew1 = interp1(fw1,Ew1,fw4,'linear');
    Ew2 = interp1(fw2,Ew2,fw4,'linear');
    Ew3 = interp1(fw3,Ew3,fw4,'linear');
    
    R  = (E1+E2+E3+E4)/(S1P+S1N);      % unweighted normalised 2nd second order
    Rw = (Ew1+Ew2+Ew3+Ew4)/(S1P+S1N);  % Barrick wind-wave weighted and normalised 2nd order
    fw = fw4;
    D  = (E1+E3)./(E2+E4);             % unweighted normalised 2nd second order
    Dw = (Ew1+Ew3)./(Ew2+Ew4);         % Barrick wind-wave weighted and normalised 2nd order
    
    debug.SNR2   = max(max([debug.SNR2_n,debug.SNR2_p]));
    debug.SNR1   = max(max([debug.SNR1_n,debug.SNR1_p]));
    debug.dSigma = max([debug.dSigma_n,debug.dSigma_p]);
    
    debug.sigma1 = nanmean([sigmap;sigman]);
        
    % if only sidebands 1 and 2 have required snr
elseif  debug.SNR1_n > snr1 && debug.SNR2_n > snr2 && debug.dSigma_n > dSigma
    % do not cross flim (default 0 Hz) for inner sideband
    E2(fi2 > -flim) = 0;    % negative peak inner sideband limit
    Ew2(fi2 > -flim) = 0;   % inner weighted
    
    E2  = interp1(fw2,E2 ,fw1,'linear');        % extrap frequencies to match each side of Bragg peak (inner to outer)
    Ew2 = interp1(fw2,Ew2,fw1,'linear');
    
    R  = (E1+E2)   / S1N; % unweighted second order ratio
    Rw = (Ew1+Ew2) / S1N; % ratio with Barrick wind-wave weighting
    fw = fw1;
    D  = E1./E2;     % unweighted 2nd order sideband direction ratio (positive sideband / negative sideband)
    Dw = Ew1./Ew2;   % weighted 2nd order sideband direction ratio
    
    debug.SNR2   = debug.SNR2_n;
    debug.SNR1   = debug.SNR1_n;
    debug.dSigma = debug.dSigma_n;
    debug.sigma1 = sigman;
    
    % if only sidebands 3 and 4 have required snr
elseif  debug.SNR1_p > snr1 && debug.SNR2_p > snr2 && debug.dSigma_p > dSigma
    % do not cross flim (default 0 Hz) for inner sideband - set values to 0
    E3(fi3 < flim) = 0;    % negative peak inner sideband limit
    Ew3(fi3 < flim) = 0;   % inner weighted
    
    E3  = interp1(fw3,E3 ,fw4,'linear'); % extrap frequencies to match each side of Bragg peak (inner to outer)
    Ew3 = interp1(fw3,Ew3,fw4,'linear');
    
    R  = (E3+E4)   / S1P; % unweighted second order ratio
    Rw = (Ew3+Ew4) / S1P; % ratio with Barrick wind-wave weighting
    fw = fw4;
    D  = E3./E4;         % unweighted 2nd order sideband direction ratio (positive sideband / negative sideband)
    Dw = Ew3./Ew4;       % weighted 2nd order sideband direction ratio
    
    debug.SNR2   = debug.SNR2_p;
    debug.SNR1   = debug.SNR1_p;
    debug.dSigma = debug.dSigma_p;
    debug.sigma1 = sigmap;
else
    dfw = fw1(2) - fw1(1);
    fw  = fw1(end):-dfw:0;
    fw  = fliplr(fw)';
    k   = length(fw1);% - length(E1);
    Rw0 = nan(k,1);
    Rw = nan(k,1);
    R = nan(k,1);
    Rw  = [Rw0 ; Rw];
    R   = [Rw0 ; R];
    Dnan = nan(k,1);
    Dw = nan(k,1);
    D = nan(k,1);
    D    = [Dnan ; D];
    Dw   = [Dnan ; Dw];
    debug.sigma1 = nan;
    debug.SNR2   = nan;
    debug.SNR1   =nan;
    debug.dSigma = nan;
    return
end
%

if fw(2) < fw(1)
    fw = flip(fw);
    R  = flip(R);
    Rw = flip(Rw);
    D = flip(D);
    Dw = flip(Dw);
end

% extend to 0 Hz
dfw = fw(2) - fw(1);
fw  = fw(end):-dfw:0;
fw  = fliplr(fw)';
k   = length(fw) - length(Rw);
Rw0 = nan(k,1);
Rw  = [Rw0 ; Rw];
R   = [Rw0 ; R];
Dnan = nan(k,1);
D    = [Dnan ; D];
Dw   = [Dnan ; Dw];

% smooth spectrum
Dw = movmean(Dw,3,1,'omitnan');

end % end of main function
