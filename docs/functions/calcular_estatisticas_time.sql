-- =====================================================
-- FUNÇÃO: calcular_estatisticas_time
-- =====================================================
-- Descrição: Calcula estatísticas básicas de um time em uma temporada
-- Parâmetros: 
--   team_id - ID do time (INTEGER)
--   season_name - Nome da temporada (TEXT)
-- Retorna: Vitórias, empates, derrotas, gols marcados/sofridos
-- Uso: Relatórios de performance do time

CREATE OR REPLACE FUNCTION campeonato.calcular_estatisticas_time(team_id INTEGER, season_name TEXT)
RETURNS TABLE(
    total_partidas BIGINT,
    vitorias BIGINT,
    empates BIGINT,
    derrotas BIGINT,
    gols_marcados BIGINT,
    gols_sofridos BIGINT,
    pontos INTEGER,
    aproveitamento NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    WITH estatisticas AS (
        SELECT 
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
        WHERE t.id = team_id AND m.season = season_name
    )
    SELECT 
        (partidas_mandante + partidas_visitante)::BIGINT AS total_partidas,
        (vitorias_mandante + vitorias_visitante)::BIGINT AS vitorias,
        (empates_mandante + empates_visitante)::BIGINT AS empates,
        (derrotas_mandante + derrotas_visitante)::BIGINT AS derrotas,
        (gols_marcados_mandante + gols_marcados_visitante)::BIGINT AS gols_marcados,
        (gols_sofridos_mandante + gols_sofridos_visitante)::BIGINT AS gols_sofridos,
        ((vitorias_mandante + vitorias_visitante) * 3 + (empates_mandante + empates_visitante))::INTEGER AS pontos,
        ROUND(
            (((vitorias_mandante + vitorias_visitante) * 3 + (empates_mandante + empates_visitante)) * 100.0) / 
            NULLIF((partidas_mandante + partidas_visitante) * 3, 0), 2
        ) AS aproveitamento
    FROM estatisticas;
END;
$$ LANGUAGE plpgsql;

-- Comentário da função
COMMENT ON FUNCTION campeonato.calcular_estatisticas_time(INTEGER, TEXT) IS 
'Calcula estatísticas completas de um time em uma temporada específica'; 