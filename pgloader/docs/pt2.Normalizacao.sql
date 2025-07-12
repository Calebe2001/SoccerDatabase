-- SCRIPTS DE MIGRAÇÃO

-- 1. POPULAR TABELA SEASON
INSERT INTO campeonato.season (season_name, year_start, year_end)
SELECT DISTINCT 
    season,
    CAST(SUBSTRING(season, 1, 4) AS INTEGER) AS year_start,
    CAST(SUBSTRING(season, 6, 4) AS INTEGER) AS year_end
FROM campeonato.match 
WHERE season IS NOT NULL
ORDER BY season;

-- 2. POPULAR TABELA VENUE (baseado nos times da casa)
INSERT INTO campeonato.venue (venue_name, city, country_id)
SELECT DISTINCT 
    t.team_long_name || ' Stadium' AS venue_name,
    t.team_long_name || ' City' AS city,
    l.country_id
FROM campeonato.match m
JOIN campeonato.team t ON t.team_api_id = m.home_team_api_id
JOIN campeonato.league l ON l.id = m.league_id
WHERE m.home_team_api_id IS NOT NULL
  AND t.team_long_name IS NOT NULL
  AND l.country_id IS NOT NULL;

-- 3. POPULAR TABELA MATCH_PLAYERS
INSERT INTO campeonato.match_players (match_id, team_id, player_id, position_x, position_y, player_number, is_home)
WITH all_players AS (
    -- Jogadores da casa
    SELECT 
        m.id AS match_id,
        ht.id AS team_id,
        p.id AS player_id,
        m.home_player_x1 AS position_x,
        m.home_player_y1 AS position_y,
        1 AS player_number,
        TRUE AS is_home
    FROM campeonato.match m
    JOIN campeonato.team ht ON ht.team_api_id = m.home_team_api_id
    JOIN campeonato.player p ON p.player_api_id = m.home_player_1
    WHERE m.home_player_1 IS NOT NULL

    UNION ALL

    SELECT 
        m.id AS match_id,
        ht.id AS team_id,
        p.id AS player_id,
        m.home_player_x2 AS position_x,
        m.home_player_y2 AS position_y,
        2 AS player_number,
        TRUE AS is_home
    FROM campeonato.match m
    JOIN campeonato.team ht ON ht.team_api_id = m.home_team_api_id
    JOIN campeonato.player p ON p.player_api_id = m.home_player_2
    WHERE m.home_player_2 IS NOT NULL

    UNION ALL

    SELECT 
        m.id AS match_id,
        ht.id AS team_id,
        p.id AS player_id,
        m.home_player_x3 AS position_x,
        m.home_player_y3 AS position_y,
        3 AS player_number,
        TRUE AS is_home
    FROM campeonato.match m
    JOIN campeonato.team ht ON ht.team_api_id = m.home_team_api_id
    JOIN campeonato.player p ON p.player_api_id = m.home_player_3
    WHERE m.home_player_3 IS NOT NULL

    UNION ALL

    SELECT 
        m.id AS match_id,
        ht.id AS team_id,
        p.id AS player_id,
        m.home_player_x4 AS position_x,
        m.home_player_y4 AS position_y,
        4 AS player_number,
        TRUE AS is_home
    FROM campeonato.match m
    JOIN campeonato.team ht ON ht.team_api_id = m.home_team_api_id
    JOIN campeonato.player p ON p.player_api_id = m.home_player_4
    WHERE m.home_player_4 IS NOT NULL

    UNION ALL

    SELECT 
        m.id AS match_id,
        ht.id AS team_id,
        p.id AS player_id,
        m.home_player_x5 AS position_x,
        m.home_player_y5 AS position_y,
        5 AS player_number,
        TRUE AS is_home
    FROM campeonato.match m
    JOIN campeonato.team ht ON ht.team_api_id = m.home_team_api_id
    JOIN campeonato.player p ON p.player_api_id = m.home_player_5
    WHERE m.home_player_5 IS NOT NULL

    UNION ALL

    SELECT 
        m.id AS match_id,
        ht.id AS team_id,
        p.id AS player_id,
        m.home_player_x6 AS position_x,
        m.home_player_y6 AS position_y,
        6 AS player_number,
        TRUE AS is_home
    FROM campeonato.match m
    JOIN campeonato.team ht ON ht.team_api_id = m.home_team_api_id
    JOIN campeonato.player p ON p.player_api_id = m.home_player_6
    WHERE m.home_player_6 IS NOT NULL

    UNION ALL

    SELECT 
        m.id AS match_id,
        ht.id AS team_id,
        p.id AS player_id,
        m.home_player_x7 AS position_x,
        m.home_player_y7 AS position_y,
        7 AS player_number,
        TRUE AS is_home
    FROM campeonato.match m
    JOIN campeonato.team ht ON ht.team_api_id = m.home_team_api_id
    JOIN campeonato.player p ON p.player_api_id = m.home_player_7
    WHERE m.home_player_7 IS NOT NULL

    UNION ALL

    SELECT 
        m.id AS match_id,
        ht.id AS team_id,
        p.id AS player_id,
        m.home_player_x8 AS position_x,
        m.home_player_y8 AS position_y,
        8 AS player_number,
        TRUE AS is_home
    FROM campeonato.match m
    JOIN campeonato.team ht ON ht.team_api_id = m.home_team_api_id
    JOIN campeonato.player p ON p.player_api_id = m.home_player_8
    WHERE m.home_player_8 IS NOT NULL

    UNION ALL

    SELECT 
        m.id AS match_id,
        ht.id AS team_id,
        p.id AS player_id,
        m.home_player_x9 AS position_x,
        m.home_player_y9 AS position_y,
        9 AS player_number,
        TRUE AS is_home
    FROM campeonato.match m
    JOIN campeonato.team ht ON ht.team_api_id = m.home_team_api_id
    JOIN campeonato.player p ON p.player_api_id = m.home_player_9
    WHERE m.home_player_9 IS NOT NULL

    UNION ALL

    SELECT 
        m.id AS match_id,
        ht.id AS team_id,
        p.id AS player_id,
        m.home_player_x10 AS position_x,
        m.home_player_y10 AS position_y,
        10 AS player_number,
        TRUE AS is_home
    FROM campeonato.match m
    JOIN campeonato.team ht ON ht.team_api_id = m.home_team_api_id
    JOIN campeonato.player p ON p.player_api_id = m.home_player_10
    WHERE m.home_player_10 IS NOT NULL

    UNION ALL

    SELECT 
        m.id AS match_id,
        ht.id AS team_id,
        p.id AS player_id,
        m.home_player_x11 AS position_x,
        m.home_player_y11 AS position_y,
        11 AS player_number,
        TRUE AS is_home
    FROM campeonato.match m
    JOIN campeonato.team ht ON ht.team_api_id = m.home_team_api_id
    JOIN campeonato.player p ON p.player_api_id = m.home_player_11
    WHERE m.home_player_11 IS NOT NULL

    -- Jogadores visitantes
    UNION ALL

    SELECT 
        m.id AS match_id,
        at.id AS team_id,
        p.id AS player_id,
        m.away_player_x1 AS position_x,
        m.away_player_y1 AS position_y,
        1 AS player_number,
        FALSE AS is_home
    FROM campeonato.match m
    JOIN campeonato.team at ON at.team_api_id = m.away_team_api_id
    JOIN campeonato.player p ON p.player_api_id = m.away_player_1
    WHERE m.away_player_1 IS NOT NULL

    UNION ALL

    SELECT 
        m.id AS match_id,
        at.id AS team_id,
        p.id AS player_id,
        m.away_player_x2 AS position_x,
        m.away_player_y2 AS position_y,
        2 AS player_number,
        FALSE AS is_home
    FROM campeonato.match m
    JOIN campeonato.team at ON at.team_api_id = m.away_team_api_id
    JOIN campeonato.player p ON p.player_api_id = m.away_player_2
    WHERE m.away_player_2 IS NOT NULL

    UNION ALL

    SELECT 
        m.id AS match_id,
        at.id AS team_id,
        p.id AS player_id,
        m.away_player_x3 AS position_x,
        m.away_player_y3 AS position_y,
        3 AS player_number,
        FALSE AS is_home
    FROM campeonato.match m
    JOIN campeonato.team at ON at.team_api_id = m.away_team_api_id
    JOIN campeonato.player p ON p.player_api_id = m.away_player_3
    WHERE m.away_player_3 IS NOT NULL

    UNION ALL

    SELECT 
        m.id AS match_id,
        at.id AS team_id,
        p.id AS player_id,
        m.away_player_x4 AS position_x,
        m.away_player_y4 AS position_y,
        4 AS player_number,
        FALSE AS is_home
    FROM campeonato.match m
    JOIN campeonato.team at ON at.team_api_id = m.away_team_api_id
    JOIN campeonato.player p ON p.player_api_id = m.away_player_4
    WHERE m.away_player_4 IS NOT NULL

    UNION ALL

    SELECT 
        m.id AS match_id,
        at.id AS team_id,
        p.id AS player_id,
        m.away_player_x5 AS position_x,
        m.away_player_y5 AS position_y,
        5 AS player_number,
        FALSE AS is_home
    FROM campeonato.match m
    JOIN campeonato.team at ON at.team_api_id = m.away_team_api_id
    JOIN campeonato.player p ON p.player_api_id = m.away_player_5
    WHERE m.away_player_5 IS NOT NULL

    UNION ALL

    SELECT 
        m.id AS match_id,
        at.id AS team_id,
        p.id AS player_id,
        m.away_player_x6 AS position_x,
        m.away_player_y6 AS position_y,
        6 AS player_number,
        FALSE AS is_home
    FROM campeonato.match m
    JOIN campeonato.team at ON at.team_api_id = m.away_team_api_id
    JOIN campeonato.player p ON p.player_api_id = m.away_player_6
    WHERE m.away_player_6 IS NOT NULL

    UNION ALL

    SELECT 
        m.id AS match_id,
        at.id AS team_id,
        p.id AS player_id,
        m.away_player_x7 AS position_x,
        m.away_player_y7 AS position_y,
        7 AS player_number,
        FALSE AS is_home
    FROM campeonato.match m
    JOIN campeonato.team at ON at.team_api_id = m.away_team_api_id
    JOIN campeonato.player p ON p.player_api_id = m.away_player_7
    WHERE m.away_player_7 IS NOT NULL

    UNION ALL

    SELECT 
        m.id AS match_id,
        at.id AS team_id,
        p.id AS player_id,
        m.away_player_x8 AS position_x,
        m.away_player_y8 AS position_y,
        8 AS player_number,
        FALSE AS is_home
    FROM campeonato.match m
    JOIN campeonato.team at ON at.team_api_id = m.away_team_api_id
    JOIN campeonato.player p ON p.player_api_id = m.away_player_8
    WHERE m.away_player_8 IS NOT NULL

    UNION ALL

    SELECT 
        m.id AS match_id,
        at.id AS team_id,
        p.id AS player_id,
        m.away_player_x9 AS position_x,
        m.away_player_y9 AS position_y,
        9 AS player_number,
        FALSE AS is_home
    FROM campeonato.match m
    JOIN campeonato.team at ON at.team_api_id = m.away_team_api_id
    JOIN campeonato.player p ON p.player_api_id = m.away_player_9
    WHERE m.away_player_9 IS NOT NULL

    UNION ALL

    SELECT 
        m.id AS match_id,
        at.id AS team_id,
        p.id AS player_id,
        m.away_player_x10 AS position_x,
        m.away_player_y10 AS position_y,
        10 AS player_number,
        FALSE AS is_home
    FROM campeonato.match m
    JOIN campeonato.team at ON at.team_api_id = m.away_team_api_id
    JOIN campeonato.player p ON p.player_api_id = m.away_player_10
    WHERE m.away_player_10 IS NOT NULL

    UNION ALL

    SELECT 
        m.id AS match_id,
        at.id AS team_id,
        p.id AS player_id,
        m.away_player_x11 AS position_x,
        m.away_player_y11 AS position_y,
        11 AS player_number,
        FALSE AS is_home
    FROM campeonato.match m
    JOIN campeonato.team at ON at.team_api_id = m.away_team_api_id
    JOIN campeonato.player p ON p.player_api_id = m.away_player_11
    WHERE m.away_player_11 IS NOT NULL
),
ranked_players AS (
    SELECT 
        match_id,
        team_id,
        player_id,
        position_x,
        position_y,
        player_number,
        is_home,
        ROW_NUMBER() OVER (PARTITION BY match_id, player_id ORDER BY is_home DESC, player_number) as rn
    FROM all_players
)
SELECT 
    match_id,
    team_id,
    player_id,
    position_x,
    position_y,
    player_number,
    is_home
