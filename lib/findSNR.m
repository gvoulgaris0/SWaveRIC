function [debug] = findSNR(freq,PXY)
% function [debug] = findSNR(freq,PXY)
%
% This function find the SNR of the swell peaks for all four sidebands 
% given a Doppler spectrum (PXY)
%
% - INPUT
% freq:        Array of Doppler Spectral frequency in Hz
% PXY(1:freq): Array of Spectral Energy (in dB), do not send arrays of NaN
%
% - OUTPUT
% debug (struct):
% debug.SNRX_y  : SNR for sideband 'X' (1-inner or 2-outer) for side 'y' 
%                 (n-negative or p-positive) of Doppler spectrum 
% debug.dSigma_y : difference in SNR between sidebands 1 and 2 for side 'y' 
%                  (n-negative or p-positive) of Doppler spectrum 
% 


%%
ConditionDopRSWIC;

[fw1x,E1x,Ew1x,fi1x] = PXYsideband(freq,PXY,fn-Highf,fn-Lowfn,fn,1);
[fw2x,E2x,Ew2x,fi2x] = PXYsideband(freq,PXY,fn+Lowfn,fn+Highf,fn,2);
[fw3x,E3x,Ew3x,fi3x] = PXYsideband(freq,PXY,fp-Highf,fp-Lowfp,fp,3);
[fw4x,E4x,Ew4x,fi4x] = PXYsideband(freq,PXY,fp+Lowfp,fp+Highf,fp,4);


%% blanks energy at around 0 Hz (+/-flim)
E2i = E2x;
E2i(fi2x > -flim) = 0;    % negative peak inner sideband limit
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


end