//LET $scenario = 'DES';

LET $dyn_visc = 0.00000114;
LET $deg_rad_convert = 0.0174532925;

UPDATE IN SCENARIO $scenario SET $gradient = 1/gradient;
UPDATE IN SCENARIO $scenario SET $pipe_size = conduit_width / 1000;
UPDATE IN SCENARIO $scenario SET $roughness = bottom_roughness_CW;
UPDATE IN SCENARIO $scenario SET $depth_full = conduit_width / 1000;
UPDATE IN SCENARIO $scenario SET $theta = 2 * (ACOS((1-((2*$depth_full)/$pipe_size)))) * $deg_rad_convert;
UPDATE IN SCENARIO $scenario SET $theta_xrad = 2 * (ACOS((1-((2*$depth_full)/$pipe_size))));
UPDATE IN SCENARIO $scenario SET $wettedP = ($pipe_size * $theta)/2;
UPDATE IN SCENARIO $scenario SET $pipe_area = (($pipe_size^2)/8) * ($theta - SIN($theta_xrad));
UPDATE IN SCENARIO $scenario SET $hydrR = $pipe_area / $wettedP;
UPDATE IN SCENARIO $scenario SET $SCF = ($theta-(SIN($theta_xrad)))/$theta;
UPDATE IN SCENARIO $scenario SET 
	$velocity = 
		-2 * 
		((2 * 9.81 * (1/$gradient) * $SCF * $pipe_size)^0.5) * 
		LOG(((($roughness/1000)/(3.7 * $SCF * $pipe_size)) + 
		((2.51 * $dyn_visc) / (($SCF * $pipe_size)*
		((2 * 9.81 * (1/$gradient) * $SCF * $pipe_size)^0.5)))));
	
UPDATE IN SCENARIO $scenario SET $flow = (($velocity * $SCF * $theta * ($pipe_size^2))/8) * 1000;
UPDATE IN SCENARIO $scenario SET $widthB =($pipe_size) * SIN($theta_xrad/2);
UPDATE IN SCENARIO $scenario SET $HydrMeanD = $pipe_area/$widthB;
UPDATE IN SCENARIO $scenario SET $FroudeNo = $velocity / ((9.81*$HydrMeanD)^0.5);

UPDATE IN SCENARIO $scenario 
SET user_number_8 = $velocity