FROM ranked_players
WHERE rn = 1;

-- 4. POPULAR TABELA MATCH_ODDS
INSERT INTO campeonato.match_odds (match_id, bookmaker, home_odds, draw_odds, away_odds)
SELECT id, 'B365', b365h, b365d, b365a FROM campeonato.match WHERE b365h IS NOT NULL
UNION ALL
SELECT id, 'BW', bwh, bwd, bwa FROM campeonato.match WHERE bwh IS NOT NULL
UNION ALL
SELECT id, 'IW', iwh, iwd, iwa FROM campeonato.match WHERE iwh IS NOT NULL
UNION ALL
SELECT id, 'LB', lbh, lbd, lba FROM campeonato.match WHERE lbh IS NOT NULL
UNION ALL
SELECT id, 'PS', psh, psd, psa FROM campeonato.match WHERE psh IS NOT NULL
UNION ALL
SELECT id, 'WH', whh, whd, wha FROM campeonato.match WHERE whh IS NOT NULL
UNION ALL
SELECT id, 'SJ', sjh, sjd, sja FROM campeonato.match WHERE sjh IS NOT NULL
UNION ALL
SELECT id, 'VC', vch, vcd, vca FROM campeonato.match WHERE vch IS NOT NULL
UNION ALL
SELECT id, 'GB', gbh, gbd, gba FROM campeonato.match WHERE gbh IS NOT NULL
UNION ALL
SELECT id, 'BS', bsh, bsd, bsa FROM campeonato.match WHERE bsh IS NOT NULL;
