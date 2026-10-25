#!/bin/bash
# Логотип для экрана самого ноута (консоль без полублоков), полноцветный — для SSH
wget -qO ~/.config/fastfetch/tapki_tty.txt https://pravilnost1991-coder.github.io/k/tapki_tty.txt
sed -i '/fastfetch/d' ~/.bashrc
cat >> ~/.bashrc <<'EOT'
if [ "$TERM" = linux ]; then fastfetch --logo ~/.config/fastfetch/tapki_tty.txt; else fastfetch; fi
alias adbroot='fastfetch --logo ~/.config/fastfetch/adbroot.txt'
EOT
echo "Готово. Проверка:"; fastfetch --logo ~/.config/fastfetch/tapki_tty.txt
