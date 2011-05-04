package DIUT::Controller::Personas;
use Moose;
use namespace::autoclean;
use Covetel::LDAP;
use Covetel::LDAP::Person;
use utf8;

BEGIN {extends 'Catalyst::Controller::HTML::FormFu'; }

=head1 NAME

DIUT::Controller::Personas - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    $c->response->body();
}

sub lista : Local {
    my ( $self, $c ) = @_;
    my $ldap = Covetel::LDAP->new;
    my @lista = $ldap->person();
    $c->stash->{personas} = \@lista;
}


sub eliminar : Local {
    my ( $self, $c, $uid ) = @_;
    my $ldap = Covetel::LDAP->new;
    my $person = $ldap->person({uid => $uid});
    if ($person){
        if($person->del()){
            $c->res->body("La persona " . $person->firstname . " ha sido
                borrada exitosamente <a href='/personas/lista'>Volver</a>");
        }
    } else {
        $c->res->body("Uid no encontrado");
    }
    
}

sub crear : Local : FormConfig {
    my ( $self, $c ) = @_;
    
    $c->log->debug($c->encoding->name);

    if ($c->req->method eq 'POST'){
	    my $uid         = $c->req->param("uid");
	    my $firstname   = $c->req->param("nombres");
	    my $lastname    = $c->req->param("apellidos");

	    my $person = Covetel::LDAP::Person->new({ 
			uid => $uid,  
			firstname => $firstname, 
			lastname => $lastname,
		});
	    my $dn = $person->dn();
	    if ($person->add){
	        $c->res->body("La persona ha sido creada exitosamente $dn
            <a href='/personas/crear/'> Volver </a>");
	    }
    }
}

sub personasdetalle : Local {
    my ( $self, $c ) = @_;
}

=head1 AUTHOR

ApHu,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
