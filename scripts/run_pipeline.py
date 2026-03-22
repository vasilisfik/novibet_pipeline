from __future__ import annotations

import subprocess
import sys
from datetime import datetime
from pathlib import Path

import duckdb


ROOT_DIR = Path(__file__).resolve().parent.parent
DBT_PROJECT_DIR = ROOT_DIR / "novibet_project"
EXPORT_DIR = DBT_PROJECT_DIR / "exports"
LOG_DIR = ROOT_DIR / "logs"

DUCKDB_FILE = DBT_PROJECT_DIR / "novibet.duckdb"
GOLD_TABLE = "main_gold.gold_casinodaily_aggr"
EXPORT_FILE = EXPORT_DIR / "gold_casinodaily_aggr.parquet"

VENV_SCRIPTS_DIR = ROOT_DIR / ".venv" / "Scripts"
DBT_EXE = VENV_SCRIPTS_DIR / "dbt.exe"


def log(message: str) -> None:
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    formatted = f"[{timestamp}] {message}"
    print(formatted)

    LOG_DIR.mkdir(parents=True, exist_ok=True)
    log_file = LOG_DIR / "pipeline.log"
    with log_file.open("a", encoding="utf-8") as f:
        f.write(formatted + "\n")


def run_command(command: list[str], cwd: Path) -> None:
    log(f"Running: {' '.join(str(c) for c in command)}")
    result = subprocess.run(command, cwd=cwd, shell=False)
    if result.returncode != 0:
        raise RuntimeError(
            f"Command failed with exit code {result.returncode}: {' '.join(str(c) for c in command)}"
        )


def ensure_directories() -> None:
    EXPORT_DIR.mkdir(parents=True, exist_ok=True)
    LOG_DIR.mkdir(parents=True, exist_ok=True)


def export_gold_table() -> None:
    log(f"Exporting {GOLD_TABLE} to {EXPORT_FILE}")
    conn = duckdb.connect(str(DUCKDB_FILE))
    try:
        conn.execute(
            f"""
            copy (
                select *
                from {GOLD_TABLE}
            ) to '{EXPORT_FILE.as_posix()}' (format parquet)
            """
        )
    finally:
        conn.close()


def main() -> int:
    try:
        ensure_directories()

        log("Starting pipeline")
        log(f"Using dbt executable: {DBT_EXE}")

        run_command([str(DBT_EXE), "build"], cwd=DBT_PROJECT_DIR)

        export_gold_table()

        log("Pipeline completed successfully")
        return 0

    except Exception as exc:
        log(f"Pipeline failed: {exc}")
        return 1


if __name__ == "__main__":
    sys.exit(main())