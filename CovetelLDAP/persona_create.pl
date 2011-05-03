#!/usr/bin/env perl
use strict;
use warnings;
use Covetel::LDAP;
use Covetel::LDAP::Person;
use Data::Dumper;
use utf8;
use 5.010;

my $ldap = Covetel::LDAP->new;
my $person = Covetel::LDAP::Person->new(
    { 
		uid => 'wvargas', 
		firstname => 'Walter', 
		lastname => 'Vargas',
		ldap => $ldap 
	} 
);

#say $person->uidNumber(); 

if ($person->add()){
	print "The person ".$person->dn." has been created with uidNumber: ".$person->uidNumber(). "\n";
#    $person->notify();
} else {
	$person->ldap->print_error();
}
