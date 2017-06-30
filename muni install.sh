Muni installatie

#login password ubuntu
#nano hosts.sh

#Switch naar root user
#sudo -s

#installeert apache2 en andere modules
apt-get -y install apache2 libcgi-fast-perl libapache2-mod-fcgid &&

#enable fcgid module in apache
a2enmod fcgid &&

#installeer Munin voor Ubuntu 16.04
apt-get -y install munin munin-node munin-plugins-extra &&

#edit Munin configuration file
#nano /etc/munin/munin.conf &&

#verwijder hashes
sed -i 's*#dbdir	/var/lib/munin*dbdir	/var/lib/munin*' /etc/munin/munin.conf &&
sed -i 's*#htmldir /var/cache/munin/www*htmldir /var/cache/munin/www*' /etc/munin/munin.conf &&
sed -i 's*#logdir /var/log/munin*logdir /var/log/munin*' /etc/munin/munin.conf &&
sed -i 's*#rundir  /var/run/munin*rundir  /var/run/munin*' /etc/munin/munin.conf &&
sed -i 's*#tmpldir	/etc/munin/templates*tmpldir	/etc/munin/templates*' /etc/munin/munin.conf &&

#edit munin.conf file voor Apache om externe ip-addressen toe te staan.
mv /etc/munin/apache24.conf /etc/munin/apache24.conf_bak &&

#open nieuwe file
nano /etc/munin/apache24.conf &&

#kopieer onderstaande in file: /etc/munin/apache24.conf
echo "Alias /munin /var/cache/munin/www
<Directory /var/cache/munin/www>
 # Require local
 Require all granted
 Options FollowSymLinks SymLinksIfOwnerMatch
 Options None
</Directory>

ScriptAlias /munin-cgi/munin-cgi-graph /usr/lib/munin/cgi/munin-cgi-graph
<Location /munin-cgi/munin-cgi-graph>
 # Require local
 Require all granted
 Options FollowSymLinks SymLinksIfOwnerMatch
 <IfModule mod_fcgid.c>
 SetHandler fcgid-script
 </IfModule>
 <IfModule !mod_fcgid.c>
 SetHandler cgi-script
 </IfModule>
</Location>" > /etc/munin/apache24.conf &&

#herstart Apache
service apache2 restart &&

#herstart Munin
service munin-node restart &&

