#!/bin/bash

set -ex

cd cesium_web
docker build -t cesium/web .

# Run tests before uploading
(cd docker-compose && docker-compose up &)
echo "Sleeping for 60 seconds while server starts"
sleep 60

echo -e "server:\n  url: http://localhost:9000" > cesium-docker.yaml
PYTHONPATH=. xvfb-run -a pytest -v cesium_app/tests/frontend/test_pipeline_sequentially.py
