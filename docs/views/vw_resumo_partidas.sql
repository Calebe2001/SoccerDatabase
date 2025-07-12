-- =====================================================
-- VIEW: vw_resumo_partidas
-- =====================================================
-- Descrição: View simplificada com informações essenciais das partidas
-- Utilidade: Consultas rápidas de resultados e apostas
-- Conteúdo: Times, resultado, data, liga, odds médias

CREATE OR REPLACE VIEW campeonato.vw_resumo_partidas AS
SELECT 
    m.id AS match_id,
    m.season,
    m.date,
    m.stage,
    -- Times
    ht.team_long_name AS home_team_name,
    ht.team_short_name AS home_team_short,
    at.team_long_name AS away_team_name,
    at.team_short_name AS away_team_short,
    -- Resultado
    m.home_team_goal,
    m.away_team_goal,
    CASE 
        WHEN m.home_team_goal > m.away_team_goal THEN 'Vitória Casa'
        WHEN m.home_team_goal < m.away_team_goal THEN 'Vitória Visitante'
        WHEN m.home_team_goal = m.away_team_goal THEN 'Empate'
        ELSE 'Sem resultado'
    END AS resultado,
    -- Liga e País
    l.name AS league_name,
    c.name AS country_name,
    -- Odds médias (calculadas a partir da tabela match_odds)
    ROUND(AVG(mo.home_odds), 2) AS odds_media_casa,
    ROUND(AVG(mo.draw_odds), 2) AS odds_media_empate,
    ROUND(AVG(mo.away_odds), 2) AS odds_media_visitante,
    -- Estatísticas de eventos
    COUNT(DISTINCT me.id) AS total_eventos,
    COUNT(DISTINCT CASE WHEN me.event_type = 'goal' THEN me.id END) AS total_gols_eventos,
    COUNT(DISTINCT CASE WHEN me.event_type = 'card' THEN me.id END) AS total_cartoes,
    -- Estatísticas de jogadores
    COUNT(DISTINCT mp.player_id) AS total_jogadores,
    COUNT(DISTINCT CASE WHEN mp.is_home THEN mp.player_id END) AS jogadores_casa,
    COUNT(DISTINCT CASE WHEN NOT mp.is_home THEN mp.player_id END) AS jogadores_visitante,
    -- Informações adicionais
    m.match_api_id,
    m.home_team_api_id,
    m.away_team_api_id
FROM campeonato.match m
JOIN campeonato.team ht ON ht.team_api_id = m.home_team_api_id
JOIN campeonato.team at ON at.team_api_id = m.away_team_api_id
JOIN campeonato.league l ON l.id = m.league_id
JOIN campeonato.country c ON c.id = l.country_id
LEFT JOIN campeonato.match_odds mo ON mo.match_id = m.id
LEFT JOIN campeonato.match_events me ON me.match_id = m.id
LEFT JOIN campeonato.match_players mp ON mp.match_id = m.id
GROUP BY 
    m.id,
    m.season,
    m.date,
    m.stage,
    ht.team_long_name,
    ht.team_short_name,
    at.team_long_name,
    at.team_short_name,
    m.home_team_goal,
    m.away_team_goal,
    l.name,
    c.name,
    m.match_api_id,
    m.home_team_api_id,
    m.away_team_api_id;

-- Comentário da view
COMMENT ON VIEW campeonato.vw_resumo_partidas IS 
'View simplificada com informações essenciais das partidas incluindo times, resultado, liga e odds médias'; 