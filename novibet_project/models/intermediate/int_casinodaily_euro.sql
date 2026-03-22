with stg_casinodaily as (
  select * from {{ref('stg_casinodaily')}}
),
stg_currencyrates as (
  select * from {{ref('stg_currencyrates')}}
),
joined as (
select c.*,r.* from stg_casinodaily c
left join stg_currencyrates r
ON c.currency_id = r.to_currency_id and c.p_date = r.date
)
select 
  user_id,
  application_id,
  country_name,
  p_date,
  dense_rank() over (order by game_name, provider_name, manufacturer_name) as game_id,
  game_name,
  provider_name,
  manufacturer_name,
  coalesce (ggr * euro_rate, 0)  as ggr_euro,
  coalesce(returns * euro_rate, 0) as returns_euro,
  coalesce(turnover * euro_rate, 0) as turnover_euro,
  updated_timestamp
from joined