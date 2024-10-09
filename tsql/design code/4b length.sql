//LET $scenario = 'DES';   //not need when sql run in group

// development area pipe flows
UPDATE [Subcatchment] IN SCENARIO $scenario SET 
$usn1 = IIF(system_type = 'sanitary' AND land_use_id <> 'BROWNFIELD', total_area * 0.8, 0);
UPDATE [Node] IN SCENARIO $scenario SET 
$conduit_usn1 = NVL(SUM(subcatchments.$usn1), 0); 

// area above small PSs without network
UPDATE [Subcatchment] IN SCENARIO $scenario SET 
$usn2 = total_area * 0.8;
UPDATE [Node] IN SCENARIO $scenario SET 
$conduit_usn2 = NVL(SUM(subcatchments.$usn2), 0); 

UPDATE [All Links] IN SCENARIO $scenario SET
$conduit_length =
	IIF(RIGHT(link_type, 3) <> 'PMP', us_node.$conduit_usn2,
	IIF(link_type = 'Cond', us_node.$conduit_usn1,
	0));	
//SELECT us_node_id, link_type, $conduit_length DP 5; //check

UPDATE IN SCENARIO $scenario SET $pipeLOW = IIF(user_text_1 = 'ii_low', $conduit_length, 0);
UPDATE IN SCENARIO $scenario SET $pipeHIGH = IIF(user_text_1 = 'ii_high', $conduit_length, 0);
UPDATE IN SCENARIO $scenario SET $pipeUNKN = IIF(user_text_1 = 'ii_unkn', $conduit_length, 0);
//SELECT us_node_id, $pipeLOW DP 5, $pipeUNKN DP 5, $pipeHIGH DP 5; //check

// add conduit and pump data together
UPDATE IN SCENARIO $scenario SET $usLOW = $pipeLOW + NVL(SUM(all_us_links.$pipeLOW), 0);
UPDATE IN SCENARIO $scenario SET $usHIGH = $pipeHIGH + NVL(SUM(all_us_links.$pipeHIGH), 0);
UPDATE IN SCENARIO $scenario SET $usUNKN = $pipeUNKN + NVL(SUM(all_us_links.$pipeUNKN), 0);

//SELECT us_node_id, $usLOW DP 5, $usUNKN DP 5, $usHIGH DP 5;