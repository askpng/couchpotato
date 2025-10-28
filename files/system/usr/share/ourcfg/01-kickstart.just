# Set up HTPc
setup-htpc:
    #!/usr/bin/env bash
    echo TODO

# add-user-to-input-group:
#     #/!usr/bin/env bash
#     sudo groupadd --gid "$(getent group video | cut -d: -f3)" input
#     sudo usermod -a -G input $USER

enable-autologin:
    #/usr/bin/env bash
    sudo systemctl disable getty@tty1.service
    sudo systemctl enable autologin@$(whoami).service

enable-flex-launcher-service:
    #/usr/bin/env bash
    echo "Copying flex-launcher files to \$HOME/.config for local editing"
    cp -r /usr/flex-launcher $HOME/.config
    echo "Files copied. Edit your launcher files at \$HOME/.config/flex-launcher"
    systemctl --user daemon-reload
    systemctl --user enable flex-launcher.service

copy-skel-files:
    #/usr/bin/env bash
    echo "Copying default user files shipped in skel"
    cp -r /etc/skel $HOME/