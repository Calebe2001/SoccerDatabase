-- Converte campos vazios ('') em NULL para evitar erro de tipagem no pgloader

-- Player_Attributes
UPDATE Player_Attributes SET overall_rating = NULL WHERE overall_rating = '';
UPDATE Player_Attributes SET potential = NULL WHERE potential = '';
UPDATE Player_Attributes SET crossing = NULL WHERE crossing = '';
UPDATE Player_Attributes SET finishing = NULL WHERE finishing = '';
UPDATE Player_Attributes SET heading_accuracy = NULL WHERE heading_accuracy = '';
UPDATE Player_Attributes SET short_passing = NULL WHERE short_passing = '';
UPDATE Player_Attributes SET volleys = NULL WHERE volleys = '';
UPDATE Player_Attributes SET dribbling = NULL WHERE dribbling = '';
UPDATE Player_Attributes SET curve = NULL WHERE curve = '';
UPDATE Player_Attributes SET free_kick_accuracy = NULL WHERE free_kick_accuracy = '';
UPDATE Player_Attributes SET long_passing = NULL WHERE long_passing = '';
UPDATE Player_Attributes SET ball_control = NULL WHERE ball_control = '';
UPDATE Player_Attributes SET acceleration = NULL WHERE acceleration = '';
UPDATE Player_Attributes SET sprint_speed = NULL WHERE sprint_speed = '';
UPDATE Player_Attributes SET agility = NULL WHERE agility = '';
UPDATE Player_Attributes SET reactions = NULL WHERE reactions = '';
UPDATE Player_Attributes SET balance = NULL WHERE balance = '';
UPDATE Player_Attributes SET shot_power = NULL WHERE shot_power = '';
UPDATE Player_Attributes SET jumping = NULL WHERE jumping = '';
UPDATE Player_Attributes SET stamina = NULL WHERE stamina = '';
UPDATE Player_Attributes SET strength = NULL WHERE strength = '';
UPDATE Player_Attributes SET long_shots = NULL WHERE long_shots = '';
UPDATE Player_Attributes SET aggression = NULL WHERE aggression = '';
UPDATE Player_Attributes SET interceptions = NULL WHERE interceptions = '';
UPDATE Player_Attributes SET positioning = NULL WHERE positioning = '';
UPDATE Player_Attributes SET vision = NULL WHERE vision = '';
UPDATE Player_Attributes SET penalties = NULL WHERE penalties = '';
UPDATE Player_Attributes SET marking = NULL WHERE marking = '';
UPDATE Player_Attributes SET standing_tackle = NULL WHERE standing_tackle = '';
UPDATE Player_Attributes SET sliding_tackle = NULL WHERE sliding_tackle = '';
UPDATE Player_Attributes SET gk_diving = NULL WHERE gk_diving = '';
UPDATE Player_Attributes SET gk_handling = NULL WHERE gk_handling = '';
UPDATE Player_Attributes SET gk_kicking = NULL WHERE gk_kicking = '';
UPDATE Player_Attributes SET gk_positioning = NULL WHERE gk_positioning = '';
UPDATE Player_Attributes SET gk_reflexes = NULL WHERE gk_reflexes = '';

-- Team_Attributes
UPDATE Team_Attributes SET buildUpPlaySpeed = NULL WHERE buildUpPlaySpeed = '';
UPDATE Team_Attributes SET buildUpPlayDribbling = NULL WHERE buildUpPlayDribbling = '';
UPDATE Team_Attributes SET buildUpPlayPassing = NULL WHERE buildUpPlayPassing = '';
UPDATE Team_Attributes SET chanceCreationPassing = NULL WHERE chanceCreationPassing = '';
UPDATE Team_Attributes SET chanceCreationCrossing = NULL WHERE chanceCreationCrossing = '';
UPDATE Team_Attributes SET chanceCreationShooting = NULL WHERE chanceCreationShooting = '';
UPDATE Team_Attributes SET defencePressure = NULL WHERE defencePressure = '';
UPDATE Team_Attributes SET defenceAggression = NULL WHERE defenceAggression = '';
UPDATE Team_Attributes SET defenceTeamWidth = NULL WHERE defenceTeamWidth = '';

-- Team
UPDATE Team SET id = NULL WHERE id = '';
UPDATE Team SET team_api_id = NULL WHERE team_api_id = '';
UPDATE Team SET team_fifa_api_id = NULL WHERE team_fifa_api_id = ''; 