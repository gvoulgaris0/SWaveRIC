function [Sfth] = Inverted_2D_DirSpec(fp,th,Df,Sf,f,wspd,model)
% function [Sfthi] = Inverted_2D_DirSpec(fp,th,Df,Sf,f,wspd,model)
% Creates a 2D (directional) wave spectrum
%
%% INPUT:
% f     = wave frequency
% fp    = inverted peak wave frequency
% Sf    = wave spectrum S(f)
% Df    = Wave direction D(f)
% s     = Directional spreading factor
% th    = Radar Angle (in Radians)/Ellipse Normal
% model = 1 (use the directional distribution function of cos^2s)
%       = 2 (use the directional distribution function of sech)

%% OUTPUT:
%  Sfth  = 2D wave spectrum S(f,theta)

%% USES:
%  DirFun.m   spreadparam.m
%%
Sfth = zeros(length(f),length(th));
for i = 1:length(f)
    [s,B] = spreadparam(fp,f(i),wspd);
    [G]=DirFun(s,Df(i)*pi/180,th*pi/180,B,model);
    G = G*pi/180;
    Sfth(i,:) = Sf(i).*G;
end


end