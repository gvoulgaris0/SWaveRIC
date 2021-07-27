%% Gauss_fit.m
%  Fits a Gausian curve to data
%%
function [sigma,mu,A]=Gauss_fit(x,y)
%% [sigma,mu,A]=Gauss_fit(x,y)
%
%  Function that fits a Gaussian (normal distribution) curve on data x, y
%  Y = (A * exp( -(X-mu).^2 ./ (2*sigma^2) ));
%  It is used to simulate the 1st Bragg peak and find its width.
%
%%  Input
%     x     - X values (i.e., frequency, f)
%     y     - Y values (linear units, i.e., Spectral energy)
%
%%  Output
%     sigma -  standard deviation of normal distribution indicating the
%              broadening of the distribution
%     mu    -  Mean value indicating mean(x) where the peak is located
%     A     -  Normalizing coefficient.
%
%% Copyright 2019 Zaid Alattabi, Douglas Cahl, George Voulgaris
%
% This file is part of RadarWIC.
%
% RadarWIC is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <https://www.gnu.org/licenses/>.
%
%% Condition data
y = log(y(:));   % Convert from linear to log units
x = x(:) ;

%% Fit parabola
p  = polyfit(x,y,2);
A2 = p(1);
A1 = p(2);
A0 = p(3);

%% Estimate Gaussian parameters from parabolic fit
sigma   = sqrt(-1/(2*A2)); 
mu      = A1*sigma^2;         
A       = exp(A0+mu^2/(2*sigma^2));
end
