// work out average dry weather flow for each pipe based on upstream population

//LET $scenario = 'DES';

LIST $systems_pop = 'Foul', 'foul', 'Combined', 'combined', 'Sanitary', 'sanitary';

UPDATE [Subcatchment] IN SCENARIO $scenario SET 
$sub_pop = IIF(MEMBER(system_type, $systems_pop) = 1, population, 0);

UPDATE [Node] IN SCENARIO $scenario SET $POP = SUM(subcatchments.$sub_pop); 

UPDATE IN SCENARIO $scenario SET $pipePOP = NVL(us_node.$POP, 0);

UPDATE IN SCENARIO $scenario SET $usPOP = NVL(SUM(all_us_links.$pipePOP), 0);

UPDATE IN SCENARIO $scenario SET $popCALC = $pipePOP + $usPOP;

UPDATE IN SCENARIO $scenario SET $popNO = IIF($popCALC = 0, 10, $popCALC);

UPDATE IN SCENARIO $scenario SET user_number_10 = $popNO;

//SELECT us_node_id, $popNO