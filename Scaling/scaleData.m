function [data] = scaleData(data,scaleOption)
if scaleOption == 1
    data = rescaling(data);
else %scaleOption == 2
    data = standardization(data);
%else data = scaleUnitLength(data);
end %endIf