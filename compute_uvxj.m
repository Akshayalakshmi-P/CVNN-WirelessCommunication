function [uxj, uyj, vxj, vyj]=compute_uvxj(x,y)
%Note that x and y must be the values before normalization
uxj=(y^2)/((x^2+y^2)^(3/2));
vyj=(x^2)/((x^2+y^2)^(3/2));
uyj=-x*y/((x^2+y^2)^(3/2));
vxj=-x*y/((x^2+y^2)^(3/2));