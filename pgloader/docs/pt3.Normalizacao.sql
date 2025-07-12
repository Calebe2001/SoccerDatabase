-- POPULAR TABELA MATCH_EVENTS (EXTRAINDO DADOS XML)
-- (pois tabela de match_events ficou vazia)

-- Extrair eventos de gols
INSERT INTO campeonato.match_events (match_id, event_type, minute, description, player_id, team_id)
WITH goal_events AS (
    SELECT 
        m.id as match_id,
        'goal' as event_type,
        CAST(SUBSTRING(goal, POSITION('<elapsed>' IN goal) + 9, 
             POSITION('</elapsed>' IN goal) - POSITION('<elapsed>' IN goal) - 9) AS INTEGER) as minute,
        CASE 
            WHEN POSITION('<goal_type>o</goal_type>' IN goal) > 0 THEN 'Own Goal'
            WHEN POSITION('<goal_type>p</goal_type>' IN goal) > 0 THEN 'Penalty'
            WHEN POSITION('<goal_type>n</goal_type>' IN goal) > 0 THEN 'Normal Goal'
            ELSE 'Goal'
        END as description,
        CAST(SUBSTRING(goal, POSITION('<player1>' IN goal) + 9, 
             POSITION('</player1>' IN goal) - POSITION('<player1>' IN goal) - 9) AS BIGINT) as player_api_id,
        CAST(SUBSTRING(goal, POSITION('<team>' IN goal) + 6, 
             POSITION('</team>' IN goal) - POSITION('<team>' IN goal) - 6) AS INTEGER) as team_api_id
    FROM campeonato.match m
    WHERE m.goal IS NOT NULL 
      AND m.goal != ''
      AND POSITION('<elapsed>' IN goal) > 0
      AND POSITION('<player1>' IN goal) > 0
      AND POSITION('<team>' IN goal) > 0
)
SELECT 
    ge.match_id,
    ge.event_type,
    ge.minute,
    ge.description,
    p.id as player_id,
    t.id as team_id
FROM goal_events ge
JOIN campeonato.player p ON p.player_api_id = ge.player_api_id
JOIN campeonato.team t ON t.team_api_id = ge.team_api_id
WHERE ge.minute IS NOT NULL
  AND ge.player_api_id IS NOT NULL
  AND ge.team_api_id IS NOT NULL;

-- Extrair eventos de cartões
INSERT INTO campeonato.match_events (match_id, event_type, minute, description, player_id, team_id)
WITH card_events AS (
    SELECT 
        m.id as match_id,
        'card' as event_type,
        CAST(SUBSTRING(card, POSITION('<elapsed>' IN card) + 9, 
             POSITION('</elapsed>' IN card) - POSITION('<elapsed>' IN card) - 9) AS INTEGER) as minute,
        CASE 
            WHEN POSITION('<comment>y</comment>' IN card) > 0 THEN 'Yellow Card'
            WHEN POSITION('<comment>r</comment>' IN card) > 0 THEN 'Red Card'
            WHEN POSITION('<comment>y2</comment>' IN card) > 0 THEN 'Second Yellow Card'
            ELSE 'Card'
        END as description,
        CAST(SUBSTRING(card, POSITION('<player1>' IN card) + 9, 
             POSITION('</player1>' IN card) - POSITION('<player1>' IN card) - 9) AS BIGINT) as player_api_id,
        CAST(SUBSTRING(card, POSITION('<team>' IN card) + 6, 
             POSITION('</team>' IN card) - POSITION('<team>' IN card) - 6) AS INTEGER) as team_api_id
    FROM campeonato.match m
    WHERE m.card IS NOT NULL 
      AND m.card != ''
      AND POSITION('<elapsed>' IN card) > 0
      AND POSITION('<player1>' IN card) > 0
      AND POSITION('<team>' IN card) > 0
)
SELECT 
    ce.match_id,
    ce.event_type,
    ce.minute,
    ce.description,
    p.id as player_id,
    t.id as team_id
