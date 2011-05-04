#!/usr/bin/env perl
use strict;
use warnings;
use Covetel::LDAP;
use Covetel::LDAP::Group;
use Data::Dumper;
use utf8;

my $ldap = Covetel::LDAP->new;

## Creamos el grupo de Administradores
#my $group = Covetel::LDAP::Group->new(
#    { 
#        nombre => "Administradores", 
#        descripcion => "Administradores de la Aplicación", 
#		ldap => $ldap, 
#        members => ["wvargas","cparedes","jdasilva"], 
#	} 
#);
#
#print Dumper $group->members;
#
#if ($group->add()){
#	print "The group ".$group->dn." has been created ". $group->gidNumber() ."  \n";
#} else {
#	$group->ldap->print_error();
#}


my $g = $ldap->group({gidNumber => 1005});

print Dumper $g->members;

$g->add_member('lramirez');

print Dumper $g->members;

$g->update;

#my $person = Covetel::LDAP::Person->new(
#    { 
#		uid => 'root', 
#		firstname => 'Root', 
#		lastname => 'Admin',
#		ldap => $ldap 
#	} 
#);
#
#if ($group->add()){
#	print "The group ".$group->dn." has been created ". $group->gidNumber() ."  \n";
#} else {
#	$group->ldap->print_error();
#}


