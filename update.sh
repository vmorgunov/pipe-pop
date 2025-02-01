sudo systemctl stop pop

sudo wget -O $HOME/opt/dcdn/pop "https://dl.pipecdn.app/v0.2.2/pop"

chmod +x $HOME/opt/dcdn/pop
sudo ln -s $HOME/opt/dcdn/pop /usr/local/bin/pop -f

$HOME/opt/dcdn/pop --refresh

sudo systemctl start pop

echo "-----------------------------------------------------------------------------"
echo "Проверка логов"
echo "journalctl -n 100 -f -u pop -o cat"
echo "-----------------------------------------------------------------------------"