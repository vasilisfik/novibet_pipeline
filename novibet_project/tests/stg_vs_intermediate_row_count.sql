WITH stg AS (
  SELECT COUNT(*) as cnt FROM {{ref('stg_casinodaily')}}
),

  intermediate AS (
    SELECT COUNT(*) as cnt FROM {{ref('int_casinodaily_euro')}}
  )

  SELECT * FROM stg, intermediate where stg.cnt <> intermediate.cnt