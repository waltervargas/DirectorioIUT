uid=wvargas,ou=Personas,dc=iutai,dc=tec,dc=ve
$VAR1 = bless( {
                 'firstname' => 'lastname',
                 'uid' => 'wvargas',
                 'ldap' => bless( {
                                    'base' => 'dc=iutai,dc=tec,dc=ve',
                                    'server' => bless( {
                                                         'net_ldap_version' => 3,
                                                         'net_ldap_scheme' => 'ldap',
                                                         'net_ldap_debug' => 0,
                                                         'net_ldap_socket' => bless( \*Symbol::GEN0, 'IO::Socket::INET' ),
                                                         'net_ldap_host' => 'localhost',
                                                         'net_ldap_uri' => 'localhost',
                                                         'net_ldap_resp' => {},
                                                         'net_ldap_mesg' => {},
                                                         'net_ldap_async' => 0,
                                                         'net_ldap_port' => 389,
                                                         'net_ldap_refcnt' => 1
                                                       }, 'Net::LDAP' ),
                                    'config' => {
                                                  'Covetel::LDAP' => {
                                                                       'connection_class' => 'Covetel::LDAP',
                                                                       'base' => 'dc=iutai,dc=tec,dc=ve',
                                                                       'entry_class' => 'Covetel::LDAP::Person',
                                                                       'host' => 'localhost',
                                                                       'password' => '123321...',
                                                                       'base_personas' => 'ou=Personas,dc=iutai,dc=tec,dc=ve',
                                                                       'dn' => 'cn=admin,dc=iutai,dc=tec,dc=ve',
                                                                       'start_tls' => 0
                                                                     }
                                                },
                                    'config_file' => 'config.yml'
                                  }, 'Covetel::LDAP' ),
                 'dn' => 'uid=wvargas,ou=Personas,dc=iutai,dc=tec,dc=ve'
               }, 'Covetel::LDAP::Person' );
