## perl setup
include_recipe 'perl'

### mysql setup
include_recipe 'mysql::server'
include_recipe 'mysql::client'

### bzr setup
package 'bzr'

### Apache setup
include_recipe 'apache2'

# enable the apache module
apache_module 'perl'

# we don't need the default site
apache_site 'default' do
  enable false
end

# enable rewrite
apache_module 'rewrite'

# bugzilla site definition
template "#{node[:apache][:dir]}/conf.d/bugzilla.conf" do
  source 'bugzilla.conf.erb'
  variables({
    :document_root => node[:bugzilla_test][:home]
  })
end

# perl setup
include_recipe 'bugzilla_test::perl_modules'

# checkout bugzilla (bmo)
bash 'checkout bmo' do
  user 'vagrant'
  group 'vagrant'
  creates node[:bugzilla_test][:home]
  code "bzr co #{node[:bugzilla_test][:repo]} #{node[:bugzilla_test][:home]}"
end

# install any modules we didn't fast path
[
  'Email::MIME',
  'Math::Random::ISAAC',
  'IO::Scalar',
  'Apache2::SizeLimit',
  'SOAP::Lite',
  'JSON::RPC'
].each do |mod|
  bash "bmo perl module #{mod}" do
    user 'vagrant'
    group 'vagrant'
    cwd node[:bugzilla_test][:home]
    creates "lib/#{mod.gsub('::', '/')}"
    code "perl install-module.pl #{mod}"
  end
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
