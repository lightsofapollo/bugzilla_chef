## perl setup
include_recipe 'perl'

# special crap for imagemagic
package 'ImageMagick'
package 'ImageMagick-devel'
package 'ImageMagick-perl'

### mysql setup
include_recipe 'mysql::server'
include_recipe 'mysql::client'

### bzr setup
package 'bzr'

# checkout bugzilla (bmo)
bash 'checkout bmo' do
  user 'vagrant'
  group 'vagrant'
  creates node[:bugzilla_test][:home]
  code "bzr co #{node[:bugzilla_test][:repo]} #{node[:bugzilla_test][:home]}"
end

# install all the perl modules
bash 'install perl modules' do
  cwd node[:bugzilla_test][:home]
  code "perl install-module.pl --all"
end

# configure the settings
template "#{node[:bugzilla_test][:home]}/localconfig" do
  owner 'vagrant'
  group 'vagrant'
  mode '0755'
  source 'localconfig.erb'
  variables({
    :database => node[:bugzilla_test][:database],
    :database_user => node[:bugzilla_test][:database_user],
    :database_password => node[:bugzilla_test][:database_password]
  })
end



### database setup
include_recipe 'database::mysql'

mysql_connection_info = {
  :host     => 'localhost',
  :username => 'root',
  :password => node['mysql']['server_root_password']
}

mysql_database node[:bugzilla_test][:database] do
  connection mysql_connection_info
  action :create
end

mysql_database_user node[:bugzilla_test][:database_user] do
  connection mysql_connection_info
  password node[:bugzilla_test][:database_password]
  action :create
end

mysql_database_user node[:bugzilla_test][:database_user] do
  connection    mysql_connection_info
  password node[:bugzilla_test][:database_password]
  database_name node[:bugzilla_test][:database]
  host          '%'
  privileges    [:all]
  action        :grant
end

### Apache setup
include_recipe 'apache2'

# we don't need the default site
apache_site 'default' do
  enable false
end

# install mod perl (the default one does not work on centos)
package 'mod_perl' do
  action :install
end

# enable the apache module
apache_module 'perl'

# enable rewrite
apache_module 'rewrite'

# bugzilla site definition
template "#{node[:apache][:dir]}/conf.d/bugzilla.conf" do
  notifies :restart, 'service[apache2]'
  source 'bugzilla.conf.erb'
  variables({
    :document_root => node[:bugzilla_test][:home]
  })
end
