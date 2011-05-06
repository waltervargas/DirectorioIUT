package DIUT::Controller::Grupos;
use Moose;
use namespace::autoclean;
use Covetel::LDAP;
use Covetel::LDAP::Group;
use utf8;


BEGIN {extends 'Catalyst::Controller::HTML::FormFu'; }

=head1 NAME

DIUT::Controller::Grupos - Catalyst Controller

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

sub crear : Local  : FormConfig {
    my ( $self, $c ) = @_;

	# Clases para los campos requeridos. 
    my $form = $c->stash->{form};
	$form->auto_constraint_class( 'constraint_%t' );
    
    if ( $form->submitted_and_valid ) {
	    my $grupo       = $c->req->param("nombre");
	    my $descripcion = $c->req->param("descripcion");

        #Envia el nuevo Usuario a LDAP
        my $ldap = Covetel::LDAP->new;
        my $group = Covetel::LDAP::Group->new({ 
            nombre => $grupo, 
            description => $descripcion, 
		    ldap => $ldap 
	    });

        $c->log->debug($group->dn());

        if ($group->add()){
            $c->stash->{mensaje} = "El grupo $grupo ha sido
            agregado exitosamente";
            $c->stash->{sucess} = 1;
	    }else{
            $c->stash->{error} = 1;
            $c->stash->{mensaje} = "<strong> Error Crítico en LDAP:</strong>".$group->ldap->error_str();
        }
	} elsif ($form->has_errors && $form->submitted) {
        my @err_fields = $form->has_errors;
		my $label = $form->get_field($err_fields[0])->label; 

        $c->stash->{error} = 1;
        $c->stash->{mensaje} = "Ha ocurrido un error en el campo <span class='strong'> $label </span> ";
    }
}

sub lista : Local {
    my ( $self, $c ) = @_;
    my $ldap = Covetel::LDAP->new;
    my @lista = $ldap->group();
    $c->stash->{grupos} = \@lista;
}

sub eliminar : Local {
    my ( $self, $c, $gid) = @_;
    my $ldap = Covetel::LDAP->new;
    my $grupo = $ldap->group({gidNumber => $gid});
    if ($grupo){
        if($grupo->del()){
            $c->stash->{mensaje} = "El grupo ".$grupo->nombre." ha sido eliminado exitosamente";
        }
    } else {
            $c->stash->{error} = 1;
            $c->stash->{mensaje} = "No se encontro el grupo";
    }
}

sub detalle : Local {
    my ( $self, $c, $gid) = @_;
    my $ldap = Covetel::LDAP->new;
    my $grupo = $ldap->group({gidNumber => $gid});
    
    if($grupo) {
        my $nombre = $grupo->nombre();
        my $desc = $grupo->description();

        utf8::decode($nombre);
        utf8::decode($desc); 

        $grupo->nombre($nombre);
        $grupo->description($desc);

        $c->stash->{grupo} = $grupo;
    }else{
        $c->res->body('No se encuentra el Grupo')
    }
}

=head1 AUTHOR

ApHu,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
