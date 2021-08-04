%% dopLipaS.m
%  This function calculates the swell frequency (fs), swell root mean square
%  waveheight (Hrms) and propogation direction (theta1,theta2) relative to the
%  radar beam direction. First it calculates the swell frequency (fs) and
%  cross cross (theta1) using maximum entropy method as in
%  Lipa and Barrick, 1981 eqs. 11-12. Then it calculates the rms waveheight
%  (hs) and cross angle (theta2) using eqs. 13-14.
%%
function [fs,Hs,theta2,thc2,thc1] = dopLipaS(freq,PXY,PXY2,beam1,beam2,fc,d)
%% Inputs
%  freq         - Doppler Spectral frequency in Hz
%  PXY          - Doppler spectrum of beam1 (in dB). Note, do not send arrays of NaN
%  PXY2         - Same as PXY but for different beam angle (beam2)
%  th_beamdiff  - Beam direction of PXY1 minus beam direction of PXY, in math
%                 notation (CCW positive)
%  fc           - frequency separating wind seas from swell seas
%  d            - water depth 
%
%% OUTPUT
%  fs      -(Hz) swell frequency
%  Hs      -(m) swell rms waveheight
%  theta2  -(degrees) swell propogation direction to PXY radar beam direction second solution
%  thc2    -(degrees) swell cross angle (Lipa swell cross angle solution 2)
%  thc1    -(degrees) swell cross angle (Lipa swell cross angle solution 1)
%  Note:  the quantity (thc1 - thc2) provides an estimate of swell direction accuracy
%
%% Uses
%  ConditionDopRSWIC.m  findSNR.m  dopLipa_sub.m
%  gamma_mm_depth.m  wrap180.m
%
%% References
%
%  Lipa B.J. and D.E. Barrick (1980), Methods for the extraction of long-period
%  ocean wave parameters from narrow beam HF radar sea echo. Radio
%  Sci 15(4):843–853
%
%  Lipa, B.J., D.E. Barrick, and J.W. Maresca Jr. (1981) HF radar measurements
%  of long ocean waves. Journal of Geophysical Research, Oceans 86.C5: 4089-4102.
%
%% Copyright(r) 2021, Zaid Al-attabi, Douglas Cahl, George Voulgaris
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
%% Main Program
% beamdiff - Beam direction of PXY2 minus beam direction of PXY, in math
% notation (CCW positive)
beamdiff = wrap180(beam2-beam1);  %

% save the origanl Doppler spectra 
PXY0 = PXY;

% call common functions, Noise identification, Bragg peak identification,
% etc. See inside function for more information.
ConditionDopRSWIC;

% Swell - Lipa 1981, multibeam - spec from xx degrees apart, PXY, PXY1 - dominant peaks
% both are peaks at dominant side - sometimes swell peaks are bigger on
% smaller side (add catch for this?)
% th_beamdiff is difference in beam direction, Lipa 1981 uses 30 degrees,
% math direction, ccw is pos, second - first beam dir
% th_beamdiff = 30;

