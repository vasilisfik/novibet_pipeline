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
