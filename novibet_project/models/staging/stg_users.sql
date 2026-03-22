WITH stg_users AS (
  SELECT * FROM {{ref('users')}}
)

SELECT 
  UserProfileId AS user_profile_id,
  ApplicationId AS application_id,
  VIPSysname AS vip_sysname,
  CountryName AS country_name,
  Date AS date
FROM stg_users