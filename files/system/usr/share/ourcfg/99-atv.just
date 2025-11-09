atv-configure:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "git clone https://github.com/askpng/waydroid_script.git --depth 1 /tmp/waydroid_script"
    git clone https://github.com/askpng/waydroid_script.git --depth 1 /tmp/waydroid_script
    echo "python3 -m venv /tmp/waydroid_script/venv"
    python3 -m venv /tmp/waydroid_script/venv
    echo "source /tmp/waydroid_script/venv/bin/activate"
    source /tmp/waydroid_script/venv/bin/activate
    echo "sudo /tmp/waydroid_script/venv/bin/pip install -r /tmp/waydroid_script/requirements.txt"
    sudo /tmp/waydroid_script/venv/bin/pip install -r /tmp/waydroid_script/requirements.txt
    echo "/tmp/waydroid_script/venv/bin/python3 /tmp/waydroid_script/main.py"
    sudo /tmp/waydroid_script/venv/bin/python3 /tmp/waydroid_script/main.py
    echo "deactivate"
    deactivate
    echo "sudo rm -rf /tmp/waydroid_script"
    sudo rm -rf /tmp/waydroid_script ~/.cache/waydroid_script

atv-reset:
    #!/usr/bin/env bash
    bash -c 'sudo rm -rf /var/lib/waydroid /home/.waydroid ~/waydroid ~/.share/waydroid ~/.local/share/applications/*aydroid* ~/.local/share/waydroid /etc/waydroid-extra'
    sudo systemctl disable --now waydroid-container.service
    echo "Waydroid has been reset! Re-initialize to get it back up and running."

atv-init:
    #!/usr/bin/env bash
    set -euo pipefail
    VERSION=$(curl https://api.github.com/repos/supechicken/waydroid-androidtv-build/releases/latest | grep tag_name | cut -d : -f2 | tr -d "v\", ")
    mkdir -p /tmp/waydroid
    sudo mkdir -p /etc/waydroid-extra/images/
    curl -L "https://github.com/supechicken/waydroid-androidtv-build/releases/latest/download/lineage-20.0-$VERSION-UNOFFICIAL-WayDroidATV_x86_64.zip" -o /tmp/waydroid.zip
    7zz x /tmp/waydroid.zip -o/tmp/waydroid
    sudo cp /tmp/waydroid/system.img /etc/waydroid-extra/images/system.img
    sudo cp /tmp/waydroid/vendor.img /etc/waydroid-extra/images/vendor.img
    rm -r /tmp/waydroid
    rm /tmp/waydroid.zip
    sudo systemctl enable --now waydroid-container.service
    sudo waydroid init -f
    echo "Waydroid initialization success!"
