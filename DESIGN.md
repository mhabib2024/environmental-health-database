# Design Document

By Yasmina Habib

## Scope

The Environmental Health Database includes all entities necessary to track air quality measurements and pollution exposure across the United States. As such, included in the database's scope is:

* Geographic locations, including state and county information with standardized identifiers
* Air quality measures, which includes the name and type of each air quality indicator
* Air quality readings, including the measurement value, location, indicator type, and year

Out of scope are elements like real-time sensor data, water quality information, industrial pollution sources, individual health outcomes, and vulnerable population demographics.

## Functional Requirements

This database will support:

* CRUD operations for locations, measures, and air quality readings
* Querying air quality measurements by county, state, and year
* Identifying geographic areas with the highest pollution levels
* Analyzing trends in air quality over time
* Comparing air quality measurements across different locations and indicators

Note that in this iteration, the system will not support real-time data updates or individual sensor-level readings.

## Representation

Entities are captured in SQLite tables with the following schema.

### Entities

The database includes the following entities:

#### Locations

The `locations` table includes:

* `id`, which specifies the unique ID for the location as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `state_name`, which specifies the state name as `TEXT`. `TEXT` is used as it is the appropriate data type for string values like state names.
* `county_name`, which specifies the county name as `TEXT`. `TEXT` is used for the same reason as `state_name`.
* `county_fips`, which specifies the Federal Information Processing Standards code for the county as an `INTEGER`. The FIPS code is a standard numeric identifier that enables consistent geographic identification across different data sources.

All columns are required and hence have the `NOT NULL` constraint applied where a `PRIMARY KEY` is not.

#### Measures

The `measures` table includes:

* `id`, which specifies the unique ID for the measure as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `measure_name`, which specifies the name of the air quality indicator (e.g., "Number of days with maximum 8-hour average ozone concentration") as `TEXT`. `TEXT` is used to store the full descriptive name of the air quality measure.
* `measure_type`, which specifies the unit or type of measurement (e.g., "Counts" or "Micrograms per cubic meter") as `TEXT`. This helps clarify what the numeric values represent.

All columns are required and hence have the `NOT NULL` constraint applied where a `PRIMARY KEY` is not.

#### Readings

The `readings` table includes:

* `id`, which specifies the unique ID for the reading as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `location_id`, which specifies the location where the measurement was taken as an `INTEGER`. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `locations` table to ensure data integrity and that all readings are associated with valid locations.
* `measure_id`, which specifies which air quality measure was recorded as an `INTEGER`. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `measures` table to ensure that all readings are associated with valid air quality indicators.
* `year`, which specifies the year of the measurement as an `INTEGER`. Years are stored as integers for efficient sorting and querying by time period.
* `value`, which specifies the measured value for that indicator as `NUMERIC`. `NUMERIC` is used to accommodate decimal values that may result from air quality measurements or aggregated calculations.

All columns are required and hence have the `NOT NULL` constraint applied where a `PRIMARY KEY` or `FOREIGN KEY` constraint is not.

### Relationships

The relationships among the entities in the database are as follows:

* One location (county/state combination) is capable of having 0 to many readings. 0, if no air quality measurements have been recorded for that location, and many if multiple indicators have been measured in that location across multiple years. A reading is associated with one and only one location.
* One measure (air quality indicator) is capable of having 0 to many readings. 0, if that indicator has not been measured anywhere, and many if it has been measured in multiple locations and years. A reading is associated with one and only one measure.
* Through the `readings` table, locations and measures form a many-to-many relationship, allowing the database to store a complete history of which air quality indicators have been measured in which locations over time.

## Optimizations

Per the typical queries one might write on this database, it is common for users to access all readings for a particular county or to filter readings by a specific measure. For that reason, indexes are created on the `county_name` column to speed queries identifying a specific county and on the `measure_name` column to speed queries filtering by air quality indicator.

Similarly, it is common practice for a user to be concerned with viewing measurements from a particular location in a particular year. As such, a composite index is created on `location_id` and `year` in the `readings` table to speed queries retrieving a county's measurements for a specific year.

## Limitations

The current schema represents annual aggregate air quality measurements at the county level, derived from the CDC Environmental Health Tracking Network. It does not capture individual sensor readings or real-time data. Additionally, the database does not include health outcome data, water quality information, or industrial pollution sources. A more comprehensive environmental justice database might incorporate daily readings from individual monitoring stations, health outcome correlations by neighborhood, water contamination data, and information about major pollution sources in each area.
