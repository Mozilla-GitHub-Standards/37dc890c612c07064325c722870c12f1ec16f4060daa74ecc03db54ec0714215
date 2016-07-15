#!/bin/bash
source loadtest.env && \
echo "Building loop.json" && \
cat > loop.json <<EOF
{
  "name": "Loop Testing",
  "plans": [

    {
      "name": "4 Servers",
      "description": "4 boxes",
      "steps": [
        {
          "name": "Test Cluster",
          "instance_count": 4,
          "instance_region": "us-east-1",
          "instance_type": "c4.8xlarge",
          "run_max_time": 600,
          "container_name": "natim/ailoads-loop:latest",
          "environment_data": [
            "LOOP_METRICS_STATSD_SERVER=$STATSD_HOST:$STATSD_PORT",
            "LOOP_SERVER_URL=https://loop.stage.mozaws.net:443",
            "LOOP_NB_USERS=100",
            "LOOP_DURATION=600",
            "LOOP_SP_URL=https://call.stage.mozaws.net/",
            "FXA_BROWSERID_ASSERTION=${FXA_BROWSERID_ASSERTION}"
          ],
          "dns_name": "testcluster.mozilla.org",
          "port_mapping": "8080:8090,8081:8081,3000:3000",
          "volume_mapping": "/var/log:/var/log/$RUN_ID:rw",
          "docker_series": "loop"
        }
      ]
    }
  ]
}
EOF
