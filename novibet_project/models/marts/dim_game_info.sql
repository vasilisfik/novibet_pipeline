with games as (SELECT * from {{ref('int_casinodaily_euro')}})

select distinct 
  game_id,
  game_name,
  provider_name,
  manufacturer_name
from games