FROM card_events ce
JOIN campeonato.player p ON p.player_api_id = ce.player_api_id
JOIN campeonato.team t ON t.team_api_id = ce.team_api_id
WHERE ce.minute IS NOT NULL
  AND ce.player_api_id IS NOT NULL
  AND ce.team_api_id IS NOT NULL;

-- Extrair eventos de faltas
INSERT INTO campeonato.match_events (match_id, event_type, minute, description, player_id, team_id)
WITH foul_events AS (
    SELECT 
        m.id as match_id,
        'foul' as event_type,
        CAST(SUBSTRING(foulcommit, POSITION('<elapsed>' IN foulcommit) + 9, 
             POSITION('</elapsed>' IN foulcommit) - POSITION('<elapsed>' IN foulcommit) - 9) AS INTEGER) as minute,
        'Foul Committed' as description,
        CAST(SUBSTRING(foulcommit, POSITION('<player1>' IN foulcommit) + 9, 
             POSITION('</player1>' IN foulcommit) - POSITION('<player1>' IN foulcommit) - 9) AS BIGINT) as player_api_id,
        CAST(SUBSTRING(foulcommit, POSITION('<team>' IN foulcommit) + 6, 
             POSITION('</team>' IN foulcommit) - POSITION('<team>' IN foulcommit) - 6) AS INTEGER) as team_api_id
    FROM campeonato.match m
    WHERE m.foulcommit IS NOT NULL 
      AND m.foulcommit != ''
      AND POSITION('<elapsed>' IN foulcommit) > 0
      AND POSITION('<player1>' IN foulcommit) > 0
      AND POSITION('<team>' IN foulcommit) > 0
)
SELECT 
    fe.match_id,
    fe.event_type,
    fe.minute,
    fe.description,
    p.id as player_id,
    t.id as team_id
FROM foul_events fe
JOIN campeonato.player p ON p.player_api_id = fe.player_api_id
JOIN campeonato.team t ON t.team_api_id = fe.team_api_id
WHERE fe.minute IS NOT NULL
  AND fe.player_api_id IS NOT NULL
  AND fe.team_api_id IS NOT NULL;

-- Extrair eventos de escanteios
INSERT INTO campeonato.match_events (match_id, event_type, minute, description, player_id, team_id)
WITH corner_events AS (
    SELECT 
        m.id as match_id,
        'corner' as event_type,
        CAST(SUBSTRING(corner, POSITION('<elapsed>' IN corner) + 9, 
             POSITION('</elapsed>' IN corner) - POSITION('<elapsed>' IN corner) - 9) AS INTEGER) as minute,
        'Corner Kick' as description,
        CAST(SUBSTRING(corner, POSITION('<player1>' IN corner) + 9, 
             POSITION('</player1>' IN corner) - POSITION('<player1>' IN corner) - 9) AS BIGINT) as player_api_id,
        CAST(SUBSTRING(corner, POSITION('<team>' IN corner) + 6, 
             POSITION('</team>' IN corner) - POSITION('<team>' IN corner) - 6) AS INTEGER) as team_api_id
    FROM campeonato.match m
    WHERE m.corner IS NOT NULL 
      AND m.corner != ''
      AND POSITION('<elapsed>' IN corner) > 0
      AND POSITION('<player1>' IN corner) > 0
      AND POSITION('<team>' IN corner) > 0
)
SELECT 
    ce.match_id,
    ce.event_type,
    ce.minute,
    ce.description,
    p.id as player_id,
    t.id as team_id
FROM corner_events ce
JOIN campeonato.player p ON p.player_api_id = ce.player_api_id
JOIN campeonato.team t ON t.team_api_id = ce.team_api_id
WHERE ce.minute IS NOT NULL
  AND ce.player_api_id IS NOT NULL
  AND ce.team_api_id IS NOT NULL;