WITH mart AS (
  SELECT COUNT(*) as cnt FROM {{ref('fact_casinodaily')}}
),

  intermediate AS (
    SELECT COUNT(*) as cnt FROM {{ref('int_casinodaily_euro')}}
  )

  SELECT * FROM mart, intermediate where mart.cnt <> intermediate.cnt