%% wrap180.m
% convert angle to +/-180
function x = wrap180(x)
%% Input
%  x - angle in degrees
%% Output
%  x - angle in degrees so that abs(x)<180
x(x>180)  = x(x>180)-360;
x(x<-180) = x(x<-180)+360;
end