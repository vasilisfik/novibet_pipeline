WITH stg_currencyrates AS (
  SELECT * FROM {{ref('currencyrates')}}
)

SELECT 
  Date AS date,
  FromCurrencyId AS from_currency_id,
  ToCurrencyId AS to_currency_id,
  ToCurrencySysname AS to_currency_sysname,
  EuroRate AS euro_rate

FROM stg_currencyrates