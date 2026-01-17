-- Find air quality readings for a specific county
SELECT r."year", m."measure_name", r."value"
FROM "readings" r
JOIN "measures" m ON r."measure_id" = m."id"
JOIN "locations" l ON r."location_id" = l."id"
WHERE l."county_name" = 'Clay'
AND l."state_name" = 'Alabama'
ORDER BY r."year";

-- Find the highest ozone readings across all counties in a given year
SELECT l."county_name", l."state_name", m."measure_name", r."value"
FROM "readings" r
JOIN "locations" l ON r."location_id" = l."id"
JOIN "measures" m ON r."measure_id" = m."id"
WHERE m."measure_name" LIKE '%ozone%'
AND r."year" = 1999
ORDER BY r."value" DESC
LIMIT 10;

-- Find counties with the most days exceeding air quality standards
SELECT l."county_name", l."state_name", AVG(r."value") AS "avg_days_exceeding"
FROM "readings" r
JOIN "locations" l ON r."location_id" = l."id"
JOIN "measures" m ON r."measure_id" = m."id"
WHERE m."measure_name" LIKE '%ozone%'
GROUP BY l."county_name", l."state_name"
ORDER BY "avg_days_exceeding" DESC;

-- Find air quality trends for a county over time
SELECT r."year", r."value"
FROM "readings" r
JOIN "locations" l ON r."location_id" = l."id"
JOIN "measures" m ON r."measure_id" = m."id"
WHERE l."county_name" = 'Los Angeles'
AND l."state_name" = 'California'
AND m."measure_name" LIKE '%ozone%'
ORDER BY r."year";

-- Add a new location
INSERT INTO "locations" ("state_name", "county_name", "county_fips")
VALUES ('Texas', 'Harris', 4800);

-- Add a new measure/indicator
INSERT INTO "measures" ("measure_name", "measure_type")
VALUES ('PM2.5 Annual Average', 'Micrograms per cubic meter');

-- Add new air quality reading
INSERT INTO "readings" ("location_id", "measure_id", "year", "value")
VALUES (1, 1, 2023, 45);

-- Find all measures available in the database
SELECT DISTINCT "measure_name", "measure_type"
FROM "measures"
ORDER BY "measure_name";

-- Count readings by state
SELECT l."state_name", COUNT(*) AS "reading_count"
FROM "readings" r
JOIN "locations" l ON r."location_id" = l."id"
GROUP BY l."state_name"
ORDER BY "reading_count" DESC;
