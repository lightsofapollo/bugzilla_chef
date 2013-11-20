include_recipe 'yum::repoforge';
include_recipe 'perl'

# special crap for imagemagic
package 'ImageMagick'
package 'ImageMagick-devel'
package 'ImageMagick-perl'
package 'perl(parent)'

[
  'YAML',
  'DateTime',
  'DateTime::TimeZone',
  'Template::Toolkit',
  'Email::Send',
  'Email::MIME',
  'List::MoreUtils',
  'Math::Random',
  'Tie::IxHash',
  'Text::Diff',
  'SOAP::Lite',
  'Test::Taint',
  'JSON',
  'Regexp::Common',
  'HTML::Tree',
  'Daemon::Generic',
  'Crypt::CBC',
  'Crypt::DES',
  'Crypt::DES_EDE3',
  'Crypt::OpenPGP',
  'Crypt::SMIME',
  'HTML::Tree',
  'JSON::XS',
  'File::MimeInfo',
  'IO::All',
  'SOAP::Lite',
  'XML::Simple',
  'Time::HiRes'
].each do |pkg_name|
  puts pkg_name
  package "perl-#{pkg_name.gsub('::', '-')}" do
    action :install
  end
end

# enable the apache module & stuff related to apache
package 'mod_perl'
package 'mod_perl-devel'
apache_module 'perl'
