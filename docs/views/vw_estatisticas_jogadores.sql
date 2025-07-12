-- =====================================================
-- VIEW: vw_estatisticas_jogadores
-- =====================================================
-- Descrição: View consolidada com estatísticas completas dos jogadores
-- Utilidade: Consultas rápidas de performance individual
-- Conteúdo: Dados do jogador + médias de atributos + total de partidas

CREATE OR REPLACE VIEW campeonato.vw_estatisticas_jogadores AS
SELECT 
    p.id,
    p.player_name,
    p.birthday,
    p.height,
    p.weight,
    -- Médias de atributos
    ROUND(AVG(pa.overall_rating), 2) AS media_overall_rating,
    ROUND(AVG(pa.potential), 2) AS media_potential,
    ROUND(AVG(pa.finishing), 2) AS media_finishing,
    ROUND(AVG(pa.dribbling), 2) AS media_dribbling,
    ROUND(AVG(pa.short_passing), 2) AS media_passing,
    ROUND(AVG(pa.marking), 2) AS media_defending,
    ROUND(AVG(pa.strength), 2) AS media_physical,
    ROUND(AVG(pa.sprint_speed), 2) AS media_speed,
    ROUND(AVG(pa.shot_power), 2) AS media_shooting,
    -- Estatísticas de partidas
    COUNT(DISTINCT mp.match_id) AS total_partidas,
    COUNT(DISTINCT mp.team_id) AS total_times_jogou,
    -- Informações adicionais
    pa.preferred_foot,
    pa.attacking_work_rate,
    pa.defensive_work_rate,
    -- Data da última atualização de atributos
    MAX(pa.date) AS ultima_atualizacao_atributos
FROM campeonato.player p
LEFT JOIN campeonato.player_attributes pa ON p.player_api_id = pa.player_api_id
LEFT JOIN campeonato.match_players mp ON p.id = mp.player_id
GROUP BY 
    p.id, 
    p.player_name, 
    p.birthday, 
    p.height, 
    p.weight,
    pa.preferred_foot,
    pa.attacking_work_rate,
    pa.defensive_work_rate;

-- Comentário da view
COMMENT ON VIEW campeonato.vw_estatisticas_jogadores IS 
'View consolidada com estatísticas completas dos jogadores incluindo médias de atributos e total de partidas'; 