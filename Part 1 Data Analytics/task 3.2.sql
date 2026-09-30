WITH Baseline AS (
    SELECT
        COUNT(*) AS total_hours,
        SUM(CASE WHEN CAST(traffic_volume AS INTEGER) > 5500 THEN 1 ELSE 0 END) AS congestion_hours,
        SUM(CASE WHEN weather_main = 'Clear' THEN 1 ELSE 0 END) AS clear_hours,
        SUM(CASE WHEN weather_main = 'Clouds' THEN 1 ELSE 0 END) AS cloudy_hours,
        SUM(CASE WHEN CAST(temp AS REAL) > 292 THEN 1 ELSE 0 END) AS high_temp_hours,
        SUM(CASE WHEN CAST(traffic_volume AS INTEGER) > 5500 AND weather_main = 'Clear' THEN 1 ELSE 0 END) AS clear_and_congested,
        SUM(CASE WHEN CAST(traffic_volume AS INTEGER) > 5500 AND CAST(temp AS REAL) > 292 THEN 1 ELSE 0 END) AS high_temp_and_congested,
        SUM(CASE WHEN CAST(traffic_volume AS INTEGER) > 5500 AND weather_main = 'Clouds' THEN 1 ELSE 0 END) AS cloudy_and_congested
    FROM Metro_Interstate_Traffic_Volume
    WHERE temp > 100 -- Excludes baseline data entry errors
)
SELECT
    -- Conditional Probabilities
    ROUND(CAST(clear_and_congested AS REAL) / congestion_hours, 4) AS P_Clear_Given_Congestion,
    ROUND(CAST(high_temp_and_congested AS REAL) / congestion_hours, 4) AS P_HighTemp_Given_Congestion,
    
    -- Independence Testing Metrics
    ROUND(CAST(clear_and_congested AS REAL) / total_hours, 4) AS P_Intersection_Clear_Congestion,
    ROUND((CAST(clear_hours AS REAL) / total_hours) * (CAST(congestion_hours AS REAL) / total_hours), 4) AS P_Clear_Times_P_Congestion,
    
    -- Odds Ratio (Clear vs Cloudy)
    ROUND(
        (CAST(clear_and_congested AS REAL) / (clear_hours - clear_and_congested)) / 
        (CAST(cloudy_and_congested AS REAL) / (cloudy_hours - cloudy_and_congested)), 
        4
    ) AS Odds_Ratio_Clear_vs_Cloudy
FROM Baseline;
