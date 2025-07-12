BEGIN;

-- =====================================================
-- DDL COMPLETO - BASE DE DADOS DE FUTEBOL NORMALIZADA
-- =====================================================

-- Schema: campeonato
CREATE SCHEMA IF NOT EXISTS campeonato;

-- =====================================================
-- 1. COUNTRY - Países
-- =====================================================
CREATE TABLE IF NOT EXISTS campeonato.country (
    id BIGINT NOT NULL DEFAULT nextval('campeonato.country_id_seq'::regclass),
    name TEXT COLLATE pg_catalog."default",
    CONSTRAINT country_pkey PRIMARY KEY (id)
);

CREATE UNIQUE INDEX IF NOT EXISTS country_name_unique 
    ON campeonato.country USING btree (name COLLATE pg_catalog."default" ASC NULLS LAST);

-- =====================================================
-- 2. LEAGUE - Ligas
-- =====================================================
CREATE TABLE IF NOT EXISTS campeonato.league (
    id BIGINT NOT NULL DEFAULT nextval('campeonato.league_id_seq'::regclass),
    country_id BIGINT,
    name TEXT COLLATE pg_catalog."default",
    CONSTRAINT league_pkey PRIMARY KEY (id),
    CONSTRAINT league_country_fkey FOREIGN KEY (country_id) REFERENCES campeonato.country(id)
);

CREATE UNIQUE INDEX IF NOT EXISTS league_name_unique 
    ON campeonato.league USING btree (name COLLATE pg_catalog."default" ASC NULLS LAST);

-- =====================================================
-- 3. TEAM - Times
-- =====================================================
CREATE TABLE IF NOT EXISTS campeonato.team (
    id INTEGER NOT NULL,
    team_api_id INTEGER,
    team_fifa_api_id INTEGER,
    team_long_name TEXT COLLATE pg_catalog."default",
    team_short_name TEXT COLLATE pg_catalog."default",
    CONSTRAINT team_pkey PRIMARY KEY (id)
);

-- =====================================================
-- 4. PLAYER - Jogadores
-- =====================================================
CREATE TABLE IF NOT EXISTS campeonato.player (
    id BIGINT NOT NULL DEFAULT nextval('campeonato.player_id_seq'::regclass),
    player_api_id BIGINT,
    player_name TEXT COLLATE pg_catalog."default",
    player_fifa_api_id BIGINT,
    birthday TEXT COLLATE pg_catalog."default",
    height REAL,
    weight BIGINT,
    CONSTRAINT player_pkey PRIMARY KEY (id)
);

CREATE UNIQUE INDEX IF NOT EXISTS player_api_id_unique 
    ON campeonato.player USING btree (player_api_id ASC NULLS LAST);

CREATE UNIQUE INDEX IF NOT EXISTS player_fifa_api_id_unique 
    ON campeonato.player USING btree (player_fifa_api_id ASC NULLS LAST);

-- =====================================================
-- 5. PLAYER_ATTRIBUTES - Atributos dos Jogadores
-- =====================================================
CREATE TABLE IF NOT EXISTS campeonato.player_attributes (
    id INTEGER NOT NULL,
    player_fifa_api_id INTEGER,
    player_api_id INTEGER,
    date TEXT COLLATE pg_catalog."default",
    overall_rating INTEGER,
    potential INTEGER,
    preferred_foot TEXT COLLATE pg_catalog."default",
    attacking_work_rate TEXT COLLATE pg_catalog."default",
    defensive_work_rate TEXT COLLATE pg_catalog."default",
    crossing INTEGER,
    finishing INTEGER,
    heading_accuracy INTEGER,
    short_passing INTEGER,
    volleys INTEGER,
    dribbling INTEGER,
    curve INTEGER,
    free_kick_accuracy INTEGER,
    long_passing INTEGER,
    ball_control INTEGER,
    acceleration INTEGER,
    sprint_speed INTEGER,
    agility INTEGER,
    reactions INTEGER,
    balance INTEGER,
    shot_power INTEGER,
    jumping INTEGER,
    stamina INTEGER,
    strength INTEGER,
    long_shots INTEGER,
    aggression INTEGER,
    interceptions INTEGER,
    positioning INTEGER,
    vision INTEGER,
    penalties INTEGER,
    marking INTEGER,
    standing_tackle INTEGER,
    sliding_tackle INTEGER,
    gk_diving INTEGER,
    gk_handling INTEGER,
    gk_kicking INTEGER,
    gk_positioning INTEGER,
    gk_reflexes INTEGER,
    CONSTRAINT player_attributes_pkey PRIMARY KEY (id)
);

