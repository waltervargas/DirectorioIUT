#!/usr/bin/env perl
use strict;
use warnings;
use Covetel::LDAP;
use Covetel::LDAP::Person;
use Covetel::LDAP::Group;
use Data::Dumper;
use utf8;
use 5.010;

my $ldap = Covetel::LDAP->new;

unless ($ldap->person({uid => 'root'})){
	my $person = Covetel::LDAP::Person->new(
	    { 
			uid => 'root', 
			firstname => 'Root', 
			lastname => 'Admin',
            ced => '123456', 
			ldap => $ldap, 
		} 
	);

    $person->password("123321...");
    if($person->add()) {
        say "Usuario root creado.";
    }
} else {
    say "El usuario root ya existe.";
}


## Creamos el grupo de Administradores

unless($ldap->group({cn => 'Administradores'})){
	my $group = Covetel::LDAP::Group->new(
	    { 
	        nombre => "Administradores", 
	        description => "Administradores de la Aplicación", 
			ldap => $ldap, 
	        members => ["root"], 
		} 
	);

    if($group->add()){
        say "Grupo Administradores creado.";
    }
} else {
    say "El grupo Administradores ya existe";
}
