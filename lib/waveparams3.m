%% waveparams3.m
%  function to estimate partitioned (swell, wind and bulk) wave parameters 
%  from 1D- wave spectrum S(f)
%%
function [paramsT,paramsS,paramsW] = waveparams3(fc,Sf,f,Df)
%% Inputs
%  f  - wave frequency (Hz)
%  Sf - wave spectrum (m^2/Hz)
%  Df - wave direction (degrees, math notation)
%  fc - seperation freq
%% Ouputs
%  paramsT = Array total wave parameters(1:5);
%  paramsS = Array swell wave parameters(1:5);
%  paramsW = Array wind-wave parameters(1:5);
%
% where each array of wave parameters (paramsX) includes
%  col(1) = Hrms  -  Significant wave height (m)
%  col(2) = fp  -  peak wave frequency (Hz)
%  col(3) = fm  -  mean wave frequency (Hz)
%  col(4) = Thetap -  peak wave direction (degrees, math notation)
%  col(5) = Thetam -  mean wave direction (degrees, math notation)
%% Uses
%  waveparams.m
%% Copyright 
%  2021 Zaid Al-Attabi, Douglas Cahl, George Voulgaris
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
%% Program
xs  = find(f<=fc); % find the swell freq band
Sfs = Sf(xs);
Dfs = Df(xs);
fs  = f(xs);

xw  = find(f>fc);      % find the wind-wave freq band
xw  = [xw(1)-1 xw];  % include point below for correct Trapz integration
Sfw = Sf(xw);
Dfw = Df(xw);
fw  = f(xw);

% inverted swell params
if length(Sfs(~isnan(Sfs))) < 2
    paramsS = nan(5,1);
else
    [paramsS] = waveparams(fs,Sfs,Dfs);
end

% inverted wind-wave params
if length(Sfw(~isnan(Sfw))) < 2
    paramsW = nan(5,1);
else
    [paramsW] = waveparams(fw,Sfw,Dfw);
end

% inverted bulk wave params
if length(Sf(~isnan(Sf))) < 2
    paramsT = nan(5,1);
else
    [paramsT] = waveparams(f,Sf,Df);
end
end % end of main function
