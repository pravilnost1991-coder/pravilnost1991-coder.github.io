#!/bin/bash
# Первичная настройка ноута-сервера «kabina» (Debian 13).
# Запуск на ноуте:  wget -qO- pravilnost1991-coder.github.io/k/setup.sh | bash
set -e
BASE="https://pravilnost1991-coder.github.io/k"
G='\033[1;32m'; Y='\033[1;33m'; N='\033[0m'
step() { echo -e "\n${G}==> $1${N}"; }

if [ "$(id -u)" = 0 ]; then echo "Запускай от ivan, не от root"; exit 1; fi
echo -e "${Y}Сейчас sudo спросит пароль от ivan — это нормально.${N}"
sudo -v
APT="sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold"

step "1/6 Обновляю систему"
$APT update
$APT full-upgrade

step "2/6 Ставлю нужное: Node.js, Cockpit, fastfetch, утилиты"
$APT install --no-install-recommends cockpit
$APT install nodejs npm fastfetch curl git htop ca-certificates
sudo systemctl enable --now cockpit.socket

step "3/6 Ноут-сервер: не спать, крышка не выключает"
sudo mkdir -p /etc/systemd/logind.conf.d
printf '[Login]\nHandleLidSwitch=ignore\nHandleLidSwitchExternalPower=ignore\nHandleLidSwitchDocked=ignore\n' | sudo tee /etc/systemd/logind.conf.d/kabina.conf >/dev/null
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target >/dev/null 2>&1 || true
# экран гаснет через 2 минуты простоя (подсветка не жрёт и не выгорает)
if ! grep -q consoleblank /etc/default/grub; then
  sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 consoleblank=120"/' /etc/default/grub
  sudo update-grub >/dev/null 2>&1 || true
fi

step "4/6 fastfetch: VIVO SEROST' SHAYBA TAPKI ULTRA"
mkdir -p ~/.config/fastfetch
for f in tapki.txt adbroot.txt config.jsonc; do wget -qO ~/.config/fastfetch/$f "$BASE/$f"; done
sed -i '/fastfetch/d' ~/.bashrc
echo 'fastfetch' >> ~/.bashrc
echo "alias adbroot='fastfetch --logo ~/.config/fastfetch/adbroot.txt'" >> ~/.bashrc

step "5/6 Папка под Кабину"
mkdir -p ~/kabina

step "6/6 Готово"
IP=$(hostname -I | awk '{print $1}')
echo -e "Node.js: $(node -v)   npm: $(npm -v)"
echo -e "Cockpit (панель управления): ${G}https://$IP:9090${N}  (логин ivan + пароль)"
echo -e "SSH с ПК: ${G}ssh ivan@$IP${N}"
echo -e "${Y}Перезагрузи ноут: sudo reboot${N}"
