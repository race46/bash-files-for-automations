echo 'stopping nginx'
sudo systemctl stop nginx

echo 'creating keys for certification'
sudo openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -sha384 -keyout server-cert.key -out server-cert.crt

echo 'moving cert keys into nginx directory'
sudo mv ./server-cert.key /etc/nginx/ssl/server-cert.key
sudo mv ./server-cert.crt /etc/nginx/ssl/server-cert.crt

echo 'creating a config file for your website'

echo $"server {

	listen   443 ssl;
	ssl_certificate    /etc/nginx/ssl/server-cert.crt;
	ssl_certificate_key    /etc/nginx/ssl/server-cert.key;
	server_name selamke.com;
	access_log /var/log/nginx/nginx.vhost.access.log;
	error_log /var/log/nginx/nginx.vhost.error.log;
	
	location / {
		proxy_set_header Host \$host;
		proxy_pass	http://localhost:3000;
	}
}" > selamkee.conf

echo 'moving config file under nginx directory'
sudo mv ./selamkee.conf /etc/nginx/sites-available

echo 'creating a hardlink of config'
sudo ln -s /etc/nginx/sites-available/selamkee.conf /etc/nginx/sites-enabled/

echo 'starting nginx'
sudo systemctl restart nginx
