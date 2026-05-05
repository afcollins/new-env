#!/usr/bin/env bash
ssh-keygen -t ed25519 -N "" -f ~/.ssh/id_ed25519

mkdir -p ~/.local/{bin,share/prometheus}
dnf install -y git vim tmux wget python3.12
# create tmux.conf

# Set up prometheus
wget https://github.com/prometheus/prometheus/releases/download/v3.11.3/prometheus-3.11.3.linux-amd64.tar.gz
tar -xf prometheus-3.11.3.linux-amd64.tar.gz
pushd prometheus-3.11.3.linux-amd64/
mv prometheus.yml ~/.local/share/prometheus
mv prometheus promtool ~/.local/bin/
popd

# Install grafana
wget https://dl.grafana.com/grafana/release/12.4.3/grafana_12.4.3_24388279614_linux_amd64.tar.gz
tar -zxf grafana_12.4.3_24388279614_linux_amd64.tar.gz

# Install prometheus checksum hacks for prow metricsballs
for i in promtool.skip-checksum-prow-metricsballs flush_wal.linux prometheus.skip-checksum-for-prow-metricsballs ; do
  wget https://storage.scalelab.redhat.com/ancollin/binaries/${i} -P ~/.local/bin/
done

# Install dust
curl -sSfL https://raw.githubusercontent.com/bootandy/dust/refs/heads/master/install.sh | sh
