// design flows

//LET $scenario = 'DES';
 
UPDATE IN SCENARIO $scenario 
SET $SPARE = (1.00*capacity*1000)-(user_number_5 - NVL(user_number_6,0));

UPDATE IN SCENARIO $scenario 
SET user_number_7 = $SPARE