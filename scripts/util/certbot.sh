#source: https://www.howtoforge.com/tutorial/install-letsencrypt-and-secure-nginx-in-debian-9/


# add domain to ssl
sudo certbot certonly --standalone –d yourdomain.com –d www.yourdomain.com
sudo certbot certonly -d tonka.sh,drone.tonka.sh,2ml.tonka.sh

# setup nginx
certbot --nginx

# certbot auto
wget https://dl.eff.org/certbot-auto
chmod a+x ./certbot-auto
./certbot-auto --help
