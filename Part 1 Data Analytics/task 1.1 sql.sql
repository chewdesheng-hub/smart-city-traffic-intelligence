WITH YearlyTraffic AS (
    SELECT 
        strftime('%Y', date_time) AS traffic_year,
        SUM(CAST(traffic_volume AS INTEGER)) AS total_volume
    FROM Metro_Interstate_Traffic_Volume
    WHERE strftime('%Y', date_time) BETWEEN '2012' AND '2017'
    GROUP BY traffic_year
),
Trends AS (
    SELECT 
        traffic_year,
        total_volume,
        LAG(total_volume) OVER (ORDER BY traffic_year) AS previous_year_volume
    FROM YearlyTraffic
)
SELECT 
    traffic_year,
    total_volume,
    CASE 
        WHEN previous_year_volume IS NULL THEN 'N/A (Base Year)'
        WHEN total_volume > previous_year_volume THEN 'Increase 📈'
        WHEN total_volume < previous_year_volume THEN 'Decrease 📉'
        ELSE 'No Change'
    END AS trend,
    (total_volume - previous_year_volume) AS absolute_change,
    ROUND(((total_volume - previous_year_volume) * 100.0 / previous_year_volume), 2) || '%' AS percentage_change
FROM Trends
ORDER BY traffic_year ASC;

-- observations: the sharp increase from 2012 to 2013 is because 2012's data is not a full year of data as it only started in october</sql><sql name="task 1.3">WITH TargetDates AS (