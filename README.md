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
