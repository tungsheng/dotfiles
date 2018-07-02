# download caddy
curl https://getcaddy.com | bash -s http.minify,tls.dns.digitalocean

# permission to “root” and make it executable
chown root:root /usr/local/bin/caddy
chmod 755 /usr/local/bin/caddy
setcap CAP_NET_BIND_SERVICE=+eip /usr/local/bin/caddy

# create the Caddy’s user and group
groupadd caddy
useradd \
-g caddy \
--home-dir /var/www --no-create-home \
--shell /usr/sbin/nologin \
--system caddy

# Caddyfile setup
mkdir /etc/caddy
touch /etc/caddy/Caddyfile
chown -R root:caddy /etc/caddy
chown caddy:caddy /etc/caddy/Caddyfile
chmod 444 /etc/caddy/Caddyfile

# SSL config
mkdir /etc/ssl/caddy
chown -R caddy:root /etc/ssl/caddy
chmod 770 /etc/ssl/caddy

# root dir
mkdir /var/www

# Caddy service config
cp Caddyservice /etc/systemd/system/caddy.service
chown root:root /etc/systemd/system/caddy.service
chmod 644 /etc/systemd/system/caddy.service

# Start Caddy
systemctl daemon-reload
systemctl start caddy
