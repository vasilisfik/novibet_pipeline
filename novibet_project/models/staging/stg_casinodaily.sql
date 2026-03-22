WITH stg_casinodaily AS (
  SELECT * FROM {{ref('casinodaily')}}
)

SELECT 
  UpdatedTimestamp AS updated_timestamp,
  userid AS user_id,
  ApplicationId AS application_id,
  CountryName AS country_name,
  CurrencyId AS currency_id,
  p_Date AS p_date,
  GameName AS game_name,
  ProviderName AS provider_name,
  ManufacturerName AS manufacturer_name,
  GGR AS ggr,
  Returns AS returns,
  Turnover AS turnover

FROM stg_casinodaily