#!/usr/bin/env perl
use strict;
use warnings;
use Covetel::LDAP;
use Covetel::LDAP::Group;
use Data::Dumper;
use utf8;

my $ldap = Covetel::LDAP->new;

my $nombre = "Admin-DIUT";
my $descripcion = "Grupo de Administradores del Directorio IUT";

my $group = Covetel::LDAP::Group->new(
    { 
        nombre => $nombre, 
        descripcion => $descripcion, 
		ldap => $ldap 
	} 
);

if ($group->add()){
	print "The group ".$group->dn." has been created \n";
} else {
	$group->ldap->print_error();
}
