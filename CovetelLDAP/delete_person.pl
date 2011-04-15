#!/usr/bin/perl 
use strict;
use warnings;
use Covetel::LDAP;
use Covetel::LDAP::Person;

my $ldap = Covetel::LDAP->new({config_file => 'covetel.yml'});

my @persons = $ldap->person({uid => 'nagui'});

foreach (@persons){
    print $_->dn,  "\n";
    if($_->del()){
        print "Deleting ".$_->dn."\n";
    }
}
