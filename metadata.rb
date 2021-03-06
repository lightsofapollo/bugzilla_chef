name             'bugzilla_test'
maintainer       'YOUR_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures berkshelf_learn'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'apache2', '~> 1.8'
depends 'mysql', '~> 3.0'
depends 'perl', '~> 1.2'
depends 'database', '~> 1.5'
depends 'cpan', '~> 0.0.29'
depends 'yum', '~> 2.3.4'
depends 'simple_iptables', '~> 0.3.0'
