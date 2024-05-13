
function [dataNorm] = normalize(energy_signal)
 
minimum = min(energy_signal(1, :));
maximum = max(energy_signal(1, :));
dataNorm = (energy_signal(1, :)-minimum)./(maximum-minimum);
 
end
