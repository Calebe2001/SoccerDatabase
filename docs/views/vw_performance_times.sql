-- =====================================================
-- VIEW: vw_performance_times
-- =====================================================
-- Descrição: View com performance consolidada dos times por temporada
-- Utilidade: Análise de performance e ranking dos times
-- Conteúdo: Vitórias, empates, derrotas, gols, pontos, posição

CREATE OR REPLACE VIEW campeonato.vw_performance_times AS
WITH estatisticas_times AS (
    SELECT 
        m.season,
        t.id AS team_id,
        t.team_long_name,
        t.team_short_name,
        l.name AS league_name,
        c.name AS country_name,
        -- Partidas como mandante
        COUNT(CASE WHEN m.home_team_api_id = t.team_api_id THEN 1 END) AS partidas_mandante,
        COUNT(CASE WHEN m.home_team_api_id = t.team_api_id AND m.home_team_goal > m.away_team_goal THEN 1 END) AS vitorias_mandante,
        COUNT(CASE WHEN m.home_team_api_id = t.team_api_id AND m.home_team_goal = m.away_team_goal THEN 1 END) AS empates_mandante,
        COUNT(CASE WHEN m.home_team_api_id = t.team_api_id AND m.home_team_goal < m.away_team_goal THEN 1 END) AS derrotas_mandante,
        SUM(CASE WHEN m.home_team_api_id = t.team_api_id THEN m.home_team_goal ELSE 0 END) AS gols_marcados_mandante,
        SUM(CASE WHEN m.home_team_api_id = t.team_api_id THEN m.away_team_goal ELSE 0 END) AS gols_sofridos_mandante,
        -- Partidas como visitante
        COUNT(CASE WHEN m.away_team_api_id = t.team_api_id THEN 1 END) AS partidas_visitante,
        COUNT(CASE WHEN m.away_team_api_id = t.team_api_id AND m.away_team_goal > m.home_team_goal THEN 1 END) AS vitorias_visitante,
        COUNT(CASE WHEN m.away_team_api_id = t.team_api_id AND m.away_team_goal = m.home_team_goal THEN 1 END) AS empates_visitante,
        COUNT(CASE WHEN m.away_team_api_id = t.team_api_id AND m.away_team_goal < m.home_team_goal THEN 1 END) AS derrotas_visitante,
        SUM(CASE WHEN m.away_team_api_id = t.team_api_id THEN m.away_team_goal ELSE 0 END) AS gols_marcados_visitante,
        SUM(CASE WHEN m.away_team_api_id = t.team_api_id THEN m.home_team_goal ELSE 0 END) AS gols_sofridos_visitante
    FROM campeonato.team t
    JOIN campeonato.match m ON (m.home_team_api_id = t.team_api_id OR m.away_team_api_id = t.team_api_id)
    JOIN campeonato.league l ON l.id = m.league_id
    JOIN campeonato.country c ON c.id = l.country_id
    WHERE m.season IS NOT NULL
    GROUP BY m.season, t.id, t.team_long_name, t.team_short_name, l.name, c.name
)
SELECT 
    season,
    team_id,
    team_long_name,
    team_short_name,
    league_name,
    country_name,
    -- Totais
    (partidas_mandante + partidas_visitante) AS total_partidas,
    (vitorias_mandante + vitorias_visitante) AS total_vitorias,
    (empates_mandante + empates_visitante) AS total_empates,
    (derrotas_mandante + derrotas_visitante) AS total_derrotas,
    (gols_marcados_mandante + gols_marcados_visitante) AS total_gols_marcados,
    (gols_sofridos_mandante + gols_sofridos_visitante) AS total_gols_sofridos,
    -- Cálculo de pontos (3 vitórias, 1 empate, 0 derrota)
    ((vitorias_mandante + vitorias_visitante) * 3 + (empates_mandante + empates_visitante)) AS pontos,
    -- Saldo de gols
    ((gols_marcados_mandante + gols_marcados_visitante) - (gols_sofridos_mandante + gols_sofridos_visitante)) AS saldo_gols,
    -- Percentual de aproveitamento
    ROUND(
        (((vitorias_mandante + vitorias_visitante) * 3 + (empates_mandante + empates_visitante)) * 100.0) / 
        ((partidas_mandante + partidas_visitante) * 3), 2
    ) AS aproveitamento_percentual,
    -- Estatísticas por local
    partidas_mandante,
    vitorias_mandante,
    empates_mandante,
    derrotas_mandante,
    gols_marcados_mandante,
    gols_sofridos_mandante,
    partidas_visitante,
    vitorias_visitante,
    empates_visitante,
    derrotas_visitante,
    gols_marcados_visitante,
    gols_sofridos_visitante
FROM estatisticas_times
WHERE (partidas_mandante + partidas_visitante) > 0;

-- Comentário da view
COMMENT ON VIEW campeonato.vw_performance_times IS 
'View com performance consolidada dos times por temporada incluindo vitórias, empates, derrotas, gols e pontos'; 