-- =====================================================
-- 6. TEAM_ATTRIBUTES - Atributos dos Times
-- =====================================================
CREATE TABLE IF NOT EXISTS campeonato.team_attributes (
    id INTEGER NOT NULL,
    team_fifa_api_id INTEGER,
    team_api_id INTEGER,
    date TEXT COLLATE pg_catalog."default",
    buildupplayspeed INTEGER,
    buildupplayspeedclass TEXT COLLATE pg_catalog."default",
    buildupplaydribbling INTEGER,
    buildupplaydribblingclass TEXT COLLATE pg_catalog."default",
    buildupplaypassing INTEGER,
    buildupplaypassingclass TEXT COLLATE pg_catalog."default",
    buildupplaypositioningclass TEXT COLLATE pg_catalog."default",
    chancecreationpassing INTEGER,
    chancecreationpassingclass TEXT COLLATE pg_catalog."default",
    chancecreationcrossing INTEGER,
    chancecreationcrossingclass TEXT COLLATE pg_catalog."default",
    chancecreationshooting INTEGER,
    chancecreationshootingclass TEXT COLLATE pg_catalog."default",
    chancecreationpositioningclass TEXT COLLATE pg_catalog."default",
    defencepressure INTEGER,
    defencepressureclass TEXT COLLATE pg_catalog."default",
    defenceaggression INTEGER,
    defenceaggressionclass TEXT COLLATE pg_catalog."default",
    defenceteamwidth INTEGER,
    defenceteamwidthclass TEXT COLLATE pg_catalog."default",
    defencedefenderlineclass TEXT COLLATE pg_catalog."default",
    CONSTRAINT team_attributes_pkey PRIMARY KEY (id)
);

-- =====================================================
-- 7. SEASON - Temporadas
-- =====================================================
CREATE TABLE IF NOT EXISTS campeonato.season (
    id INTEGER NOT NULL DEFAULT nextval('campeonato.season_id_seq'::regclass),
    season_name VARCHAR(20) NOT NULL,
    year_start INTEGER,
    year_end INTEGER,
    CONSTRAINT season_pkey PRIMARY KEY (id)
);

CREATE UNIQUE INDEX IF NOT EXISTS season_name_unique 
    ON campeonato.season USING btree (season_name ASC NULLS LAST);

-- =====================================================
-- 8. VENUE - Estádios/Localidades
-- =====================================================
CREATE TABLE IF NOT EXISTS campeonato.venue (
    id INTEGER NOT NULL DEFAULT nextval('campeonato.venue_id_seq'::regclass),
    venue_name VARCHAR(200) NOT NULL,
    city VARCHAR(100),
    country_id BIGINT,
    CONSTRAINT venue_pkey PRIMARY KEY (id),
    CONSTRAINT venue_country_fkey FOREIGN KEY (country_id) REFERENCES campeonato.country(id)
);

