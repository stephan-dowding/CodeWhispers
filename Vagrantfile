# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu/vivid64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.provision "shell", inline: <<-SHELL

    sudo apt-get update
    curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
    sudo apt-get install -y nodejs build-essential mongodb nginx git fcgiwrap
    sudo npm install -g pm2 coffee-script

    sudo rm -f /etc/nginx/sites-enabled/*

    sudo cp /vagrant/nginx/git /etc/nginx/sites-available/git
    sudo ln -s /etc/nginx/sites-available/git /etc/nginx/sites-enabled/git

    sudo service nginx restart

    git config --global user.email "whisper@mailinator.com"
    git config --global user.name "whisper"
    git config --global push.default simple

    sudo git init --bare /srv/git/whisper.git --shared

    sudo chgrp -R www-data /srv/git

    cd /srv/git/whisper.git
    sudo git config http.receivepack true

    git clone http://localhost/git/whisper.git /vagrant/git-master
    cp -R /vagrant/initialGit-Ruby/* /vagrant/git-master/

    cd /vagrant/git-master
    git add --all
    git commit -m "initial commit"
    git push -u origin master

    cd /vagrant
    npm install
    sudo pm2 start app.coffee -i 0 -n whisper
    sudo pm2 startup systemd

    # curl http://localhost:3000/round/0

  SHELL

end
