select
    origin_country,
    count(distinct icao24) as unique_aircrafts,
    avg(speed_kmh) as avg_speed
from {{ ref('stg_flights') }}
group by 1
order by 2 desc