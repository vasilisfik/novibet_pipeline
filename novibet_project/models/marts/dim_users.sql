with users_effective_dates as (
  select user_profile_id,
        application_id,
        vip_sysname,
        country_name,
        date as valid_from_date,
        LEAD(date) OVER (PARTITION BY user_profile_id ORDER BY date) as valid_to_date
  from {{ref('stg_users')}} 
), current_users_flag AS (
  SELECT *,
        CASE 
            WHEN valid_to_date IS NULL THEN 1
            ELSE 0
         END AS is_current
  FROM users_effective_dates     
)

select *
from current_users_flag