LET $scenario = 'DES';

/* BASIC PARAMETERS DEFAULTED */

UPDATE [subcatchment] IN SCENARIO $scenario SET
drains_to_flag = '#D' WHERE drains_to <> 'Node';

UPDATE [subcatchment] IN SCENARIO $scenario SET
wastewater_profile_flag = '#D';

UPDATE [subcatchment] IN SCENARIO $scenario SET
base_flow_flag = '#D' 
WHERE base_flow is null OR base_flow = 0;

UPDATE [subcatchment] IN SCENARIO $scenario SET
base_flow_flag = '#I' 
WHERE base_flow > 0;

UPDATE [subcatchment] IN SCENARIO $scenario SET
additional_foul_flow_flag = '#D' 
WHERE additional_foul_flow is null OR additional_foul_flow = 0;

UPDATE [subcatchment] IN SCENARIO $scenario SET
additional_foul_flow_flag = '#I' 
WHERE additional_foul_flow > 0;

UPDATE [subcatchment] IN SCENARIO $scenario SET
trade_flow_flag = '' 
WHERE trade_flow is null OR trade_flow = 0;

UPDATE [subcatchment] IN SCENARIO $scenario SET
trade_flow_flag = '#I' 
WHERE trade_flow > 0;

UPDATE [subcatchment] IN SCENARIO $scenario SET
rainfall_profile_flag = '#D', evaporation_profile_flag = '#D';

UPDATE [subcatchment] IN SCENARIO $scenario SET
land_use_id = user_text_3, land_use_id_flag = '#A';

UPDATE [subcatchment] IN SCENARIO $scenario SET
ground_id = '';

UPDATE [subcatchment] IN SCENARIO $scenario SET
total_area = IIF(INT(user_text_6) = 0, 0.1, INT(user_text_6) * 0.1), 
total_area_flag = 'AS', 
contributing_area_flag = '#D'
WHERE user_text_3 = 'lifestyle';

UPDATE [subcatchment] IN SCENARIO $scenario SET
soil_class_type = 'WRAP', 
soil_class_type_flag = '#I',
soil_class_flag = '#I',
area_measurement_type = 'Percent',
area_measurement_type_flag = '#A',
area_percent_1_flag = '#D',
area_percent_2_flag = '#D',
area_percent_3_flag = '#D',
area_percent_4_flag = '#D',
area_percent_5_flag = '#D',
area_percent_6_flag = '#D',
area_percent_7_flag = '#D',
area_percent_8_flag = '#D',
area_percent_9_flag = '#D',
area_percent_10_flag = '#D',
area_percent_11_flag = '#D',
area_percent_12_flag = '#D';