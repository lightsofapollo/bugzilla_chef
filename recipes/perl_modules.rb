include_recipe 'yum::repoforge';

# special crap for imagemagic
package 'ImageMagick'
package 'ImageMagick-devel'
package 'ImageMagick-perl'

include_recipe 'perl'
package 'mod_perl'
package 'mod_perl-devel'

# enable the apache module
apache_module 'perl'
[
  'DateTime',
  'DateTime::TimeZone',
  'Template::Toolkit',
  'Email::Send',
  'Email::MIME',
  'List::MoreUtils',
  'Math::Random',
  'Tie::IxHash',
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
