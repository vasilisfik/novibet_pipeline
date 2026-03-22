# Setup Instructions

## 1. Clone the repository

git clone <your-repo-url>
cd novibet_pipeline

## 2. Create virtual environment

python -m venv .venv

## 3. Activate environment

Windows (PowerShell):
.venv\Scripts\Activate.ps1

## 4. Install dependencies

pip install -r requirements.txt

## 5. Run the pipeline

python scripts/run_pipeline.py

## Output

The final dataset is exported to:

novibet_project/exports/gold_casinodaily_aggr.parquet

## Orchestration Strategy

The pipeline is orchestrated using a Python script (`scripts/run_pipeline.py`).

The script:

- Executes the dbt pipeline using `dbt build`
- Runs all models and data quality tests
- Exports the final Gold dataset to Parquet

Execution is automated via Windows Task Scheduler, which triggers the script at scheduled intervals.

This approach keeps transformation logic within dbt, while Python handles execution and external steps such as exporting outputs.

## Bonus: Visualization & Big Data

To expose a 100M+ record Gold table to a visualization tool, I would design the solution around scalable storage, efficient query performance, and incremental data processing.

### Storage

I would store the data in a cloud data lake (e.g. Azure Data Lake Gen2) using a columnar format such as Parquet, ideally managed through Delta Lake. This allows efficient compression, partitioning (e.g. by p_date), and ACID transactions.

### Performance

For query performance, I would:

- Avoid views that trigger full recomputation on each query
- Persist the Gold layer as a materialized table (e.g. Delta table)
- Pre-aggregate data at the reporting grain
- Leverage partition pruning and columnar storage

### Compute

I would use a distributed compute engine such as Databricks to handle large-scale transformations and query workloads, allowing compute to scale independently from storage.

### Refresh Strategy

Data would be processed incrementally using a timestamp watermark (e.g. updated_timestamp):

- Only new or updated records are processed
- Downstream tables are updated incrementally
- BI tools can leverage incremental refresh where supported

### Scalability

As data volume grows:

- Compute can scale horizontally via the distributed engine
- Storage remains cost-efficient and scalable in the data lake
- Additional aggregated tables can be introduced for high-demand queries

## Optional: Querying the Data (DuckDB UI)

To explore the data locally using DuckDB UI:

1. Install DuckDB CLI  
   Download from: https://duckdb.org/docs/installation/

2. Activate the virtual environment:

.venv\Scripts\Activate.ps1

3. Open DuckDB UI:

duckdb "novibet_project/novibet.duckdb" -ui

This will open a local UI in the browser where queries can be executed against the database.
