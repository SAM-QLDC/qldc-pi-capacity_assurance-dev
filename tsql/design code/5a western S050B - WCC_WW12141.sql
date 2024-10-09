// apply changes to pwwf based on how the 
// flows might get split at each diversion

// a is the main line so takes most of the flow

DESELECT ALL;

LET $node_id = 'WCC_WW12141';
LET $asset_id = 'WCC_WWP012171';
LET $split = 0.9;
LIST $split_50a = 'WCC_WWP012166';
LIST $split_50b = 'WCC_WWP026831', 'WCC_WWP031637', 'WCC_WWP026830', 'WCC_WWP019665', 'WCC_WWP031634', 'WCC_WWP031642', 'WCC_WWP012164', 'WCC_WWP012163';

SELECT WHERE MEMBER(asset_id, $split_50a) = 1;
SELECT WHERE MEMBER(asset_id, $split_50b) = 1;

// ideally not be max as we should have unique pipe_ids for each pipe
SELECT MAX(user_number_5) INTO $pwwf WHERE asset_id = $asset_id;

SET user_number_6 = ($pwwf - NVL(user_number_6, 0)) * (1-$split)
WHERE MEMBER(asset_id, $split_50a) = 1;

SET user_number_6 = ($pwwf - NVL(user_number_6, 0)) * ($split) 
WHERE MEMBER(asset_id, $split_50b) = 1;