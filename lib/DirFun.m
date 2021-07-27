%% DirFun.m
% Wave spreading functions
%%
function [G]=DirFun(s,Thm,th,B,model)
%% INPUT
%  s     = Directional spreading factor      
%  Thm   = Mean Direction of Waves (in Radians)
%  th    = Radar Angle (in Radians)/Ellipse Normal
%  model = model used for wave spreading 
%          (=1) Hasselmann et al., 1980 
%          (=2)Donelan at al., 1985

%% OUTPUT
%  G  = wave spectrum direction function G(th)

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
%% Program
if model == 1 % Hasselmann et al., 1980
    FSA     = abs(cos(0.5*(th-Thm)).^(2*s));
    FSB     = (gamma(s+1)).^2./gamma(2*s+1);
    G       = ((2.^(2*s-1))/pi).*FSA.*FSB;
elseif model == 2 % Donelan at al., 1985
    FSA     = sech(B.*(th-Thm)).^2;
    FSB     = 0.5*B;
    G       = FSB.*FSA;
end
