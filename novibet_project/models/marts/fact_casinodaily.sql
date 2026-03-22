{{ config(
    materialized='incremental',
    incremental_strategy='delete+insert',
    unique_key=[
      'user_id',
      'application_id',
      'country_name',
      'p_date',
      'game_id'
    ]
) }}

with casino as (
    select *
    from {{ ref('int_casinodaily_euro') }}

    {% if is_incremental() %}
    where updated_timestamp > (
        select 
            max(updated_timestamp)
        from {{ this }}
    )
    {% endif %}
),

users as (
    select *
    from {{ ref('dim_users') }}
)

select 
    c.user_id,
    c.application_id,
    c.country_name,
    c.p_date,
    c.game_id,
    u.vip_sysname,
    c.ggr_euro,
    c.returns_euro,
    c.turnover_euro,
    c.updated_timestamp
from casino c
left join users u 
    on c.user_id = u.user_profile_id
   and c.p_date >= u.valid_from_date
   and c.p_date < coalesce(u.valid_to_date, cast('2099-12-31' as date))