[debug1] = findSNR(freq,PXY0);
[debug2] = findSNR(freq,PXY2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if debug1.SNR1_n > snr1 && debug1.SNR2_n > snr2 && debug1.dSigma_n > dSigma && debug2.SNR1_n > snr1 && debug2.SNR2_n > snr2 && debug2.dSigma_n > dSigma
    lowf = Lowfn;
elseif debug1.SNR1_p > snr1 && debug1.SNR2_p > snr2 && debug1.dSigma_p > dSigma && debug2.SNR1_p > snr1 && debug2.SNR2_p > snr2 && debug2.dSigma_p > dSigma
    lowf = Lowfp;
else
    lowf  = (Lowfn+Lowfp)./2;
end

% run each spectrum
[r_1,r_2,f_1,f_2,m2_12] = dopLipa_sub(freq,PXY0,fc); % Right beam
[r_3,r_4,f_3,f_4,m2_34] = dopLipa_sub(freq,PXY2,fc); % Left beam

if isnan(f_1) || isnan(f_2) || isnan(f_3) || isnan(f_4)
    thc1 = nan;
    thc2 = nan;
    theta2 = nan;
    fs     = 0;
    Hs     = 0;
else
    
    % rudimentary error minimization (computationally slow) - all three (theta,k,Hs) from 4 equations
    dth = 1;
    df = 0.001;
    dhs = 0.01;
    ths1 = -180:dth:180;
    fs1 = lowf:df:fc; % 0.05:0.0025:0.14
    ks1 = fs1.^2*4*pi^2/g; % deep water approx
    Hs1 = 0.01:dhs:4; % Hsig = 4*Hs = 0.1:0.04:8
    
    % Lipa 1981 eq 11,12, find th1, k1
    err2 = zeros(length(ths1),length(ks1));
    for i = 1:length(ths1)
        for j = 1:length(ks1)
            th1 = ths1(i);
            k1 = ks1(j);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            [~,~,fs1] = gamma_mm_depth(-1,m2_12,k0,k1,th1,d); %  m1 = -1;  % right beam, PXY
            [~,~,fs2] = gamma_mm_depth(+1,m2_12,k0,k1,th1,d); %  m1 = +1;
            [~,~,fs3] = gamma_mm_depth(-1,m2_34,k0,k1,th1+beamdiff,d); % left beam, PXY1
            [~,~,fs4] = gamma_mm_depth(+1,m2_34,k0,k1,th1+beamdiff,d);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % theoretical f
            F1 = fs1 - m2_12*fbragg;
            F2 = fs2 - m2_12*fbragg;
            F3 = fs3 - m2_34*fbragg;
            F4 = fs4 - m2_34*fbragg;
            % error = (delta_fR - Delta_FR)^2 + (delta_fL - Delta_FL)^2,
            % where L and R denote left and rigth beams, and f and F denote
            % measured and theoretical
            err2(i,j) = ((f_1 - f_2) - (F1 - F2))^2 + ((f_3 - f_4) - (F3 - F4))^2; % error
        end
    end
    % find error min
    min2 = min(err2(:));
    [i,j] = ind2sub(size(err2),find(err2==min2,1));
    thc1 = ths1(i); % swell cross angle
    k1 = ks1(j); % use in next part
    fs = sqrt(k1*g/4/pi^2);
    
    % Lipa 1981 eq 13,14, find th1, Hs
    err3 = zeros(length(ths1),length(Hs1));
    for i = 1:length(ths1)
        th1 = ths1(i);
        
        G1 = gamma_mm_depth(-1,m2_12,k0,k1,th1,d);          % m1 = -1; % right beam, PXY
        G2 = gamma_mm_depth(+1,m2_12,k0,k1,th1,d);          % m1 = 1;  % left beam, PXY1
        G3 = gamma_mm_depth(-1,m2_34,k0,k1,th1+beamdiff,d); % % left beam, PXY1
        G4 = gamma_mm_depth(+1,m2_34,k0,k1,th1+beamdiff,d);
      
        % Lipa assume the wind-wave residual coeff Cj = 1;
        C1 = 1;
        C2 = 1;
        C3 = 1;
        C4 = 1;
        
        for k = 1:length(Hs1)
            Hs = Hs1(k);
            R1 = 2*Hs^2*G1.*C1; % unknown Hs, k, theta, theorestical R
            R2 = 2*Hs^2*G2.*C2;
            R3 = 2*Hs^2*G3.*C3;
            R4 = 2*Hs^2*G4.*C4;
            err3(i,k) = (R1-r_1)^2 + (R2-r_2)^2 + (R3-r_3)^2 + (R4-r_4)^2; % error
        end
    end
    % find error min
    min3 = min(err3(:));
    [i,k] = ind2sub(size(err3),find(err3==min3,1));
    thc2 = ths1(i);        % swell cross angle
    theta2 = beam1-thc2;
    theta2 = wrap180(theta2);
    Hs = 2*sqrt(2)*Hs1(k); % RMS waveheight  
end

end % end of main function
