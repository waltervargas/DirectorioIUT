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
    
	# Clases para los campos requeridos. 
    my $form = $c->stash->{form};
	$form->auto_constraint_class( 'constraint_%t' );
    
    if ( $form->submitted_and_valid ) {
	    my $uid         = $c->req->param("uid");
	    my $firstname   = $c->req->param("nombre");
	    my $lastname    = $c->req->param("apellido");
	    my $email       = $c->req->param("mail");
	    my $password    = $c->req->param("passwd");
	    my $ced         = $c->req->param("ced");

	    my $person = Covetel::LDAP::Person->new({ 
			uid => $uid,  
			firstname => $firstname, 
			lastname => $lastname,
            ced => $ced, 
            email => $email, 
		});

        $person->password($password);    

	    my $dn = $person->dn();

        if ($person->add){
            $c->stash->{mensaje} = "La persona $firstname $lastname ha sido
            ingresada exitosamente";
            $c->stash->{sucess} = 1;
	    } else {
            $c->stash->{error} = 1;
            $c->stash->{mensaje} = "<strong> Error Crítico en LDAP:</strong>". $person->ldap->error_str();
        }
	} elsif ($form->has_errors && $form->submitted) {
        # Obtengo el campo que fallo
        my @err_fields = $form->has_errors;
		my $label = $form->get_field($err_fields[0])->label; 

        $c->stash->{error} = 1;
        $c->stash->{mensaje} = "Ha ocurrido un error en el campo <span class='strong'> $label </span> ";
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
