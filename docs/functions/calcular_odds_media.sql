-- =====================================================
-- FUNÇÃO: calcular_odds_media
-- =====================================================
-- Descrição: Calcula a média das odds de todas as casas de apostas para uma partida
-- Parâmetros: match_id - ID da partida (INTEGER)
-- Retorna: Média das odds de vitória, empate e derrota
-- Uso: Análise de probabilidades de apostas

CREATE OR REPLACE FUNCTION campeonato.calcular_odds_media(match_id INTEGER)
RETURNS TABLE(
    odds_media_casa NUMERIC,
    odds_media_empate NUMERIC,
    odds_media_visitante NUMERIC,
    total_bookmakers INTEGER,
    favorito TEXT
) AS $$
BEGIN
    RETURN QUERY
    WITH odds_medias AS (
        SELECT 
            ROUND(AVG(home_odds), 2) AS media_casa,
            ROUND(AVG(draw_odds), 2) AS media_empate,
            ROUND(AVG(away_odds), 2) AS media_visitante,
            COUNT(*) AS total_bookmakers
        FROM campeonato.match_odds
        WHERE match_id = $1
    )
    SELECT 
        om.media_casa AS odds_media_casa,
        om.media_empate AS odds_media_empate,
        om.media_visitante AS odds_media_visitante,
        om.total_bookmakers::INTEGER AS total_bookmakers,
        CASE 
            WHEN om.media_casa < om.media_empate AND om.media_casa < om.media_visitante THEN 'Casa'
            WHEN om.media_empate < om.media_casa AND om.media_empate < om.media_visitante THEN 'Empate'
            WHEN om.media_visitante < om.media_casa AND om.media_visitante < om.media_empate THEN 'Visitante'
            ELSE 'Indefinido'
        END AS favorito
    FROM odds_medias om;
END;
$$ LANGUAGE plpgsql;

-- Comentário da função
COMMENT ON FUNCTION campeonato.calcular_odds_media(INTEGER) IS 
'Calcula a média das odds de todas as casas de apostas para uma partida e identifica o favorito'; 