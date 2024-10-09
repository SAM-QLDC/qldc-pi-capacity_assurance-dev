// calculation of PWWF

//LET $scenario = 'DES';

UPDATE IN SCENARIO $scenario SET $ADWF = (0.0023 * $popNO);
UPDATE IN SCENARIO $scenario SET $PF = 7.23 * (($areaHA) ^ -0.2);
UPDATE IN SCENARIO $scenario SET $DI = 0.55 * ($usLOW + $usUNKN + $usHIGH);
UPDATE IN SCENARIO $scenario SET $II = ($usLOW * 0.06) + ($usUNKN * 0.25) + ($usHIGH * 0.43);
UPDATE IN SCENARIO $scenario SET $PWWF = ($ADWF * $PF) + $comCALC + $DI + $II;

UPDATE IN SCENARIO $scenario SET 
    user_number_1 = $ADWF,
    user_number_2 = $PF,
    user_number_3 = $DI,
    user_number_4 = $II,
    user_number_5 = $PWWF
WHERE link_type = 'Cond';

UPDATE IN SCENARIO $scenario SET 
    user_number_1 = $ADWF,
    user_number_2 = $PF,
    user_number_3 = $DI,
    user_number_4 = $II,
    user_number_5 = $PWWF
WHERE RIGHT(link_type, 3) = 'PMP'
AND link_suffix = 1;