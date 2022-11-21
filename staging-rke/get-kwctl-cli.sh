#!/bin/bash
VERSION=v1.3.1
curl -L -o kwctl-linux-x86_64.zip https://github.com/kubewarden/kwctl/releases/download/$VERSION/kwctl-linux-x86_64.zip
unzip kwctl-linux-x86_64.zip
cp -av kwctl-linux-x86_64 /usr/local/bin/kwctl
chmod +x /usr/local/bin/kwctl
rm -rf kwctl-linux-x86_64*
kwctl completions --shell bash >> /usr/share/bash-completion/completions/kwctl
chmod 644 /usr/share/bash-completion/completions/kwctl
