WITH match_base AS (
    SELECT
        m.id AS match_id,
        m.date,
        m.season,
        m.stage,
        m.home_team_api_id,
        m.away_team_api_id,
        m.home_team_goal,
        m.away_team_goal,
        m.league_id,
        m.country_id
    FROM campeonato.match m
),

dim_home_team AS (
    SELECT
        team_api_id,
        team_long_name AS home_team_name,
        team_short_name AS home_team_short
    FROM campeonato.team
),

dim_away_team AS (
    SELECT
        team_api_id,
        team_long_name AS away_team_name,
        team_short_name AS away_team_short
    FROM campeonato.team
),

dim_league AS (
    SELECT
        l.id AS league_id,
        l.name AS league_name,
        c.name AS country_name
    FROM campeonato.league l
    JOIN campeonato.country c ON l.country_id = c.id
),

dim_season AS (
    SELECT
        season_name,
        year_start,
        year_end
    FROM campeonato.season
)

SELECT
    mb.match_id,
    mb.date,
    mb.season,
    s.year_start,
    s.year_end,
    mb.stage,
    ht.home_team_name,
    ht.home_team_short,
    at.away_team_name,
    at.away_team_short,
    mb.home_team_goal,
    mb.away_team_goal,
    dl.league_name,
    dl.country_name
FROM match_base mb
LEFT JOIN dim_home_team ht ON mb.home_team_api_id = ht.team_api_id
LEFT JOIN dim_away_team at ON mb.away_team_api_id = at.team_api_id
LEFT JOIN dim_league dl ON mb.league_id = dl.league_id
LEFT JOIN dim_season s ON mb.season = s.season_name
ORDER BY mb.date;
