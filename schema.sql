-- Represent geographic locations (counties)
CREATE TABLE "locations" (
    "id" INTEGER,
    "state_name" TEXT NOT NULL,
    "county_name" TEXT NOT NULL,
    "county_fips" INTEGER NOT NULL,
    PRIMARY KEY("id")
);

-- Represent air quality measures/indicators
CREATE TABLE "measures" (
    "id" INTEGER,
    "measure_name" TEXT NOT NULL,
    "measure_type" TEXT NOT NULL,
    PRIMARY KEY("id")
);

-- Represent air quality readings by location and year
CREATE TABLE "readings" (
    "id" INTEGER,
    "location_id" INTEGER NOT NULL,
    "measure_id" INTEGER NOT NULL,
    "year" INTEGER NOT NULL,
    "value" NUMERIC NOT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY("location_id") REFERENCES "locations"("id"),
    FOREIGN KEY("measure_id") REFERENCES "measures"("id")
);

-- Create indexes for common searches
CREATE INDEX "location_county" ON "locations" ("county_name");
CREATE INDEX "location_state" ON "locations" ("state_name");
CREATE INDEX "measure_name" ON "measures" ("measure_name");
CREATE INDEX "reading_location_year" ON "readings" ("location_id", "year");
CREATE INDEX "reading_measure" ON "readings" ("measure_id");
