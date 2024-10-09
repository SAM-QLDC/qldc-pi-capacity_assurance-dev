/* 4a Polygon
sql to update polygon id to all subatchments.
Note a manual check will need to be done to confirm
subcatchments where user_text_1 is null */

/* Object Type: Subcatchment */

/* Spatial Search
   Search Type: Inside
   Layer Type" Network layer
   Layer: Polygon */

// polygon_id to ust1
UPDATE IN Base SCENARIO SET 
user_text_1 = spatial.polygon_id, 
user_text_1_flag = '#G';

// inflow/infiltration to ust4
UPDATE IN Base SCENARIO SET 
user_text_4 = spatial.notes, 
user_text_4_flag = '#G';

// infill percentage to ust5
//UPDATE IN Base SCENARIO SET 
//user_text_5 = spatial.user_text_5, 
//user_text_5 = 'infill_05',
//user_text_5_flag = '#G';