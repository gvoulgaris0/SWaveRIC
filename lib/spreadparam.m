%% spreadparam.m
%  Wave spreading parameter calculation using:
%  a) Hasselmann, D. E., M. Dunckel, and J. Ewing, 1980:
%     Directional wave spectra observed during JONSWAP 1973.
%  b) Donelan, M. A., J. Hamilton, and W. H. Hui, 1985:
%     Directional spectra of wind-generated ocean waves. 
function [s,B] = spreadparam(fp,f1,U10)
%% INPUT
%  fp   = peak frequency
%  f1   = wave frequency
%  U10  = wind speed at 10m elevation (optional)

%% OUTPUT
%  s    = wave spreading parameter (Hasselmann et al. 1980)
%  B    = wave spreading parameter (Donelan et al. 1985)

%% Program

% Hasselmann, D. E., M. Dunckel, and J. Ewing, 1980:
% Directional wave spectra observed during JONSWAP 1973.
if isempty(U10)
    s = nan;
else
    Cp = 9.8./fp;
    M = -2.33-1.45*((U10./Cp)-1.17);
    if f1<1.05*fp
        s = 6.97.*(f1./fp).^4.06;
    elseif f1>=1.05*fp
        s = 9.77.*(f1./fp).^M;
    else
        s = nan;
    end
end

% Donelan, M. A., J. Hamilton, and W. H. Hui, 1985:
% Directional spectra of wind-generated ocean waves. 
if f1/fp > 0.56 && f1/fp <0.95
    B = 2.61*((f1./fp).^1.3);
elseif f1/fp > 0.95 && f1/fp <1.6
    B = 2.28*((f1./fp).^-1.3);
else
    B = 1.24;
end
