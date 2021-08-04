%% gamma_mm_depth
function [G,C,f] = gamma_mm_depth(m1,m2,k0,kso,ths,d) 
% [G,C,f] = gamma_mm(m1,m2,k0,k1,th1) 
%  
% this function calculates the coupling coefficient (G), residual term (C)
% and frequency positions (f) of four swell peaks (m1 = +/-1, m2 = +/- 1)
% for a radar wavenumber (k0) and a swell wavenumber (k1) with an angle
% between the radar beam direction and the wave propogation direction given
% by th1 (in degrees). 
%
% m1 denotes the positive and negative Bragg peaks
% m2 denotes left or right of the Bragg peak (m1)
% The peaks are numbered sequentially 1 to 4 from lowest freq to highest, 
% so 1 is negative frequency range, outside swell peak, and 4 is positive outside swell peak
% 1 = m1(m) = -1, m2(m') = -1
% 2 = m1(m) = -1, m2(m') = +1
% 3 = m1(m) = +1, m2(m') = -1
% 4 = m1(m) = +1, m2(m') = +1
%
% f, G are given in Lipa and Barrick 1980
% C is approximated by a PM spectrum given in Wang et al. 2016. 
%
%% Inputs
%  m1 = -1 for negative Bragg peak, +1 for positive Bragg peak
%  m2 = -1 for left of Bragg peak, +1 for right of Bragg peak
%  k0 = radar wavenumber 
%  k1 = swell wavenumber 
%  th1 = angle between swell propogation direction (k1) and radar beam direction (k0)
%  d   = depth 
%
%% Outputs
%  G = |gamma|_j^2 where gamma = gamma_EM + gammma_hydro (deep water
%  approximation, see Appendix in Wang et al. 2016 or Lipa and Barrick 1980
%  C = C_j calculated using the approximation in Wang, 
%  f = f_j the theoretical swell peak frequency 
%
%% References
%
%  Lipa BJ, Barrick DE (1980) Methods for the extraction of long-period
%  ocean wave parameters from narrow beam HF radar sea echo. Radio Sci 15(4):843–853
%  
%  Lipa BJ, Barrick DE (1986) Extraction of sea state from HF radar sea
%  echo: mathematical theory and modeling. Radio Sci 21(1):81–100.
%
%  Wang, Weili, Philippe Forget, and Changlong Guan. "Inversion and 
%  assessment of swell waveheights from HF radar spectra in the Iroise Sea."
%  Ocean Dynamics 66.4 (2016): 527-538.
%
%% Main
% constants
delta = 0.011 - 0.012*1i; % impedance
g = 9.81;

%ks=wave_dispersion_h(kso,d);
ks = kso;
%k0=wave_dispersion_h(k0,d);

k1x = ks*cosd(ths);
k1y = ks*sind(ths);

k0y = 0; % k0*sind(th0);

% calculate k2, wind wave that scatters with the k1, swell wave radar k
k0x = k0; %k0*cosd(th0);
if m1 < 0
    k0x = - k0x;
end
k2x = -2*k0x - k1x;
k2y = -2*k0y - k1y;
k2 = sqrt(k2x^2+k2y^2);

kb = 2*k0;
%wb = sqrt(g*kb);
%ws = sqrt(g*k1);
wb = sqrt(kb*g*tanh(kb*d));
ws = sqrt(ks*g*tanh(ks*d));
% Lipa
w = m1*ws+m2*(wb^4+2*m1*ws^2*wb^2*cosd(ths)+ws^4)^(1/4);
f = w/2/pi;

k1k0 = k1x*k0x+k1y*k0y;
k2k0 = k2x*k0x+k2y*k0y;
k1k2 = k1x*k2x+k1y*k2y;

g_em = (1/2)*((k1k0*k2k0)/(k0^2) - 2*k1k2) / ( sqrt(k1k2) - k0*delta);

k1 = sqrt(k1x^2+k1y^2);
k11 = k1*tanh(k1*d);
k22 = k2*tanh(k2*d);

F1 = k11+k22;
F2 = (((k11*k22)-k1k2)./(m1*m2*sqrt(k11*k22)));        
F3 = (w^2+wb^2)./(w^2-wb^2);
F4 = w*(((m1*sqrt(g*k1))^3)*(csch(k1*d)^2));
F5 = w*(((m2*sqrt(g*k2))^3)*(csch(k2*d)^2));
F6 = g*(w^2-wb^2);

g_h = (-1i*0.5).*(F1-(F2*F3)+((F4+F5)/F6));

gamma = g_em + g_h;
G = abs(gamma)^2;

% Wang/Forget approximations
C = (1+(k1/k0)^2/4 + m1*k1*cosd(ths)/k0)^-2; % Wang approx using P-M spec, Lipa assume C_j = 1
end % End of main program