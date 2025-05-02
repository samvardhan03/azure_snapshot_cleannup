@echo off
REM Setup script for Azure Snapshot Cleanup Tool

REM Create virtual environment
python -m venv venv

REM Activate virtual environment
call venv\Scripts\activate.bat

REM Install dependencies
pip install -r requirements.txt

echo Setup complete! Use the following to run the tool:
echo venv\Scripts\activate.bat
echo python scripts\azure_snapshot_cleanup.py --auth-method cli --dry-run