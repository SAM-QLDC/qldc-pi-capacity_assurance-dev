// work oupstream area connected to each sewer pipe - use foul system type

//LET $scenario = 'DES';

LIST $systems_area = 'Foul', 'foul', 'Combined', 'combined', 'Sanitary', 'sanitary';

UPDATE [Subcatchment] IN SCENARIO $scenario SET 
$runoff_area = IIF(MEMBER(system_type, $systems_area) = 1, total_area, 0);

UPDATE [Node] IN SCENARIO $scenario SET $area = SUM(subcatchments.$runoff_area); 

UPDATE IN SCENARIO $scenario SET $pipeAREA = NVL(us_node.$area, 0);
UPDATE IN SCENARIO $scenario SET $usAREA = NVL(SUM(all_us_links.$pipeAREA),0);
UPDATE IN SCENARIO $scenario SET $areaCALC = $pipeAREA + $usAREA;
UPDATE IN SCENARIO $scenario SET $areaHA = IIF($areaCALC = 0, 0.5, $areaCALC);

UPDATE IN SCENARIO $scenario SET user_number_9 = $areaHA;

//SELECT us_node_id, $pipeAREA DP 5,  $usAREA DP 5, $areaCALC DP 5, $areaHA DP 5