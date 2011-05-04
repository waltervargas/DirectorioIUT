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
    
    if ($c->req->method eq 'POST'){
	    my $grupo       = $c->req->param("nombre");
	    my $descripcion = $c->req->param("descripcion");

        #Envia el nuevo Usuario a LDAP
        my $ldap = Covetel::LDAP->new;
        my $group = Covetel::LDAP::Group->new({ 
            nombre => $grupo, 
            descripcion => $descripcion, 
		    ldap => $ldap 
	    });

        $c->log->debug($group->dn());

        if ($group->add()){
	        $c->res->body("El grupo $grupo ha sido creado exitosamente 
            <a href='/grupos/crear/'> Volver </a>");
	    }else{
            $c->res->body("El nombre del grupo: $grupo y la descripcion: $descripcion, No se creo el grupo");
        }
    }
}

sub lista : Local {
    my ( $self, $c ) = @_;
    my $ldap = Covetel::LDAP->new;
    my @lista = $ldap->group();
    $c->stash->{grupos} = \@lista;
}

sub eliminar : Local {
    my ( $self, $c, $cn) = @_;
    my $ldap = Covetel::LDAP->new;
    my @grupos = $ldap->group();

    foreach my $grupo (@grupos){
        $c->log->debug($grupo->entry->get_value('cn'));
        if ($grupo->entry->get_value('cn') eq $cn){
            if($grupo->del()){
                $c->res->body("Fue eliminado satisfactoriamente el grupo $cn  <a
                href='/grupos/lista'> Volver </a>");
            }
        } 
    }

}

sub apergroup : Local {
    my ( $self, $c ) = @_;
    $c->response->body();
}

=head1 AUTHOR

ApHu,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
