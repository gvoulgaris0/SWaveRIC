%% specSwellRSWIC.m
%  Function to estimate swell spectrum (Gaussian shape) and wave height
%%
function [Sfs] = specSwellRSWIC(fw,fs,hrms,sigma)

%% Inputs
%  fw       = wave frequency array
%  fs       = swell wave frequency
%  hrms     = rms waveheight of swell
%  sigma    = Gaussian width

%% Output
%  Sfs      = swell wave frequency spectrum

%% Copyright 
%  2021 Zaid Alattabi, Douglas Cahl, George Voulgaris
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
% constants
% swell spectrum of Gaussian form
if nargin<4 || sigma<0 || sigma >0.20
    sigma=0.08;     % Default value
end
Hss   = sqrt(2).*hrms;      % Significant wave height, Hsig
Sfs   = ((Hss^2/16)/sqrt(2*pi*sigma^2))* exp( -(fw-fs).^2 ./ (2*sigma^2) );
end
%%