LET $scenario = 'DES';

/* LAND USE
   delete all land uses */
DELETE ALL FROM [land use] IN SCENARIO $scenario;

/* LAND USE
   insert new ones */

INSERT INTO [land use]
(land_use_id, wastewater_profile, connectivity, pollution_index, p_area_1, runoff_index_1) 
IN SCENARIO $scenario VALUES ('residential', 1, 100, 1, 100, 1);

INSERT INTO [land use]
(land_use_id, wastewater_profile, connectivity, pollution_index, p_area_1, runoff_index_1) 
IN SCENARIO $scenario VALUES ('lifestyle', 1, 100, 1, 100, 1);

INSERT INTO [land use]
(land_use_id, wastewater_profile, connectivity, pollution_index, p_area_1, runoff_index_1) 
IN SCENARIO $scenario VALUES ('BROWNFIELD', 1, 0, 1, 0, 1);
 
INSERT INTO [land use]
(land_use_id, wastewater_profile, connectivity, pollution_index, p_area_1, runoff_index_1) 
IN SCENARIO $scenario VALUES ('BROWNFIELD_D', 1, 0, 1, 0, 1);

INSERT INTO [land use]
(land_use_id, wastewater_profile, connectivity, pollution_index, p_area_1, runoff_index_1) 
IN SCENARIO $scenario VALUES ('BROWNFIELD_P', 1, 0, 1, 0, 1);   
   
INSERT INTO [land use]
(land_use_id, wastewater_profile, connectivity, pollution_index, p_area_1, runoff_index_1) 
IN SCENARIO $scenario VALUES ('COMMERCIAL_H', 1, 90, 2, 0, 1);

INSERT INTO [land use]
(land_use_id, wastewater_profile, connectivity, pollution_index, p_area_1, runoff_index_1) 
IN SCENARIO $scenario VALUES ('COMMERCIAL_L', 1, 90, 2, 0, 1);

INSERT INTO [land use]
(land_use_id, wastewater_profile, connectivity, pollution_index, p_area_1, runoff_index_1) 
IN SCENARIO $scenario VALUES ('COMMERCIAL_M', 1, 90, 2, 0, 1);   

INSERT INTO [land use]
(land_use_id, wastewater_profile, connectivity, pollution_index, p_area_1, runoff_index_1) 
IN SCENARIO $scenario VALUES ('INDUSTRIAL_H', 1, 90, 3, 0, 1);

INSERT INTO [land use]
(land_use_id, wastewater_profile, connectivity, pollution_index, p_area_1, runoff_index_1) 
IN SCENARIO $scenario VALUES ('INDUSTRIAL_M', 1, 90, 3, 0, 1);

INSERT INTO [land use]
(land_use_id, wastewater_profile, connectivity, pollution_index, p_area_1, runoff_index_1) 
IN SCENARIO $scenario VALUES ('INDUSTRIAL_L', 1, 90, 3, 0, 1);

INSERT INTO [land use]
(land_use_id, wastewater_profile, connectivity, pollution_index, p_area_1, runoff_index_1) 
IN SCENARIO $scenario VALUES ('GREENFIELD', 1, 100, 1, 100, 1);

INSERT INTO [land use]
(land_use_id, wastewater_profile, connectivity, pollution_index, p_area_1, runoff_index_1) 
IN SCENARIO $scenario VALUES ('GREENFIELD_D', 1, 0, 1, 0, 1);

INSERT INTO [land use]
(land_use_id, wastewater_profile, connectivity, pollution_index, p_area_1, runoff_index_1) 
IN SCENARIO $scenario VALUES ('GREENFIELD_P', 1, 0, 1, 0, 1);

INSERT INTO [land use]
(land_use_id, wastewater_profile, connectivity, pollution_index, p_area_1, runoff_index_1) 
IN SCENARIO $scenario VALUES ('GREENFIELD_R', 1, 0, 1, 0, 1);

INSERT INTO [land use]
(land_use_id, wastewater_profile, connectivity, pollution_index, p_area_1, runoff_index_1) 
IN SCENARIO $scenario VALUES ('REGENERATION', 1, 0, 1, 0, 1);

INSERT INTO [land use]
(land_use_id, wastewater_profile, connectivity, pollution_index, p_area_1, runoff_index_1) 
IN SCENARIO $scenario VALUES ('AGED CARE', 1, 0, 1, 0, 1);

INSERT INTO [land use]
(land_use_id, wastewater_profile, connectivity, pollution_index, p_area_1, runoff_index_1) 
IN SCENARIO $scenario VALUES ('DORMS', 1, 0, 1, 0, 1);

INSERT INTO [land use]
(land_use_id, wastewater_profile, connectivity, pollution_index, p_area_1, runoff_index_1) 
IN SCENARIO $scenario VALUES ('ACCOMDATION', 1, 0, 1, 0, 1);

INSERT INTO [land use]
(land_use_id, wastewater_profile, connectivity, pollution_index, p_area_1, runoff_index_1) 
IN SCENARIO $scenario VALUES ('LANDFILL', 1, 100, 4, 100, 1);

/* RUNOFF SURFACES 
   delete all
*/

DELETE ALL FROM [runoff surface] IN SCENARIO $scenario;

/* RUNOFF SURFACES 
   insert new lines
*/

INSERT INTO [runoff surface]
(runoff_index, surface_description, runoff_routing_type, runoff_routing_value, runoff_volume_type, surface_type, ground_slope, initial_loss_type, initial_loss_value, routing_model, runoff_coefficient) 
IN SCENARIO $scenario 
VALUES (1, '', 'Rel', 1, 'Fixed', 'Impervious', 0, 'Slope', 0.000071, 'Wallingfrd', 1);

/* GROUND INFILTRATION 
   delete all
*/

DELETE ALL FROM [ground infiltration] IN SCENARIO $scenario;
