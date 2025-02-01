#!/bin/bash


echo "Введите адрес кошелька соланы: "
read PUB_KEY

echo "Введите реферальный код или нажмите ENTER: "
read REF

cd $HOME
sudo mkdir -p $HOME/opt/dcdn/download_cache

sudo wget -O $HOME/opt/dcdn/pop "https://dl.pipecdn.app/v0.2.1/pop"

sudo chmod +x $HOME/opt/dcdn/pop
sudo ln -s $HOME/opt/dcdn/pop /usr/local/bin/pop -f

if [ -n "$REF" ]; then
    cd $HOME/opt/dcdn/
    ./pop --signup-by-referral-route $REF
fi

sudo tee /etc/systemd/system/pop.service > /dev/null << EOF
[Unit]
Description=Pipe POP Node Service
After=network.target
Wants=network-online.target

[Service]
ExecStart=$HOME/opt/dcdn/pop --ram=8 --pubKey $PUB_KEY --max-disk 300 --cache-dir $HOME/opt/dcdn/download_cache
Restart=always
RestartSec=5
LimitNOFILE=65536
LimitNPROC=4096
StandardOutput=journal
StandardError=journal
SyslogIdentifier=dcdn-node
WorkingDirectory=$HOME/opt/dcdn

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable pop
sudo systemctl start pop

cp $HOME/opt/dcdn/node_info.json $HOME/pipe_backup/node_info.json

echo "-----------------------------------------------------------------------------"
echo "Проверка логов"
echo "journalctl -n 100 -f -u pop -o cat"
echo "-----------------------------------------------------------------------------"
