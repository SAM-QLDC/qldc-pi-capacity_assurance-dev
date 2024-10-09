//LET $scenario = 'DES';

UPDATE IN SCENARIO $scenario SET 
user_number_1 = NVL(SUM(NVL(us_links.user_number_1, 0)),""),
user_number_2 = NVL(SUM(NVL(us_links.user_number_2, 0)),""),
user_number_3 = NVL(SUM(NVL(us_links.user_number_3, 0)),""),
user_number_4 = NVL(SUM(NVL(us_links.user_number_4, 0)),""),
user_number_5 = NVL(SUM(NVL(us_links.user_number_5, 0)),""),
user_number_9 = NVL(SUM(NVL(us_links.user_number_9, 0)),""),
user_number_10 = NVL(SUM(NVL(us_links.user_number_10, 0)),"")
;

UPDATE IN SCENARIO $scenario SET 
user_number_1 = NVL(AVG(NVL(ds_links.user_number_1, 0)),""),
user_number_2 = NVL(AVG(NVL(ds_links.user_number_2, 0)),""), 
user_number_3 = NVL(AVG(NVL(ds_links.user_number_3, 0)),""), 
user_number_4 = NVL(AVG(NVL(ds_links.user_number_4, 0)),""), 
user_number_5 = NVL(AVG(NVL(ds_links.user_number_5, 0)),""), 
user_number_9 = NVL(AVG(NVL(ds_links.user_number_9, 0)),""), 
user_number_10 = NVL(AVG(NVL(ds_links.user_number_10, 0)),"") 
WHERE COUNT(us_links.*) = 0;