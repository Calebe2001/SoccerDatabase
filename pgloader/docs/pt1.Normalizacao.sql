-- PARTE 1 - NORMALIZAÇÃO DA BASE DE DADOS


-- NOVAS TABELAS NORMALIZADAS

-- 8. SEASON - Normalizar temporadas
CREATE TABLE campeonato.season (
    id SERIAL PRIMARY KEY,
    season_name VARCHAR(20) NOT NULL UNIQUE,
    year_start INTEGER,
    year_end INTEGER
);

-- 9. VENUE - Normalizar estádios/localidades
CREATE TABLE campeonato.venue (
    id SERIAL PRIMARY KEY,
    venue_name VARCHAR(200) NOT NULL,
    city VARCHAR(100),
    country_id BIGINT REFERENCES campeonato.country(id)
);

-- 10. MATCH_PLAYERS - Normalizar jogadores por partida (1NF)
CREATE TABLE campeonato.match_players (
    id SERIAL PRIMARY KEY,
    match_id BIGINT REFERENCES campeonato.match(id),
    team_id INTEGER REFERENCES campeonato.team(id),
    player_id BIGINT REFERENCES campeonato.player(id),
    position_x INTEGER,
    position_y INTEGER,
    player_number INTEGER,
    is_home BOOLEAN NOT NULL,
    UNIQUE(match_id, player_id)
);

-- 11. MATCH_EVENTS - Normalizar eventos da partida (1NF)
CREATE TABLE campeonato.match_events (
    id SERIAL PRIMARY KEY,
    match_id BIGINT REFERENCES campeonato.match(id),
    event_type VARCHAR(50) NOT NULL, -- 'goal', 'card', 'foul', 'corner', etc.
    minute INTEGER,
    description TEXT,
    player_id BIGINT REFERENCES campeonato.player(id),
    team_id INTEGER REFERENCES campeonato.team(id)
);

-- 12. MATCH_ODDS - Normalizar odds de apostas (1NF)
CREATE TABLE campeonato.match_odds (
    id SERIAL PRIMARY KEY,
    match_id BIGINT REFERENCES campeonato.match(id),
    bookmaker VARCHAR(10) NOT NULL, -- 'B365', 'BW', 'IW', etc.
    home_odds NUMERIC(5,2),
    draw_odds NUMERIC(5,2),
    away_odds NUMERIC(5,2),
    UNIQUE(match_id, bookmaker)
);

-- =====================================================
-- ÍNDICES PARA PERFORMANCE
-- =====================================================

-- Índices para match_players
CREATE INDEX idx_match_players_match_id ON campeonato.match_players(match_id);
CREATE INDEX idx_match_players_team_id ON campeonato.match_players(team_id);
CREATE INDEX idx_match_players_player_id ON campeonato.match_players(player_id);

-- Índices para match_events
CREATE INDEX idx_match_events_match_id ON campeonato.match_events(match_id);
CREATE INDEX idx_match_events_event_type ON campeonato.match_events(event_type);
CREATE INDEX idx_match_events_player_id ON campeonato.match_events(player_id);

-- Índices para match_odds
CREATE INDEX idx_match_odds_match_id ON campeonato.match_odds(match_id);
CREATE INDEX idx_match_odds_bookmaker ON campeonato.match_odds(bookmaker);

-- Índices para venue (estádio)
CREATE INDEX idx_venue_country_id ON campeonato.venue(country_id);