-- =====================================================
-- 9. MATCH - Partidas (Tabela Principal)
-- =====================================================
CREATE TABLE IF NOT EXISTS campeonato.match (
    id BIGINT NOT NULL DEFAULT nextval('campeonato.match_id_seq'::regclass),
    country_id BIGINT,
    league_id BIGINT,
    season TEXT COLLATE pg_catalog."default",
    stage BIGINT,
    date TEXT COLLATE pg_catalog."default",
    match_api_id BIGINT,
    home_team_api_id BIGINT,
    away_team_api_id BIGINT,
    home_team_goal BIGINT,
    away_team_goal BIGINT,
    home_player_x1 BIGINT,
    home_player_x2 BIGINT,
    home_player_x3 BIGINT,
    home_player_x4 BIGINT,
    home_player_x5 BIGINT,
    home_player_x6 BIGINT,
    home_player_x7 BIGINT,
    home_player_x8 BIGINT,
    home_player_x9 BIGINT,
    home_player_x10 BIGINT,
    home_player_x11 BIGINT,
    away_player_x1 BIGINT,
    away_player_x2 BIGINT,
    away_player_x3 BIGINT,
    away_player_x4 BIGINT,
    away_player_x5 BIGINT,
    away_player_x6 BIGINT,
    away_player_x7 BIGINT,
    away_player_x8 BIGINT,
    away_player_x9 BIGINT,
    away_player_x10 BIGINT,
    away_player_x11 BIGINT,
    home_player_y1 BIGINT,
    home_player_y2 BIGINT,
    home_player_y3 BIGINT,
    home_player_y4 BIGINT,
    home_player_y5 BIGINT,
    home_player_y6 BIGINT,
    home_player_y7 BIGINT,
    home_player_y8 BIGINT,
    home_player_y9 BIGINT,
    home_player_y10 BIGINT,
    home_player_y11 BIGINT,
    away_player_y1 BIGINT,
    away_player_y2 BIGINT,
    away_player_y3 BIGINT,
    away_player_y4 BIGINT,
    away_player_y5 BIGINT,
    away_player_y6 BIGINT,
    away_player_y7 BIGINT,
    away_player_y8 BIGINT,
    away_player_y9 BIGINT,
    away_player_y10 BIGINT,
    away_player_y11 BIGINT,
    home_player_1 BIGINT,
    home_player_2 BIGINT,
    home_player_3 BIGINT,
    home_player_4 BIGINT,
    home_player_5 BIGINT,
    home_player_6 BIGINT,
    home_player_7 BIGINT,
    home_player_8 BIGINT,
    home_player_9 BIGINT,
    home_player_10 BIGINT,
    home_player_11 BIGINT,
    away_player_1 BIGINT,
    away_player_2 BIGINT,
    away_player_3 BIGINT,
    away_player_4 BIGINT,
    away_player_5 BIGINT,
    away_player_6 BIGINT,
    away_player_7 BIGINT,
    away_player_8 BIGINT,
    away_player_9 BIGINT,
    away_player_10 BIGINT,
    away_player_11 BIGINT,
    -- Eventos em XML
    goal TEXT COLLATE pg_catalog."default",
    shoton TEXT COLLATE pg_catalog."default",
    shotoff TEXT COLLATE pg_catalog."default",
    foulcommit TEXT COLLATE pg_catalog."default",
    card TEXT COLLATE pg_catalog."default",
    cross TEXT COLLATE pg_catalog."default",
    corner TEXT COLLATE pg_catalog."default",
    possession TEXT COLLATE pg_catalog."default",
    -- Odds de apostas
    b365h NUMERIC,
    b365d NUMERIC,
    b365a NUMERIC,
    bwh NUMERIC,
    bwd NUMERIC,
    bwa NUMERIC,
    iwh NUMERIC,
    iwd NUMERIC,
    iwa NUMERIC,
    lbh NUMERIC,
    lbd NUMERIC,
    lba NUMERIC,
    psh NUMERIC,
    psd NUMERIC,
    psa NUMERIC,
    whh NUMERIC,
    whd NUMERIC,
    wha NUMERIC,
    sjh NUMERIC,
    sjd NUMERIC,
    sja NUMERIC,
    vch NUMERIC,
    vcd NUMERIC,
    vca NUMERIC,
    gbh NUMERIC,
    gbd NUMERIC,
    gba NUMERIC,
    bsh NUMERIC,
    bsd NUMERIC,
    bsa NUMERIC,
    CONSTRAINT match_pkey PRIMARY KEY (id),
    CONSTRAINT match_country_fkey FOREIGN KEY (country_id) REFERENCES campeonato.country(id),
    CONSTRAINT match_league_fkey FOREIGN KEY (league_id) REFERENCES campeonato.league(id)
);

-- =====================================================
-- 10. MATCH_PLAYERS - Jogadores por Partida (1NF)
-- =====================================================
CREATE TABLE IF NOT EXISTS campeonato.match_players (
    id INTEGER NOT NULL DEFAULT nextval('campeonato.match_players_id_seq'::regclass),
    match_id BIGINT,
    team_id INTEGER,
    player_id BIGINT,
    position_x INTEGER,
    position_y INTEGER,
    player_number INTEGER,
    is_home BOOLEAN NOT NULL,
    CONSTRAINT match_players_pkey PRIMARY KEY (id),
    CONSTRAINT match_players_match_fkey FOREIGN KEY (match_id) REFERENCES campeonato.match(id),
    CONSTRAINT match_players_team_fkey FOREIGN KEY (team_id) REFERENCES campeonato.team(id),
    CONSTRAINT match_players_player_fkey FOREIGN KEY (player_id) REFERENCES campeonato.player(id),
    CONSTRAINT match_players_unique UNIQUE (match_id, player_id)
);

