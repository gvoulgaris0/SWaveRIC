%% wrap180.m
% puts angle to +/-180
function x = wrap180(x)
x(x>180)  = x(x>180)-360;
x(x<-180) = x(x<-180)+360;
end