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
for i in start_prometheus.sh promtool.skip-checksum-prow-metricsballs flush_wal.linux prometheus.skip-checksum-for-prow-metricsballs ; do
  wget --no-check-certificate https://storage.scalelab.redhat.com/ancollin/binaries/${i} -P ~/.local/bin/
done
chmod +x ~/.local/bin/*

# Install dust
curl -sSfL https://raw.githubusercontent.com/bootandy/dust/refs/heads/master/install.sh | sh

# Install magic-monty bash-git-prompt
git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt --depth=1
cat << EOF >> ~/.bashrc
if [ -f "$HOME/.bash-git-prompt/gitprompt.sh" ]; then
    GIT_PROMPT_ONLY_IN_REPO=1
    source "$HOME/.bash-git-prompt/gitprompt.sh"
fi
EOF

# Other things to add back
#
# /root:
# git
# go
# go1.26.2.linux-amd64.tar.gz
# openshift-client-linux-amd64-rhel9-4.22.0-rc.1.tar.gz
# recording-rules
# series.json
# setup-interfaces.sh
# update-latest-rhel-release.sh
#
# TODO Add aliases to bashrc
# alias dirs='dirs -p'
# alias jd='echo "## jobs ##" ; jobs ; echo "## dirs ##" ; dirs -p '
# alias sshstorage='ssh ancollin@shell.storage.scalelab.redhat.com'
#
# TODO Configure global ~/.config/git/ignore
#
#23:31 # cat set_env.sh
#!/bin/bash
#export KUBECONFIG=/root/ancollin/.vlan602.kubeconfig
#export KUBE_BURNER_OCP=/root/ancollin/.kube-burner-ocp
#alias kube-burner-ocp=/root/ancollin/.kube-burner-ocp
#alias ochub='oc --kubeconfig=/root/sno/hub/kubeconfig'
#
#export DFMT='%F-%H%M%S'
#
#function getnodes() {
#  local now=$(date +"$DFMT")
#  oc get nodes -o wide -A $1 > oc_g_nodes.${now}.wide
#}
#
#function getpods() {
#  local now=$(date +"$DFMT")
#  oc get pods -o wide -A $1 > oc_g_pods.${now}.wide
#}
#function getpodspvc() {
#  local now=$(date +"$DFMT")
#  oc get pods -o yaml -n pvc-density $1 > oc_g_pods_-npvc-density.${now}.yaml
#}
#function getsnrpvc() {
#  local now=$(date +"$DFMT")
#  oc get snr -o yaml -n openshift-workload-availability  $1 > oc_g_snr.${now}.yaml
#}

# Get pods
# alias getsnrcm="oc get po -n openshift-workload-availability -l self-node-remediation-operator"
# alias getnhccm="oc get po -n openshift-workload-availability -l app.kubernetes.io/component=controller-manager"
# alias getleases="oc  -n openshift-workload-availability get lease -ocustom-columns=HOLDER:.spec.holderIdentity"
#
#function logsnhcleader() {
#  local leader=$(getleases | grep healthcheck | cut -d '_' -f 1)
#  local now=$(date +"$DFMT")
#  oc logs -n openshift-workload-availability $leader > logs.${leader}.${now}.log
#}
#function logssnrcm() {
#  local leader=$(getleases | grep remediation | cut -d '_' -f 1)
#  local now=$(date +"$DFMT")
#  oc logs -n openshift-workload-availability $leader > logs.${leader}.${now}.log
#}
#
#alias debuginfra0='oc debug node/e31-h06-000-r640'
#alias debuginfra1='oc debug node/e31-h01-000-r640'
#
#describe-node() {
#  local node="$1"
#  if [[ -z "$node" ]]; then
#    echo "Usage: describe-node <node>" >&2
#    return 1
#  fi
#  oc describe nodes $node > oc_d_nodes.${node}.$( date +"%F-%H%M" ).describe.txt
#}
#
#GIT_PROMPT_ONLY_IN_REPO=1
#source "$HOME/ancollin/.bash-git-prompt/gitprompt.sh"
