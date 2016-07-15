#!/bin/bash
source loadtest.env && \
echo "Building loop.json" && \
cat > loop.json <<EOF
{
  "name": "Sync Storage Testing",
  "plans": [

    {
      "name": "4 Servers",
      "description": "4 boxes",
      "steps": [
        {
          "name": "Test Cluster",
          "instance_count": 4,
          "instance_region": "us-east-1",
          "instance_type": "m4.large",
          "run_max_time": 14400,
          "container_name": "mozservicesqa/ailoads-syncstorage:latest",
          "environment_data": [
            "SYNCSTORAGE_SERVER_URL=https://token.stage.mozaws.net:443",
            "SYNCSTORAGE_NB_USERS=80",
            "SYNCSTORAGE_DURATION=1800"
          ],
          "dns_name": "sync-test.mozilla.org",
          "port_mapping": "8080:8090,8081:8081,3000:3000",
          "volume_mapping": "/var/log:/var/log/$RUN_ID:rw",
          "docker_series": "syncstorage"
        }
      ]
    }
  ]
}
EOF
