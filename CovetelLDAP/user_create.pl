#!/usr/bin/env perl
use strict;
use warnings;
use Covetel::LDAP;
use Covetel::LDAP::Person;
use Data::Dumper;
use utf8;

my $ldap = Covetel::LDAP->new;
my $person = Covetel::LDAP::Person->new(
    { 
		uid => 'wvargas', 
		firstname => 'Walter', 
		lastname => 'Vargas',
		ldap => $ldap 
	} 
);

#$person->mail('walter@covetel.com.ve');
#$person->password('123321...');

if ($person->add()){
	print "The person ".$person->dn." has been created \n";
#    $person->notify();
} else {
	$person->ldap->print_error();
}
