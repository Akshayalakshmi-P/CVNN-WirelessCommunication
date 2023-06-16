function [normalised_val]=computenorm(INPUTMAT)
x=real(INPUTMAT)^2;
y=imag(INPUTMAT)^2;
normalised_val=sqrt(x+y);
end