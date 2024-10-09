// conduit

LIST $mat = 'AC', 'BR', 'CI', 'CIP-SP', 'CLMS', 'CONC', 'CU', 'DI', 'DICL', 'EW', 'GALS', 'GEW', 'GI', 'GS', 'HDPE', 'HPPE', 'MDPE', 'MPVC', 'NPRN', 'PE100', 'P80B', 'PE', 'PITF', 'PLST', 'PVC', 'PVCB', 'RC', 'RCON', 'RCRRJ', 'RIBLOC', 'ST', 'STCL', 'STEL', 'STON', 'STS', 'UGEW', 'UPVC';

LIST $life = 70, 100, 70, 60, 85, 110, 80, 70, 70, 100, 70, 55, 70, 70, 80, 80, 80, 80, 100, 80, 80, 80, 80, 60, 80, 80, 80, 80, 80, 80, 60, 60, 60, 100, 60, 55, 80;

LIST $cg = 6, 5, 4.9, 4.8, 4.7, 4.6, 4.5, 4.4, 4.3, 4.2, 4.1, 4, 3.9, 3.8, 3.7, 3.6, 3.5, 3.4, 3.3, 3.2, 3.1, 3, 2.9, 2.8, 2.7, 2.6, 2.5, 2.4, 2.3, 2.2, 2.1, 2, 1.9, 1.8, 1.7, 1.6, 1.5, 1.4, 1.3, 1.2, 1.1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1;

LIST $pcent = -10000, 0, 0.02, 0.04, 0.06, 0.08, 0.1, 0.12, 0.14, 0.16, 0.18, 0.2, 0.22, 0.24, 0.26, 0.28, 0.3, 0.32, 0.34, 0.36, 0.38, 0.4, 0.42, 0.44, 0.46, 0.48, 0.5, 0.52, 0.54, 0.56, 0.58, 0.6, 0.62, 0.64, 0.66, 0.68, 0.7, 0.72, 0.74, 0.76, 0.78, 0.8, 0.82, 0.84, 0.86, 0.88, 0.9, 0.92, 0.94, 0.96, 0.98, 10000;

SET $gwi = user_text_1;				// roughly drawn areas of II
SET $infonet_material = user_text_2;			// latest material type
SET $infonet_year_laid = INT(user_text_3);		// install year
SET $infonet_year_survey = INT(user_text_4);	                // cctv survey date
SET $infonet_grade = user_text_5;			// infonet structural grade
SET $icm_rdl = user_text_6;				// remaining design life

UPDATE [conduit] IN Base SCENARIO SET
$lifetime = AREF(INDEX(conduit_material, $mat), $life);

UPDATE [conduit] IN Base SCENARIO SET
$install_year_pipe = $infonet_year_laid, 
$year_now_pipe = YEARPART(NOW()), 
$age_pipe = $year_now_pipe - $install_year_pipe, 
$rd_life = ($lifetime - $age_pipe),
$percent_rul = $rd_life / $lifetime,
$percent_cg = LOOKUP(RINDEX($percent_rul, $pcent), $cg),
$rehab_year = $install_year_pipe + $lifetime, 
$rehab_date = IIF($rehab_year < $year_now_pipe, $year_now_pipe, $rehab_year);

UPDATE [conduit] IN Base SCENARIO SET 
user_text_5 = $percent_cg, user_text_5_flag = '#V',
user_text_4 = '2023', user_text_4_flag = '#V'
WHERE (user_text_5_flag = '#V' OR user_text_5 is null);

UPDATE [conduit] IN Base SCENARIO SET 
user_text_6 = $rd_life, user_text_6_flag = '#V';