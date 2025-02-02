#!/bin/bash


SERVICE_FILE=/etc/systemd/system/pop.service
exec_line=$(grep '^ExecStart=' "$SERVICE_FILE")

# Use parameter expansion to extract ram and max-disk values
ram_value=$(echo "$exec_line" | sed -n 's/.*--ram=\([0-9]*\).*/\1/p')
max_disk_value=$(echo "$exec_line" | sed -n 's/.*--max-disk \([0-9]*\).*/\1/p')

echo "Введите ОЗУ. Если хотите оставить текущую($ram_value ГБ) нажмите ENTER: "
read MEM

echo "Введите HDD. Если хотите оставить текущее значение ($max_disk_value ГБ) нажмите ENTER: : "
read HDD

if [ -n "$MEM" ]; then
    sed -i "s/--ram=[0-9]*/--ram=$MEM/" "$SERVICE_FILE"
fi

if [ -n "$HDD" ]; then
    sed -i "s/--max-disk [0-9]*/--max-disk $HDD/" "$SERVICE_FILE"
fi

systemctl stop pop
sudo systemctl daemon-reload
systemctl start pop

