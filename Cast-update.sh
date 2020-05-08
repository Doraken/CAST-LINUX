git reset --hard
git pull  --rebase --no-autostash
chmod +x /srv/admin/CAST-LINUX/*.sh
chmod +x /srv/admin/CAST-LINUX/bin/*
/srv/admin/CAST-LINUX/bin/init-all.sh