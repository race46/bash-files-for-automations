echo 'stopping nginx'
sudo systemctl stop nginx

echo 'creating a config file for redirection'

echo $"server {
    listen 80 default_server;
    server_name _;
    return 301 https://\$host\$request_uri;
}" > default

echo 'moving config file under nginx directory'
sudo mv ./default /etc/nginx/sites-available

echo 'creating a hardlink of config'
sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/

echo 'starting nginx'
sudo systemctl restart nginx
