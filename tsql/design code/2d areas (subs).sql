UPDATE [subcatchment] IN Base SCENARIO SET
total_area_flag = '#D', 
contributing_area_flag = '#D'
WHERE system_type = 'combined' 
OR system_type = 'Combined';

UPDATE [subcatchment] IN Base SCENARIO SET
total_area_flag = '#D', 
contributing_area = 0,
contributing_area_flag = 'AS'
WHERE system_type = 'Other' 
OR system_type = 'other';