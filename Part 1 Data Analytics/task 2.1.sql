WITH OrderedTraffic AS (
    SELECT 
        CAST(traffic_volume AS REAL) AS vol,
        ROW_NUMBER() OVER (ORDER BY CAST(traffic_volume AS INTEGER)) AS row_num,
        COUNT(*) OVER () AS total_rows
    FROM Metro_Interstate_Traffic_Volume
),
Stats AS (
    SELECT 
        AVG(vol) AS mean_vol,
        MAX(vol) - MIN(vol) AS range_vol
    FROM OrderedTraffic
),
MedianCalc AS (
    SELECT AVG(vol) AS median_vol
    FROM OrderedTraffic
    WHERE row_num BETWEEN total_rows/2.0 AND total_rows/2.0 + 1
),
VarianceCalc AS (
    SELECT 
        AVG((vol - (SELECT mean_vol FROM Stats)) * (vol - (SELECT mean_vol FROM Stats))) AS var_vol
    FROM OrderedTraffic
)
SELECT 
    ROUND((SELECT mean_vol FROM Stats), 2) AS Mean,
    ROUND((SELECT median_vol FROM MedianCalc), 2) AS Median,
    ROUND((SELECT var_vol FROM VarianceCalc), 2) AS Variance,
    ROUND(SUBSTR(SQRT((SELECT var_vol FROM VarianceCalc)), 1, 8), 2) AS Standard_Deviation,
    (SELECT range_vol FROM Stats) AS Range;
