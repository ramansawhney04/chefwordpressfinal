execute 'packageupdate' do
  command  'apt-get update'
end

package 'apache2' do
  action :install
end

service 'apache2' do
  action  [:enable, :start]
end

package 'mysql-server' do
  action :install
end

service 'mysql' do
  action [:enable, :start]
end

package 'php5' do
  action :install
end

file '/var/www/html/info.php' do
  content '<?php  phpinfo(); ?>'
end

package 'php5-mysql' do
  action :install
end

package 'libapache2-mod-php5' do
  action :install
end

package 'php5-mcrypt' do
  action :install
end

package 'php5-gd' do
  action :install
end

package 'libssh2-php' do
  action :install
end

package 'php5-mysqlnd-ms' do
  action :install
end

execute 'sqllogin' do
  command 'mysqladmin -u root password 123@India && touch /var/flagmysqlroot'
  creates '/var/flagmysqlroot'
end

cookbook_file '/tmp/mysqlcommands.txt' do
  source 'mysqlcommands.txt'
  owner 'root'
  group 'root'
  mode '0777'
  action :create_if_missing
end

execute 'mysqlexecute' do
  command 'mysql -uroot -p123@India < /tmp/mysqlcommands && touch /var/flagmysqlcommands'
  creates '/var/flagmysqlcommands'
end

remote_file '/tmp/latest.tar.gz' do
  source 'http://wordpress.org/latest.tar.gz'
end

execute 'untar' do 
  command 'tar xzvf /tmp/latest.tar.gz'
  cwd '/root'
end


execute 'copy' do
  command 'cp -R /root/wordpress/* /var/www/html/'
end

cookbook_file '/tmp/wp-config.php' do
  source 'wp-config-sample.php'
  owner 'root'
  group 'root'
  mode '0777'
  action :create
end

execute 'changeownership' do 
  command 'chown -R www-data:www-data *'
  cwd '/var/www/html'
end

execute 'createdirectory' do
  command 'mkdir /var/www/html/wp-content/uploads && touch /var/flagmkdir'
  creates '/var/flagmkdir'
end

execute 'chown' do
  command 'chown -R :www-data /var/www/html/wp-content/uploads'
end

execute 'movefile' do
  command 'mv /var/www/html/index.html /var'
end