-- =====================================================
-- 11. MATCH_EVENTS - Eventos da Partida (1NF)
-- =====================================================
CREATE TABLE IF NOT EXISTS campeonato.match_events (
    id INTEGER NOT NULL DEFAULT nextval('campeonato.match_events_id_seq'::regclass),
    match_id BIGINT,
    event_type VARCHAR(50) NOT NULL,
    minute INTEGER,
    description TEXT COLLATE pg_catalog."default",
    player_id BIGINT,
    team_id INTEGER,
    CONSTRAINT match_events_pkey PRIMARY KEY (id),
    CONSTRAINT match_events_match_fkey FOREIGN KEY (match_id) REFERENCES campeonato.match(id),
    CONSTRAINT match_events_player_fkey FOREIGN KEY (player_id) REFERENCES campeonato.player(id),
    CONSTRAINT match_events_team_fkey FOREIGN KEY (team_id) REFERENCES campeonato.team(id)
);

-- =====================================================
-- 12. MATCH_ODDS - Odds de Apostas (1NF)
-- =====================================================
CREATE TABLE IF NOT EXISTS campeonato.match_odds (
    id INTEGER NOT NULL DEFAULT nextval('campeonato.match_odds_id_seq'::regclass),
    match_id BIGINT,
    bookmaker VARCHAR(10) NOT NULL,
    home_odds NUMERIC(5,2),
    draw_odds NUMERIC(5,2),
    away_odds NUMERIC(5,2),
    CONSTRAINT match_odds_pkey PRIMARY KEY (id),
    CONSTRAINT match_odds_match_fkey FOREIGN KEY (match_id) REFERENCES campeonato.match(id),
    CONSTRAINT match_odds_unique UNIQUE (match_id, bookmaker)
);

-- =====================================================
-- ÍNDICES ADICIONAIS PARA PERFORMANCE
-- =====================================================

-- Índices para foreign keys
CREATE INDEX IF NOT EXISTS idx_league_country_id ON campeonato.league(country_id);
CREATE INDEX IF NOT EXISTS idx_match_country_id ON campeonato.match(country_id);
CREATE INDEX IF NOT EXISTS idx_match_league_id ON campeonato.match(league_id);
CREATE INDEX IF NOT EXISTS idx_match_home_team ON campeonato.match(home_team_api_id);
CREATE INDEX IF NOT EXISTS idx_match_away_team ON campeonato.match(away_team_api_id);
CREATE INDEX IF NOT EXISTS idx_match_players_match_id ON campeonato.match_players(match_id);
CREATE INDEX IF NOT EXISTS idx_match_players_team_id ON campeonato.match_players(team_id);
CREATE INDEX IF NOT EXISTS idx_match_players_player_id ON campeonato.match_players(player_id);
CREATE INDEX IF NOT EXISTS idx_match_events_match_id ON campeonato.match_events(match_id);
CREATE INDEX IF NOT EXISTS idx_match_events_player_id ON campeonato.match_events(player_id);
CREATE INDEX IF NOT EXISTS idx_match_events_team_id ON campeonato.match_events(team_id);
CREATE INDEX IF NOT EXISTS idx_match_odds_match_id ON campeonato.match_odds(match_id);
CREATE INDEX IF NOT EXISTS idx_venue_country_id ON campeonato.venue(country_id);

-- Índices para consultas frequentes
CREATE INDEX IF NOT EXISTS idx_match_season ON campeonato.match(season);
CREATE INDEX IF NOT EXISTS idx_match_date ON campeonato.match(date);
CREATE INDEX IF NOT EXISTS idx_player_attributes_player_api_id ON campeonato.player_attributes(player_api_id);
CREATE INDEX IF NOT EXISTS idx_team_attributes_team_api_id ON campeonato.team_attributes(team_api_id);

COMMIT;
