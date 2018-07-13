#source: https://www.howtoforge.com/tutorial/install-letsencrypt-and-secure-nginx-in-debian-9/


# add domain to ssl
sudo certbot certonly --standalone –d yourdomain.com –d www.yourdomain.com

# setup nginx
certbot --nginx

