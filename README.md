# pipe-pop

# For pop_update_monitor.sh

sudo chmod +x $HOME/monitoring/pop_update.sh

nohup ./pop_update_monitor.sh > pop_monitor.log 2>&1 &

# For systemd

Create the systemd service file /etc/systemd/system/pop-update.service:

[Unit]
Description=Pop Auto-Update Service
Wants=network-online.target
After=network-online.target

[Service]
Type=oneshot
ExecStart=$HOME/monitoring/pop_update.sh
User=root

sudo systemctl daemon-reload

Create the systemd timer file /etc/systemd/system/pop-update.timer:

[Unit]
Description=Runs Pop Auto-Update Periodically

[Timer]
OnBootSec=5m
OnUnitActiveSec=30m
Persistent=true

[Install]
WantedBy=timers.target

sudo systemctl enable --now pop-update.timer

How It Works

✅ Checks for updates every 30 minutes (OnUnitActiveSec=30m).
✅ Runs once 5 minutes after boot (OnBootSec=5m).
✅ Stops, downloads, updates, and restarts pop when an update is found.
✅ Uses systemd instead of a background script.
