WITH Probabilities AS (
    SELECT 
        COUNT(*) AS total_hours,
        SUM(CASE WHEN CAST(traffic_volume AS INTEGER) > 5500 THEN 1 ELSE 0 END) AS congestion_hours,
        SUM(CASE WHEN weather_main = 'Clear' THEN 1 ELSE 0 END) AS clear_hours,
        SUM(CASE WHEN CAST(traffic_volume AS INTEGER) > 5500 AND weather_main = 'Clear' THEN 1 ELSE 0 END) AS both_hours
    FROM Metro_Interstate_Traffic_Volume
)
SELECT 
    -- P(Congestion)
    ROUND(CAST(congestion_hours AS REAL) / total_hours, 4) AS P_Congestion,
    -- P(Clear Weather)
    ROUND(CAST(clear_hours AS REAL) / total_hours, 4) AS P_Clear_Weather,
    -- P(Congestion AND Clear Weather)
    ROUND(CAST(both_hours AS REAL) / total_hours, 4) AS P_Congestion_AND_Clear_Weather
FROM Probabilities;
