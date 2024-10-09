// work out average dry weather flow for each pipe based on upstream population

//LET $scenario = 'DES';

// wellington city
UPDATE [Subcatchment] IN SCENARIO $scenario
SET $sub_com = IIF(INT(user_text_5) < 9, 
	(((INT(user_text_5)*total_area)*400*0.0023)/1000), 
	((((8*total_area)*400*0.0023)/1000) + ((((INT(user_text_5)-8)*total_area)*400*0.0023)/1000)) )
WHERE user_text_2 = 'wellington city' AND system_type = 'other' 
AND (user_text_3 LIKE 'commercial*' OR user_text_3 LIKE 'industrial*');

// upper hutt city
UPDATE [Subcatchment] IN SCENARIO $scenario
SET $sub_com = ((0.08*INT(user_text_5)*total_area)/1000)
WHERE user_text_2 = 'upper hutt city' AND system_type = 'other' 
AND user_text_3 = 'industrial_l';

UPDATE [Subcatchment] IN SCENARIO $scenario
SET $sub_com = ((1*INT(user_text_5)*total_area)/1000)
WHERE user_text_2 = 'upper hutt city' AND system_type = 'other' 
AND user_text_3 = 'industrial_m';

UPDATE [Subcatchment] IN SCENARIO $scenario
SET $sub_com = ((1*INT(user_text_5)*total_area)/1000)
WHERE user_text_2 = 'upper hutt city' AND system_type = 'other' 
AND user_text_3 = 'industrial_h';

UPDATE [Subcatchment] IN SCENARIO $scenario
SET $sub_com = ((0.25*INT(user_text_5)*total_area)/1000)
WHERE user_text_2 = 'upper hutt city' AND system_type = 'other' 
AND user_text_3 LIKE 'commercial*';

// lower hutt city
UPDATE [Subcatchment] IN SCENARIO $scenario
SET $sub_com = ((0.52*INT(user_text_5)*total_area)/1000)
WHERE user_text_2 = 'lower hutt city' AND system_type = 'other'
AND (user_text_3 LIKE 'commercial*' OR user_text_3 LIKE 'industrial*');

// porirua city
UPDATE [Subcatchment] IN SCENARIO $scenario
SET $sub_com = ((0.4*INT(user_text_5)*total_area)/1000)
WHERE user_text_2 = 'porirua city' AND system_type = 'other' AND user_text_3 LIKE '*_h'
AND (user_text_3 LIKE 'commercial*' OR user_text_3 LIKE 'industrial*');

UPDATE [Subcatchment] IN SCENARIO $scenario
SET $sub_com = ((0.25*INT(user_text_5)*total_area)/1000)
WHERE user_text_2 = 'porirua city' AND system_type = 'other' AND user_text_3 LIKE '*_m'
AND (user_text_3 LIKE 'commercial*' OR user_text_3 LIKE 'industrial*');

UPDATE [Subcatchment] IN SCENARIO $scenario
SET $sub_com = ((0.15*INT(user_text_5)*total_area)/1000)
WHERE user_text_2 = 'porirua city' AND system_type = 'other' AND user_text_3 LIKE '*_l'
AND (user_text_3 LIKE 'commercial*' OR user_text_3 LIKE 'industrial*');

// south wairarapa district 
UPDATE [Subcatchment] IN SCENARIO $scenario
SET $sub_com = ((0.15*INT(user_text_5)*total_area)/1000)
WHERE user_text_2 = 'south wairarapa district' AND system_type = 'other'
AND (user_text_3 LIKE 'commercial*' OR user_text_3 LIKE 'industrial*');

// work out highest non residential flow
UPDATE [Subcatchment] IN SCENARIO $scenario
SET $sub_flow = IIF(additional_foul_flow > $sub_com, additional_foul_flow, $sub_com);

UPDATE [Node] IN SCENARIO $scenario SET $COM = SUM(subcatchments.$sub_flow); 
UPDATE IN SCENARIO $scenario SET $pipeCOM = NVL(us_node.$COM, 0);
UPDATE IN SCENARIO $scenario SET $usCOM = NVL(SUM(all_us_links.$pipeCOM), 0);
UPDATE IN SCENARIO $scenario SET $comCALC = ($pipeCOM + $usCOM);

//SELECT us_node_id, $comCALC DP 5;