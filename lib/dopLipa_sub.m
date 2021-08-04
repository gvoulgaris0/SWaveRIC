%% dopLipa_sub.m
function [r1,r2,f1,f2,m2] = dopLipa_sub(freq,PXY,fc)
% function [r1,r2,f1,f2,m2] = dopLipa_sub(freq,PXY,fc)
%
% This function calculated the swell peak energy ratios (r1, r2) for the
% lower and higher frequency (f1,f2) swell peaks surrounding the largest
% Bragg peak.
%
%% Inputs
%  freq       : Array of Doppler Spectral frequency in Hz
%  PXY(1:freq): Array of Spectral Energy (in dB), do not send arrays of NaN
%  fc         : Swell cutoff frequency
%
%% Outputs
%  r1 : integrated energy of lower frequency swell peak divided by
%       Bragg peak - ratio used in Lipa and Barrick 1980.
%  r2 : same as r1 but for higher frequency swell peak
%  f1 : frequency of lower frequency swell peak
%  f2 : frequency of higher frequency swell peak
%
%% Uses
%  ConditionDopRSWIC
%  swell_peak.m
%  PXYsideband.m
%
%% Main function
% call common functions, Noise identification, Bragg peak identification,
% etc. See inside function for more information.
ConditionDopRSWIC;
% for only dominant swell ratios for multibeam Lipa 1981 method
[f1,~,S1,~] = swell_peak(freq,PXY, fn-fc , fn-Lowfn   ); % 2nd order to the left (l) of Neg 1st
[f2,~,S2,~] = swell_peak(freq,PXY, fn+Lowfn   , fn+fc ); % 2nd order to the right (r) of Neg 1st
[f3,~,S3,~] = swell_peak(freq,PXY, fp-fc , fp-Lowfp   ); % 2nd order to the left (l) of Pos 1st
[f4,~,S4,~] = swell_peak(freq,PXY, fp+Lowfp   , fp+fc ); % 2nd order to the right (r) of Pos 1st

[fw1x,E1x,Ew1x,fi1x] = PXYsideband(freq,PXY,fn-Highf,fn-Lowfn,fn,1);
[fw2x,E2x,Ew2x,fi2x] = PXYsideband(freq,PXY,fn+Lowfn,fn+Highf,fn,2);
[fw3x,E3x,Ew3x,fi3x] = PXYsideband(freq,PXY,fp-Highf,fp-Lowfp,fp,3);
[fw4x,E4x,Ew4x,fi4x] = PXYsideband(freq,PXY,fp+Lowfp,fp+Highf,fp,4);


% blank energy at around 0 Hz (+/-flim)
E2i = E2x;
E2i(fi2x > -flim) = 0;    
E2i  = interp1(fw2x,E2i,fw1x,'linear');
debug.SNR2_n   = 10*log10(max(max([E1x,E2i]))./Noise);
debug.SNR1_n   = 10*log10(max(S1Npeak)./Noise);
debug.dSigma_n = debug.SNR1_n - debug.SNR2_n;


E3i = E3x;
E3i(fi3x < flim) = 0;
E3i  = interp1(fw3x,E3i ,fw4x,'linear');
debug.SNR2_p   = 10*log10(max(max([E3i,E4x]))./Noise);
debug.SNR1_p   = 10*log10(max(S1Ppeak)./Noise);
debug.dSigma_p = debug.SNR1_p - debug.SNR2_p;

% check data quality and use higher energy sidebands (positive or negative sidebands)
if debug.SNR1_n > snr1 && debug.SNR2_n > snr2 && debug.dSigma_n > dSigma
    r1 = S1/S1N;
    r2 = S2/S1N;
    f1 = f1 - fn;
    f2 = f2 - fn;
    m2 = -1;
elseif debug.SNR1_p > snr1 && debug.SNR2_p > snr2 && debug.dSigma_p > dSigma
    r1 = S3/S1P;
    r2 = S4/S1P;
    f1 = f3 - fp;
    f2 = f4 - fp;
    m2 = 1;
else
    r1 = nan;
    r2 = nan;
    f1 = nan;
    f2 = nan;
    m2 = nan;
end

end % End of main function