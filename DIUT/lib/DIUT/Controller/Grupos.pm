package DIUT::Controller::Grupos;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

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

sub crear : Local {
    my ( $self, $c ) = @_;
    my @grupo = qw/Alumnos Profesores/;
    $c->stash->{grupos} = \@grupo
}

sub lista : Local {
    my ( $self, $c ) = @_;
    my @grupo = qw/Alumno Prefesores/;
    my @descrip = qw/Grupo_de_Alumnos Grupo_de_Profesores/;
    my @opc = qw/Editar Eliminar/;
    $c->stash->{grupos} = \@grupo;
    $c->stash->{descripcion} = \@descrip;
    $c->stash->{opciones} = \@opc;
}

=head1 AUTHOR

ApHu,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
