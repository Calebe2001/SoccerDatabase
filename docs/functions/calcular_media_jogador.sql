-- =====================================================
-- FUNÇÃO: calcular_media_jogador
-- =====================================================
-- Descrição: Calcula a média geral de atributos de um jogador
-- Parâmetros: player_id - ID do jogador (BIGINT)
-- Retorna: Média numérica dos atributos (overall_rating, potential, etc.)
-- Uso: Análise de performance individual

CREATE OR REPLACE FUNCTION campeonato.calcular_media_jogador(player_id BIGINT)
RETURNS NUMERIC AS $$
DECLARE
    media_atributos NUMERIC;
BEGIN
    -- Calcula a média dos principais atributos do jogador
    SELECT ROUND(AVG(
        COALESCE(overall_rating, 0) +
        COALESCE(potential, 0) +
        COALESCE(finishing, 0) +
        COALESCE(dribbling, 0) +
        COALESCE(short_passing, 0) +
        COALESCE(ball_control, 0) +
        COALESCE(acceleration, 0) +
        COALESCE(sprint_speed, 0) +
        COALESCE(agility, 0) +
        COALESCE(reactions, 0) +
        COALESCE(balance, 0) +
        COALESCE(shot_power, 0) +
        COALESCE(jumping, 0) +
        COALESCE(stamina, 0) +
        COALESCE(strength, 0) +
        COALESCE(long_shots, 0) +
        COALESCE(aggression, 0) +
        COALESCE(interceptions, 0) +
        COALESCE(positioning, 0) +
        COALESCE(vision, 0) +
        COALESCE(penalties, 0) +
        COALESCE(marking, 0) +
        COALESCE(standing_tackle, 0) +
        COALESCE(sliding_tackle, 0)
    ) / 25.0, 2)
    INTO media_atributos
    FROM campeonato.player_attributes pa
    JOIN campeonato.player p ON p.player_api_id = pa.player_api_id
    WHERE p.id = player_id;
    
    -- Retorna a média ou 0 se não encontrar dados
    RETURN COALESCE(media_atributos, 0);
END;
$$ LANGUAGE plpgsql;

-- Comentário da função
COMMENT ON FUNCTION campeonato.calcular_media_jogador(BIGINT) IS 
'Calcula a média geral de atributos de um jogador baseado em 25 atributos principais'; 