function [newX] = scaleUnitLength(x)
newX = x/norm(x);