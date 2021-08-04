%% create_2d_spectrum.m
function [Sf_th]=create_2d_spectrum(Sf,s,Thm,th,B,model)
% Function to convert 1-D Wave energy spectrum (E(f)) to 
% a directional spectrum (E(f,th)) using a sec or a cos directional
% distribution function.
%% Inputs
%  Sf    = Input wave spectrum as a function of frequency
%  s     = Directional spreading factor
%  Thm   = Mean Direction of Waves (in Radians)
%  th    = Radar Angle (in Radians)/Ellipse Normal
%  model = 1 - uses cos directional distribution
%        = 2 - uses sech directional distribution
%% Outputs
% Sf_th  = 2D directional spectrum S(f,theta)
%
%% Main Function
if model == 1    
    FSA     = abs(cos(0.5*(th-Thm)).^(2*s));
    FSB     = (gamma(s+1)).^2./gamma(2*s+1);
    G       = ((2.^(2*s-1))/pi).*FSA.*FSB;
elseif model == 2
    FSA     = sech(B.*(th-Thm)).^2;
    FSB     = 0.5*B;
    G       = FSB.*FSA;
end
Sf_th   = Sf.*G;
end % End of main program
%%
