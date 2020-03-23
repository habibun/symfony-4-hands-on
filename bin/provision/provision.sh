#!/usr/bin/env bash
#USER=root
#PROVISION_DROPLET_IP=206.189.19.93
#MYSQLPASSWORD=hello123
PASS_SQL="use mysql; UPDATE user SET authentication_string=PASSWORD('$MYSQLPASSWORD') WHERE User='root'; flush privileges;"

function copy {
    scp $1 $USER@$PROVISION_DROPLET_IP:$2
}

function install_apache {
    ssh $USER@$PROVISION_DROPLET_IP sudo apt-get -y update && \
        sudo apt-get -y install apache2 && \
        sudo ufw allow 'Apache Full' && \
        sudo a2enmod rewrite
}

function install_php72 {
    ssh $USER@$PROVISION_DROPLET_IP sudo add-apt-repository ppa:ondrej/php && \
        sudo apt-get -y update && \
        sudo apt-get -y install php7.2 php7.2-common php7.2-curl php7.2-xml php7.2-zip php7.2-gd php7.2-mysql php7.2-mbstring && \
        sudo a2enmod php7.2 && \
        sudo service apache2 restart
}

function install_mysql {
    ssh $USER@$PROVISION_DROPLET_IP sudo apt-get -y install mysql-server && \
        echo 'mysql-server-5.7 mysql-server/root_password password root' | sudo debconf-set-selections && \
        echo 'mysql-server-5.7 mysql-server/root_password_again password root' | sudo debconf-set-selections && \
        sudo apt-get -y install mysql-server-5.7 mysql-client >> /dev/null && \
        sudo service mysql start && \
        sudo mysql -u root -proot -e "$PASS_SQL"
}

#install_apache
#install_php72
#install_mysql
#package_app
echo $PASS_SQL
#echo $MYSQLPASSWORD