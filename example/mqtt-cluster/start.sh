# Copyright 2023 RobustMQ Team
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


sh example/mqtt-cluster/stop.sh

start_pc_cluster(){

    nohup cargo run --package cmd --bin placement-center -- --conf=example/mqtt-cluster/placement-center/node-1.toml 2>/tmp/1.log &
    nohup cargo run --package cmd --bin placement-center -- --conf=example/mqtt-cluster/placement-center/node-2.toml 2>/tmp/2.log &
    nohup cargo run --package cmd --bin placement-center -- --conf=example/mqtt-cluster/placement-center/node-3.toml 2>/tmp/3.log &
    sleep 3

    no1=`ps -ef | grep placement-center  | grep node-1 | grep -v grep | awk '{print $2}'`
    if [[ -n $no1 ]]
    then
        echo "placement-center node 1 started successfully. process no: $no1"
    fi

    no2=`ps -ef | grep placement-center  | grep node-2 | grep -v grep | awk '{print $2}'`
    if [[ -n $no2 ]]
    then
        echo "placement-center node 2 started successfully. process no: $no2"
    fi

    no3=`ps -ef | grep placement-center  | grep node-3 | grep -v grep | awk '{print $2}'`
    if [[ -n $no3 ]]
    then
        echo "placement-center node 3 started successfully. process no: $no3"
    fi

    sleep 5

    echo "\nNode 1:"
    resp1=$(curl -s http://127.0.0.1:1227/v1/cluster/status)
    echo ${resp1}
    role=$(echo $resp1 | jq -r '.data.Ok.state')
    echo "Role:"${role}
    echo ${resp1}

    echo "\n-------------------------------------\n"

    echo "\nNode 2:"
    resp2=$(curl -s http://127.0.0.1:2227/v1/cluster/status)
     echo ${resp2}
    role=$(echo $resp2 | jq -r '.data.Ok.state')
    echo "Role:"${role}
    echo ${resp2}

    echo "\n-------------------------------------\n"
    echo "\nNode 3:"
    resp3=$(curl -s http://127.0.0.1:3227/v1/cluster/status)
     echo ${resp3}
    role=$(echo $resp3 | jq -r '.data.Ok.state')
    echo "Role:"${role}
    echo ${resp3}

    echo "\n-------------------------------------\n"

    membership=$(echo $resp3 | jq -r '.data.Ok.membership_config.membership.configs[0]')
    nodes=$(echo $resp3 | jq -r '.data.Ok.membership_config.membership.nodes')
    current_leader=$(echo $resp3 | jq -r '.data.Ok.current_leader')
    echo "Placement Center cluster Leader: "${current_leader}
    echo "Placement Center cluster Members: "${membership}
    echo "Placement Center cluster Nodes: "${nodes}
}

start_mqtt_cluster(){
    nohup cargo run --package cmd --bin mqtt-server -- --conf=example/mqtt-cluster/mqtt-server/node-1.toml 2>/tmp/4.log &
    
    no1=`ps -ef | grep mqtt-server  | grep node-1 | grep -v grep | awk '{print $2}'`
    if [[ -n $no1 ]]
    then
        echo "placement-center node 1 started successfully. process no: $no1"
    fi

    echo "\n-------------------------------------\n"
    
    cargo run --package cmd --bin cli-command-mqtt
}

start_pc_cluster

sleep 3

start_mqtt_cluster