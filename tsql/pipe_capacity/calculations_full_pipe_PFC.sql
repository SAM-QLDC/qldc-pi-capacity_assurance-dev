SET $roughness = 0.3;
SET $dyn_visc = 0.00000114;
SET $deg_rad_convert = 0.0174532925;

SET $gradient = gradient;
SET $pipe_size = width/1000;
SET $depth = $pipe_size;
SET $pipe_gradient = 1/$gradient;

SET $theta = 2 * (ACOS((1-((2*$depth)/$pipe_size)))) * $deg_rad_convert;
SET $wettedP = ($pipe_size * $theta)/2;
SET $pipe_area = (($pipe_size^2)/8) * ($theta - SIN($theta));
SET $hydrR = $pipe_area / $wettedP;
SET $SCF = ($theta-(SIN($theta)))/$theta;
SET $velocity = -2 * ((2 * 9.81 * $gradient * $SCF * $pipe_size)^0.5) * LOG(((($roughness/1000)/(3.7 * $SCF * $pipe_size)) + ((2.51 * $dyn_visc) / (($SCF * $pipe_size)*((2 * 9.81 * $gradient * $SCF * $pipe_size)^0.5)))));
SET $flow = (($velocity * $SCF * $theta * ($pipe_size^2))/8) *1000;
SET $widthB =($pipe_size) * SIN($theta/2);
SET $HydrMeanD = $pipe_area/$widthB;
SET $FroudeNo = $velocity / ((9.81*$HydrMeanD)^0.5);

/*
SET capacity = $flow/1000, capacity_flag = 'AD'
WHERE capacity is null 
AND gradient is not null 
AND us_invert is not null 
AND ds_invert is not null 
AND shape = 'CP'; */

SELECT asset_id, $pipe_gradient, $theta, $wettedP, $pipe_area, $hydrR, $SCF, $velocity, $flow