set -euo pipefail

# Bluetui
VER=$(basename $(curl -Ls -o /dev/null -w %{url_effective} https://github.com/pythops/bluetui/releases/latest)) && curl -fLs https://github.com/pythops/bluetui/releases/download/${VER}/bluetui-x86_64-linux-gnu  -o /tmp/bluetui
cp /tmp/bluetui /usr/bin/bluetui
chmod 0755 /usr/bin/bluetui
rm /tmp/bluetui
# Extest
mkdir -p /usr/lib/extest
VER=$(basename $(curl -Ls -o /dev/null -w %{url_effective} https://github.com/ublue-os/extest/releases/latest)) && curl -fLs https://github.com/ublue-os/extest/releases/download/${VER}/libextest.so -o /tmp/libextest.so
cp /tmp/libextest.so /usr/lib/extest/libextest.so
rm /tmp/libextest.so      
# Just
VER=$(basename $(curl -Ls -o /dev/null -w %{url_effective} https://github.com/casey/just/releases/latest)) && curl -fLs --create-dirs https://github.com/casey/just/releases/download/${VER}/just-${VER}-x86_64-unknown-linux-musl.tar.gz -o /tmp/just-x86_64-unknown-linux-musl.tar.gz
mkdir -p /tmp/just
tar -xzf /tmp/just-x86_64-unknown-linux-musl.tar.gz -C /tmp/just/
cp /tmp/just/just /usr/bin/just
chmod 0755 /usr/bin/just
cp /tmp/just/completions/just.bash /usr/share/bash-completion/completions/just
cp /tmp/just/completions/just.fish /usr/share/fish/completions/just.fish
rm /tmp/just-x86_64-unknown-linux-musl.tar.gz
rm -r /tmp/just/
dnf clean all