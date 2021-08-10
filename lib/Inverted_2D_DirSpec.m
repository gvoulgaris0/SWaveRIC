%% Inverted_2D_DirSpec.m
% Creates a 2D (directional) wave spectrum from the frequency spectrum and directional spectrum
function [Sfth] = Inverted_2D_DirSpec(fp,th,Df,Sf,f,wspd)
%% INPUT:
%  f     = wave frequency
%  fp    = inverted peak wave frequency
%  Sf    = wave spectrum S(f)
%  Df    = Wave direction D(f)
%  s     = Directional spreading factor
%  th    = Radar Angle (in degrees)/Ellipse Normal
%  model = 1 (use the directional distribution function of cos^2s)
%        = 2 (use the directional distribution function of sech)

%% OUTPUT:
%  Sfth  = 2D wave spectrum S(f,theta)

%% USES:
%  DirFun.m   spreadparam.m
%% Model choice depends if wind speed data exists
if ~isempty(wspd)
    model = 1; % The directional distribution model of sech is used.
else
    model = 2;
end

model = 2; % used in Al-Attabi et al 2021
%% Main
Sfth = zeros(length(f),length(th));
for i = 1:length(f)
    [s,B]     = spreadparam(fp,f(i),wspd);
    G         = DirFun(s,Df(i),th,B,model);
    G = G*pi/180;
    Sfth(i,:) = Sf(i).*G;
end
