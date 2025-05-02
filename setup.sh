
# Setup script for Azure Snapshot Cleanup Tool

# Create virtual environment
python -m venv venv

# Activate virtual environment
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

echo "Setup complete! Use the following to run the tool:"
echo "source venv/bin/activate"
echo "python scripts/azure_snapshot_cleanup.py --auth-method cli --dry-run"