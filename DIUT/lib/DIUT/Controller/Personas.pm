package DIUT::Controller::Personas;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

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
    my @lista = qw/Dino Carlos Leo Walter/;
    my @opc = qw/Editar Eliminar/;
    $c->stash->{personas} = \@lista;
    $c->stash->{opciones} = \@opc;
}

sub crear : Local {
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
