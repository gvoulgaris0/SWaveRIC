function [Sf_th]=create_2d_spectrum(Sf,s,Thm,th,B,model)

% INPUT:
% Sf    = Input wave spectrum as a function of frequency
% s     = Directional spreading factor
% Thm   = Mean Direction of Waves (in Radians)
% th    = Radar Angle (in Radians)/Ellipse Normal

% OUTPUT:
% Sf_th  = 2D directional spectrum S(f,theta)

%

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

end
%%
