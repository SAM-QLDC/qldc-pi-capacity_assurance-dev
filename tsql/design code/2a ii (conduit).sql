LIST $ii_list = 'ii_high', 'ii_low', 'ii_unkn';

UPDATE [All Nodes] IN SCENARIO 'DES' SET
$gwi = IIF(MEMBER(spatial.notes, $ii_list)=1, spatial.notes, '');

UPDATE [All Links] IN SCENARIO 'DES' SET 
user_text_1 = us_node.$gwi, user_text_1_flag = '#G'; 

UPDATE [All Links] IN SCENARIO 'DES' SET
user_text_1 = ds_node.$gwi, user_text_1_flag = '#G' WHERE user_text_1 is null; 