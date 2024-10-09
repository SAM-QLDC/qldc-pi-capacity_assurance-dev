//LET $scenario = 'DES';

/* IGNORE FOR NOW

LIST $systems_addr = 'Foul', 'foul', 'Combined', 'combined', 'Sanitary', 'sanitary';

UPDATE [subcatchment] IN SCENARIO $scenario SET
population = IIF(MEMBER(system_type, $systems_addr) = 1, 
INT(user_text_6) * FIXED((user_text_7),1), 0 ),
population_flag = IIF(MEMBER(system_type, $systems_addr) = 1, '#I', 'AS' );

*/