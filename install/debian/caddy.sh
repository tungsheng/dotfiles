# download caddy
sudo curl https://getcaddy.com | bash -s http.minify,tls.dns.digitalocean

# permission to “root” and make it executable
sudo chown root:root /usr/local/bin/caddy
sudo chmod 755 /usr/local/bin/caddy
sudo setcap CAP_NET_BIND_SERVICE=+eip /usr/local/bin/caddy

# create the Caddy’s user and group
sudo groupadd caddy
sudo useradd \
-g caddy \
--home-dir /var/www --no-create-home \
--shell /usr/sbin/nologin \
--system caddy

# Caddyfile setup
sudo mkdir /etc/caddy
sudo touch /etc/caddy/Caddyfile
sudo chown -R root:caddy /etc/caddy
sudo chown caddy:caddy /etc/caddy/Caddyfile
sudo chmod 444 /etc/caddy/Caddyfile

# SSL config
sudo mkdir /etc/ssl/caddy
sudo chown -R caddy:root /etc/ssl/caddy
sudo chmod 770 /etc/ssl/caddy

# root dir
sudo mkdir /var/www

# Caddy service config
sudo cp Caddyservice /etc/systemd/system/caddy.service
sudo chown root:root /etc/systemd/system/caddy.service
sudo chmod 644 /etc/systemd/system/caddy.service

# Start Caddy
sudo systemctl daemon-reload
sudo systemctl start caddy
