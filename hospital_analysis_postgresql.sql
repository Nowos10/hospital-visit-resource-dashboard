CREATE TABLE hospital_visits (
    Patient_ID INT,
    Visit_Timestamp TIMESTAMP,
    Department VARCHAR(50),
    Wait_Time_Minutes INT,
    Length_of_Stay_Hours FLOAT,
    Resource_Used VARCHAR(50),
    Outcome VARCHAR(20),
    Hospital_Location VARCHAR(100)
);

SELECT *
FROM hospital_visits;

-- 1. Peak Hour of Visits by Hospital Location
SELECT 
    "hospital_location",
    EXTRACT(HOUR FROM "visit_timestamp") AS visit_hour,
    COUNT(*) AS visit_count
FROM hospital_visits
GROUP BY "hospital_location", visit_hour
ORDER BY "hospital_location", visit_count DESC;

-- 2. Average Wait Time by Department
SELECT 
    "department",
    ROUND(AVG("wait_time_minutes")::numeric, 2) AS avg_wait_time
FROM hospital_visits
GROUP BY "department"
ORDER BY avg_wait_time DESC;

-- 3. Most Frequently Used Resources by Department
SELECT 
    "department",
    "resource_used",
    COUNT(*) AS usage_count
FROM hospital_visits
GROUP BY "department", "resource_used"
ORDER BY "department", usage_count DESC;

-- 4. Admission Rates by Hospital
SELECT 
    "hospital_location",
    COUNT(*) AS total_visits,
    SUM(CASE WHEN "outcome" = 'Admitted' THEN 1 ELSE 0 END) AS admissions,
    ROUND(SUM(CASE WHEN "outcome" = 'Admitted' THEN 1 ELSE 0 END)::decimal / COUNT(*) * 100, 2) AS admission_rate_percent
FROM hospital_visits
GROUP BY "hospital_location"
ORDER BY admission_rate_percent DESC;

-- 5. Top 10 Longest Wait Times
SELECT 
    "patient_id",
    "department",
    "hospital_location",
    "wait_time_minutes",
    "visit_timestamp"
FROM hospital_visits
ORDER BY "wait_time_minutes" DESC
LIMIT 10;

-- 6. Monthly Visit Trends
SELECT 
    TO_CHAR("visit_timestamp", 'YYYY-MM') AS visit_month,
    COUNT(*) AS total_visits
FROM hospital_visits
GROUP BY visit_month
ORDER BY visit_month;
