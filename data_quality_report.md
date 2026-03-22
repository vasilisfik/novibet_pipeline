## Data Quality Report

### Overview

Data quality checks were implemented to ensure integrity, consistency, and correct joins across the pipeline.

### Checks Implemented

- Not null checks on key fields (e.g. updated_timestamp, game_id)
- Uniqueness of dim_game_info.game_id
- Referential integrity between fact_casinodaily and dim_game_info
- VIP values validated using accepted_values
- Row count consistency between staging → intermediate → fact

### Findings

- No row duplication or data loss across layers
- VIP values are within expected categories since nulls exist in source data

### Decisions

- Null VIP values were allowed (present in source, no business rule provided)
- GGR consistency was not enforced, as it does not hold in the dataset
