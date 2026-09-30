WITH TargetDates AS (
    SELECT 
        date_time,
        strftime('%Y', date_time) AS year,
        strftime('%m-%d', date_time) AS month_day,
        (CAST(temp AS REAL) - 273.15) AS temp_celsius,
        CAST(traffic_volume AS INTEGER) AS volume
    FROM Metro_Interstate_Traffic_Volume
    WHERE strftime('%Y', date_time) BETWEEN '2015' AND '2017'
),
HolidayClassification AS (
    SELECT *,
        CASE 
            WHEN month_day = '01-01' THEN "New Year's Day"
            -- Identifies Labor Day (First Monday of September)
            WHEN strftime('%m', date_time) = '09' 
                 AND strftime('%w', date_time) = '1' 
                 AND strftime('%d', date_time) BETWEEN '01' AND '07' 
            THEN "Labor Day"
            ELSE NULL 
        END AS holiday_name
    FROM TargetDates
)
SELECT 
    holiday_name,
    year,
    ROUND(AVG(temp_celsius), 1) AS avg_temp_celsius,
    ROUND(MIN(temp_celsius), 1) AS min_temp_celsius,
    ROUND(MAX(temp_celsius), 1) AS max_temp_celsius,
    SUM(volume) AS total_traffic_volume,
    ROUND(AVG(volume), 0) AS avg_hourly_traffic
FROM HolidayClassification
WHERE holiday_name IS NOT NULL
GROUP BY holiday_name, year
ORDER BY holiday_name DESC, year ASC;

-- observation: for new year's day, there may be a co-relation between traffic volume and average temp - 2016 was colder had lesser traffic, while 2017 was milder and had more traffic_volume
-- observation: for labour day,there is not much co-relation between the temperature patterns and traffic conditions, because the data is not conclusive.