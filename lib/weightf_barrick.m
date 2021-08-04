%% weightf_barrick.m
%  Estimating the weighting function of Barrick 1977
%
function w = weightf_barrick(fb,fw,side,cut1)
%% Call:
%  w = weightf_barrick(fb,fw,side,[cut1]) 
%
%  This function calculates the Barrick's (1977) weighting function
%  to eliminate the contribution of wave-wave interactions in the second
%  order peaks of Doppler spectra. 
% 
%  The Bragg frequency of the radar (in Hz) is given by fb. fw is the
%  frequencies (in Hz) of the ocean wave spectrum it is internally converted
%  to Doppler frequency fd=fw+fb or fd=fw-fb and then to normalized Doppler
%  frequency v = fd/fb
%
%  Digitized (DLC 2018) from Figure 3 in Barrick, D.E., 1977. Extraction of
%  wave parameters from measured HF radar sea-echo Doppler spectra. Radio
%  Sci. 12, 415–424. https://doi.org/10.1029/RS012i003p00415
% 
%% Inputs
%  fb   - Bragg Frequency (in Hz) of the HF radar
%  fw   - Ocean wave frequencies (in Hz)
%  side - -1 for inner side-band (closer to 0 Hz side of the Bragg peak)
%         +1 for outer side-band (larger absolute freq. values than fbragg)
%  cut1 - [optional, default value 0] 
%          If =1, then it cuts off negative normalized freqs (after crossing 0 Hz)
%
%% Outputs
%  w   - weighting function values
%
%% Copyright 
%  2021 Zaid Al-attabi, Douglas Cahl, George Voulgaris
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
%%
if nargin < 4
    cut1 = 0;
end

% points from figure digitization in x = f_dopper/f_bragg and y = w
% 3 curves in log10 of w
x1 = [0.0821 0.1096 0.1806 0.2888 0.5438 0.6584 0.9199 1.0491 1.1895 1.2993 1.4139];
y1 = [968.6990 430.6176 94.4144 22.7306 2.1925 1.6220 2.3580 2.6163 2.3580 2.9029 5.1953];
x2 = [1.4187 1.4752 1.5156 1.5689 1.5979 1.6173 1.6706];
y2 = [5.1953 2.5097 1.9154 3.5001 7.3211 12.4393 108.0739];
x3 = [1.6706 1.6851 1.7061 1.7400 1.8158 1.9143 1.9740 2.0886 2.2194 2.3889];
y3 = [105.8505 37.0486 10.3167 6.5302 5.3599 5.8246 6.7370 8.6458 11.9327 17.8973];
pp4 = polyfit(x3(end-1:end),log10(y3(end-1:end)),1); % linear in log10 fit for normalized freq > 2.4

% Convert ocean wave frequencies to normalized doppler frequency (fD/fB)
fw = fw(:);     % ocean wave frequency range
if side>0       % right side of Bragg peak
    fD = fw+fb; % radar Doppler frequencies
else            % left side of Bragg peak
    fD=fb-fw;   % radar Doppler frequencies
end
f = fD/fb;      % normalized radar Doppler freq

w=nan(size(f)); % Pre-allocate array

% extrapolate each continuous curve, in log10 with cubic spline interp
i1 = find(abs(f)>=0 & abs(f) <=sqrt(2));
if ~isempty(i1)
    w(i1) = 10.^(spline(x1,log10(y1),abs(f(i1)))); % spline in log10 space
end

i2 = find(abs(f) >sqrt(2) & abs(f)<=2^(3/4));
if ~isempty(i2)
    w(i2) = 10.^(spline(x2,log10(y2),abs(f(i2))));
end

i3 = find(abs(f)>2^(3/4) & abs(f)<=2.4);
if ~isempty(i3)
    w(i3) = 10.^(spline(x3,log10(y3),abs(f(i3))));
end

i4 = find(abs(f)>2.4);
if ~isempty(i4)
    w(i4) = 10.^(polyval(pp4,abs(f(i4)))); % straight line extrap in log10
end

if cut1 == 1
    i = f < 0;
    w(i) = nan;
end
end % End of main function