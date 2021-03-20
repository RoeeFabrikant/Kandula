#!/bin/bash
set -e

sleep 120
### set consul version
echo 'CONSUL_VERSION="1.8.5"' >> /etc/environment
export CONSUL_VERSION="1.8.5"

echo "Grabbing IPs..."
echo "PRIVATE_IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)" >> /etc/environment
export PRIVATE_IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)

echo "Installing dependencies..."
apt-get update -y
apt-get install -y unzip dnsmasq

echo "Configuring dnsmasq..."
cat << EODMCF >/etc/dnsmasq.d/10-consul
# Enable forward lookup of the 'consul' domain:
server=/consul/127.0.0.1#8600
EODMCF

systemctl restart dnsmasq

cat << EOF >/etc/systemd/resolved.conf
[Resolve]
DNS=127.0.0.1
Domains=~consul
EOF

systemctl restart systemd-resolved.service

echo "Fetching Consul..."
cd /tmp
curl -Lo consul.zip "https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip"

echo "Installing Consul..."
unzip consul.zip >/dev/null
chmod +x consul
mv consul /usr/local/bin/consul

# Setup Consul
mkdir -p /opt/consul
mkdir -p /etc/consul.d
mkdir -p /run/consul
tee /etc/consul.d/config.json > /dev/null <<EOF
{
  "advertise_addr": "$PRIVATE_IP",
  "data_dir": "/opt/consul",
  "datacenter": "kandula",
  "encrypt": "uDBV4e+LbFW3019YKPxIrg==",
  "disable_remote_exec": true,
  "disable_update_check": true,
  "leave_on_terminate": true,
  "retry_join": ["provider=aws tag_key=consul_server tag_value=true"],
  "enable_script_checks": true,
  "server": false
}
EOF

# Create user & grant ownership of folders
useradd consul
chown -R consul:consul /opt/consul /etc/consul.d /run/consul


# Configure consul service
tee /etc/systemd/system/consul.service > /dev/null <<"EOF"
[Unit]
Description=Consul service discovery agent
Requires=network-online.target
After=network.target
[Service]
User=consul
Group=consul
PIDFile=/run/consul/consul.pid
Restart=on-failure
Environment=GOMAXPROCS=2
ExecStart=/usr/local/bin/consul agent -pid-file=/run/consul/consul.pid -config-dir=/etc/consul.d
ExecReload=/bin/kill -s HUP $MAINPID
KillSignal=SIGINT
TimeoutStopSec=5
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable consul.service
systemctl start consul.service

wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
    /etc/apt/sources.list.d/jenkins.list'
apt-get update -y
apt install openjdk-8-jdk -y
apt-get install jenkins -y
apt install docker.io -y
systemctl start docker
systemctl enable docker
usermod -aG docker ubuntu
apt-get update && sudo apt-get install -y apt-transport-https gnupg2 curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get install -y kubectl

# Install Helm
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
apt-get update -y
apt-get install helm

tee /etc/consul.d/jenkins-server.json > /dev/null <<"EOF"
{
  "service": {
    "id": "jenkins-server",
    "name": "jenkins-server",
    "port": 8080,
    "checks": [
      {
        "id": "tcp",
        "name": "TCP on port 8080",
        "tcp": "localhost:8080",
        "interval": "10s",
        "timeout": "1s"
      },
      {
        "id": "http",
        "name": "HTTP on port 8080",
        "http": "http://localhost:8080/login",
        "interval": "30s",
        "timeout": "1s"
      },
      {
        "id": "service",
        "name": "jenkins server service",
        "args": ["systemctl", "status", "jenkins.service"],
        "interval": "60s"
      }
    ]
  }
}
EOF

# Install NodeExporter

export node_exporter_ver="0.18.0"
wget \
  https://github.com/prometheus/node_exporter/releases/download/v$node_exporter_ver/node_exporter-$node_exporter_ver.linux-amd64.tar.gz \
  -O /tmp/node_exporter-$node_exporter_ver.linux-amd64.tar.gz

tar zxvf /tmp/node_exporter-$node_exporter_ver.linux-amd64.tar.gz
cp ./node_exporter-$node_exporter_ver.linux-amd64/node_exporter /usr/local/bin
useradd --no-create-home --shell /bin/false node_exporter
chown node_exporter:node_exporter /usr/local/bin/node_exporter
mkdir -p /var/lib/node_exporter/textfile_collector
chown node_exporter:node_exporter /var/lib/node_exporter
chown node_exporter:node_exporter /var/lib/node_exporter/textfile_collector
tee /etc/systemd/system/node_exporter.service &>/dev/null << EOF
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target
[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter --collector.textfile.directory /var/lib/node_exporter/textfile_collector \
 --no-collector.infiniband
[Install]
WantedBy=multi-user.target
EOF

rm -rf /tmp/node_exporter-$node_exporter_ver.linux-amd64.tar.gz \
  ./node_exporter-$node_exporter_ver.linux-amd64

systemctl daemon-reload
systemctl start node_exporter
systemctl enable node_exporter


consul reload
exit 0