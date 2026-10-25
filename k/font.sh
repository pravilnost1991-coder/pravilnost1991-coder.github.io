#!/bin/bash
# Шрифт Geoform для консоли ноута. Размер: 10x20 (по умолчанию) или 12x24
#   wget -qO- pravilnost1991-coder.github.io/k/font.sh | bash -s 12x24
SIZE="${1:-10x20}"
F="geoform-$SIZE.psf"
sudo wget -qO /usr/share/consolefonts/$F "https://pravilnost1991-coder.github.io/k/$F" || { echo "не скачалось"; exit 1; }
sudo sed -i '/^FONT=/d' /etc/default/console-setup
echo "FONT=\"$F\"" | sudo tee -a /etc/default/console-setup >/dev/null
sudo setupcon
clear
echo "Geoform $SIZE установлен. Вернуть Terminus: sudo sed -i '/^FONT=/d' /etc/default/console-setup && sudo setupcon"
