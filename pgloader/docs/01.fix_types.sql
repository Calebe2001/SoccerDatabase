-- Corrige tipos de campos numéricos para evitar erro no pgloader

-- Player_Attributes: cria tabela temporária com tipos corretos
CREATE TABLE Player_Attributes_tmp AS
SELECT 
    id,
    player_fifa_api_id,
    player_api_id,
    date,
    CAST(overall_rating AS INTEGER) AS overall_rating,
    CAST(potential AS INTEGER) AS potential,
    preferred_foot,
    attacking_work_rate,
    defensive_work_rate,
    CAST(crossing AS INTEGER) AS crossing,
    CAST(finishing AS INTEGER) AS finishing,
    CAST(heading_accuracy AS INTEGER) AS heading_accuracy,
    CAST(short_passing AS INTEGER) AS short_passing,
    CAST(volleys AS INTEGER) AS volleys,
    CAST(dribbling AS INTEGER) AS dribbling,
    CAST(curve AS INTEGER) AS curve,
    CAST(free_kick_accuracy AS INTEGER) AS free_kick_accuracy,
    CAST(long_passing AS INTEGER) AS long_passing,
    CAST(ball_control AS INTEGER) AS ball_control,
    CAST(acceleration AS INTEGER) AS acceleration,
    CAST(sprint_speed AS INTEGER) AS sprint_speed,
    CAST(agility AS INTEGER) AS agility,
    CAST(reactions AS INTEGER) AS reactions,
    CAST(balance AS INTEGER) AS balance,
    CAST(shot_power AS INTEGER) AS shot_power,
    CAST(jumping AS INTEGER) AS jumping,
    CAST(stamina AS INTEGER) AS stamina,
    CAST(strength AS INTEGER) AS strength,
    CAST(long_shots AS INTEGER) AS long_shots,
    CAST(aggression AS INTEGER) AS aggression,
    CAST(interceptions AS INTEGER) AS interceptions,
    CAST(positioning AS INTEGER) AS positioning,
    CAST(vision AS INTEGER) AS vision,
    CAST(penalties AS INTEGER) AS penalties,
    CAST(marking AS INTEGER) AS marking,
    CAST(standing_tackle AS INTEGER) AS standing_tackle,
    CAST(sliding_tackle AS INTEGER) AS sliding_tackle,
    CAST(gk_diving AS INTEGER) AS gk_diving,
    CAST(gk_handling AS INTEGER) AS gk_handling,
    CAST(gk_kicking AS INTEGER) AS gk_kicking,
    CAST(gk_positioning AS INTEGER) AS gk_positioning,
    CAST(gk_reflexes AS INTEGER) AS gk_reflexes
FROM Player_Attributes;

DROP TABLE Player_Attributes;
ALTER TABLE Player_Attributes_tmp RENAME TO Player_Attributes;

-- Team_Attributes: cria tabela temporária com tipos corretos
CREATE TABLE Team_Attributes_tmp AS
SELECT 
    id,
    team_fifa_api_id,
    team_api_id,
    date,
    CAST(buildUpPlaySpeed AS INTEGER) AS buildUpPlaySpeed,
    buildUpPlaySpeedClass,
    CAST(buildUpPlayDribbling AS INTEGER) AS buildUpPlayDribbling,
    buildUpPlayDribblingClass,
    CAST(buildUpPlayPassing AS INTEGER) AS buildUpPlayPassing,
    buildUpPlayPassingClass,
    buildUpPlayPositioningClass,
    CAST(chanceCreationPassing AS INTEGER) AS chanceCreationPassing,
    chanceCreationPassingClass,
    CAST(chanceCreationCrossing AS INTEGER) AS chanceCreationCrossing,
    chanceCreationCrossingClass,
    CAST(chanceCreationShooting AS INTEGER) AS chanceCreationShooting,
    chanceCreationShootingClass,
    chanceCreationPositioningClass,
    CAST(defencePressure AS INTEGER) AS defencePressure,
    defencePressureClass,
    CAST(defenceAggression AS INTEGER) AS defenceAggression,
    defenceAggressionClass,
    CAST(defenceTeamWidth AS INTEGER) AS defenceTeamWidth,
    defenceTeamWidthClass,
    defenceDefenderLineClass
FROM Team_Attributes;

DROP TABLE Team_Attributes;
ALTER TABLE Team_Attributes_tmp RENAME TO Team_Attributes;

-- Team: corrige tipos dos ids
CREATE TABLE Team_tmp AS
SELECT 
    CAST(id AS INTEGER) AS id,
    CAST(team_api_id AS INTEGER) AS team_api_id,
    CAST(team_fifa_api_id AS INTEGER) AS team_fifa_api_id,
    team_long_name,
    team_short_name
FROM Team;

DROP TABLE Team;
ALTER TABLE Team_tmp RENAME TO Team; 