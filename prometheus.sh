#!/bin/bash


wget https://github.com/prometheus/prometheus/releases/download/v2.16.0/prometheus-2.16.0.linux-amd64.tar.gz

tar -xvf /root/prometheus-2.16.0.linux-amd64.tar.gz /root/prometheus

sleep 2
useradd --no-create-home --shell /bin/false prometheus
mkdir /etc/prometheus
mkdir /var/lib/prometheus
chown prometheus:prometheus /etc/prometheus
chown prometheus:prometheus /var/lib/prometheus
chown -R prometheus:prometheus /root/prometheus/
cp  /root/prometheus/prometheus /bin/
cp /root/prometheus/promtool /bin/
cp -r /root/prometheus/consoles /etc/prometheus/
cp -r /root/prometheus/console_libraries /etc/prometheus/
cp  /root/prometheus/prometheus.yml /etc/prometheus/
touch /etc/systemd/system/prometheus.service
cat <<EOF >/etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target
 
[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries
 
[Install]
WantedBy=multi-user.target
EOF
sleep 2
systemctl daemon-reload
systemctl start prometheus.service
systemctl status prometheus.service



