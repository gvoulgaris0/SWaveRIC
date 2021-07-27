%% specWindRSWIC.m
%  Wind wave inversion. This function calculated the wave spectrum (Sf) from radar
%  2nd order sidebands (Rw). It also calculates the wave direction as a function
%  of wave frequency (fw).
%%
function [Sf,thw] = specWindRSWIC(Rw,Dw,aw,Rw2,Dw2,theta_beam_1,theta_beam_2,model)
%% Input
%  Rw              - Normalised and wheighted 2nd order
%  Dw              - Ratio of normalized and weighted 2nd order sideband around a peak [(Rw_right_of_peak)/(Rw_left_of_peak)]
%  aw              - Calibration coefficient (ex. 0.30)
%  theta_beam_1    - beam angle for Rw
%  theta_beam_2    - beam angle for Rw2
%  model           - switch for chosen cos^2 (model = 1), or sech (model = 2)
%
%% Ouput
%  Sf    - Wave energy density spectrum (m^2/Hz)
%  thw   - Wave direction per frequency (thw(f), in degs)
%          direction is defined mathematically (i.e., toward) and it is measured
%          counterclockwise from radar beam direction. Two values are given
%          only one is correct (abiquity issue).
%
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
%% Main function
global fr
lradar  = 299.8/fr;         % Bragg wavelength
k0      = 2*pi/lradar;      % Radar wavenumbers
% Inversion % this was used
if nargin > 3
    Sf   = ((2.*(Rw+Rw2))./(k0^2)).*aw;
else
    Sf   = ((Rw*2)./(k0^2)).*aw;
end
if nargin >= 7
    D_1 = Dw;
    D_2 = Dw2;
    theta_w = -180:180;
    if nargin > 7
        if model == 1 % default cos^2(0.5*theta)
            F = @(x) cosd(0.5*x).^2;
        elseif model == 2 % sech^2(0.8*theta) Gurgel 2006 /from Wyatt suggestion
            F = @(x) sech(0.8*x*(pi/180)).^2;
        end
    end
    F1  = F(theta_w - theta_beam_1);
    F11 = F(theta_w - theta_beam_1 + 180);
    F2  = F(theta_w - theta_beam_2);
    F22 = F(theta_w - theta_beam_2 + 180);
    % eq4 = [D_1 - F(theta_cross - theta_beam_1)/ F(theta_cross - theta_beam_1 + pi)].^2 +
    % [D_2 - F(theta_w - theta_beam_2)/ F(theta_w - theta_beam_2 + pi)].^2
    thw = Dw*0;
    for ii = 1:length(D_1(:,1))
        for jj = 1:length(D_1(1,:))
            D_1i = D_1(ii,jj);
            D_2i = D_2(ii,jj);
            eq4 = (D_1i - F1./F11).^2 + (D_2i - F2./F22).^2;
            [~,imin1] = min(eq4,[],2);
            thw(ii,jj) = theta_w(imin1);
        end
    end
else
    thw = [];
end

end