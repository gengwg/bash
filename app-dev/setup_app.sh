#!/usr/bin/env bash

#set -e 

install_dependencies()
{ # install dependencies
    sudo yum -y install Percona-Server-server-56.x86_64
     
    sudo yum -y install gcc
    sudo yum -y install python-devel
    sudo yum -y install MySQL-python

    sudo yum -y install git
    sudo yum -y install python-ecdsa
    sudo pip install requests # optional
}


fix_mysql()
{
    n=$(grep -m 1 -n 'NO_ENGINE_SUBSTITUTION' /etc/my.cnf | cut -d ':' -f 1)
    head -n $n /etc/my.cnf > /tmp/my.cnf.tmp
    cat >> /tmp/my.cnf.tmp << EOF

####################
# mysql hack
max_allowed_packet=40M;
innodb_log_file_size=200M;

EOF

    tail -n +$((n+1)) /etc/my.cnf >> /tmp/my.cnf.tmp

    mv /tmp/my.cnf.tmp /etc/my.cnf

    systemctl restart mysqld.service
}

config_mysql()
{
    mysql -u root --password="" -e "create database appdb;"
    mysql -u root --password="" -e "CREATE USER 'app_rw'@'localhost' IDENTIFIED BY 'readwritepasswd';"
    mysql -u root --password="" -e "GRANT ALL PRIVILEGES ON appdb.* TO 'app_rw'@'localhost' IDENTIFIED BY 'readwritepasswd';"
    mysql -u root --password="" -e "CREATE USER 'app_ro'@'localhost' IDENTIFIED BY 'readonlypasswd';"
    mysql -u root --password="" -e "GRANT ALL PRIVILEGES ON appdb.* TO 'app_ro'@'localhost' IDENTIFIED BY 'readonlypasswd';"
     
    mysql --user=root --password="" --host=localhost --port=3306 < /vagrant/mysql_boostrap.sql
}

import_appdb()
{ # import data
    cd /vagrant
    mysql -u app_rw -preadwritepasswd -h localhost appdb < appdb.sql
    cd -
}

start_app_api()
{
    # start app api
    cd /vagrant/app-api
    pip install --upgrade --force-reinstall pep8
    pip install --force-reinstall -r requirements.txt
    TEST_APP_FILES_DIR=./examples/ python run.py &
    cd -
}

main ()
{
    install_dependencies

    # optional install vim
    yum install -y vim

    fix_mysql

    config_mysql

    import_appdb

    start_app_api

    exit 0 
}

main
