#!/bin/bash

set -ex

cd cesium_web
docker build -t cesium/web .

cat <<EOF > cesium.yaml
server:
    url: http://localhost:9000
    multi_user: True
    auth:
       debug_login: True
EOF

# Run tests before uploading
(cd docker-compose && docker-compose up &)
echo "Sleeping for 60 seconds while server starts"
sleep 60

PYTHONPATH=. xvfb-run -a pytest -v cesium_app/tests/frontend/test_pipeline_sequentially.py
