{{ config(
    materialized='incremental',
    incremental_strategy='delete+insert',
    unique_key=[
      'application_id',
      'country_name',
      'vip_sysname',
      'currency_sysname',
      'p_date',
      'game_name',
      'provider_name',
      'manufacturer_name'
    ]
) }}

with fact_casino as (
    select * from {{ ref('fact_casinodaily') }}
),

game_info as (
    select * from {{ ref('dim_game_info') }}
),

base as (
    select
        c.updated_timestamp,
        c.application_id,
        c.country_name,
        c.vip_sysname,
        'EUR' as currency_sysname,
        c.p_date,
        g.game_name,
        g.provider_name,
        g.manufacturer_name,
        c.ggr_euro,
        c.turnover_euro,
        c.returns_euro
    from fact_casino c
    left join game_info g
        on c.game_id = g.game_id

    {% if is_incremental() %}
    where c.updated_timestamp > (
        select 
            max(updated_timestamp)
        from {{ this }}
    )
    {% endif %}
),

final as (
    select
        max(updated_timestamp) as updated_timestamp,
        application_id,
        country_name,
        vip_sysname,
        currency_sysname,
        p_date,
        game_name,
        provider_name,
        manufacturer_name,
        sum(ggr_euro) as ggr,
        sum(turnover_euro) as turnover,
        sum(returns_euro) as returns
    from base
    group by
        application_id,
        country_name,
        vip_sysname,
        currency_sysname,
        p_date,
        game_name,
        provider_name,
        manufacturer_name
)

select *
from final