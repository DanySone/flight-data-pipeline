with flights as (
    select * from {{ ref('stg_flights') }}
),

aggregated as (
    select
        origin_country,
        count(distinct icao24) as aircraft_count,
        round(avg(speed_kmh), 2) as avg_speed_kmh,
        count(case when on_ground = true then 1 end) as aircrafts_on_ground,
        max(position_updated_at) as last_data_update
    from flights
    group by 1
)

select 
    *,
    -- Petit calcul de ratio pour ton portfolio
    round(aircrafts_on_ground * 100.0 / nullif(aircraft_count, 0), 2) as pct_on_ground
from aggregated
order by aircraft_count desc