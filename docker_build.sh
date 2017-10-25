#!/bin/bash

set -ex

cd cesium_web
docker build -t cesium/web .

# Run tests before uploading
docker-compose up &
# TODO this can be reduced to ~15s once `run_production` is changed to skip `npm install`
echo "Sleeping for 180 seconds while server starts"
sleep 180

echo -e "\nports:\n    app: 9000" >> test_config.yaml
PYTHONPATH=. xvfb-run -a pytest -v cesium_app/tests/frontend/test_pipeline_sequentially.py
