package DIUT::Controller::AJAX;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller::REST'; }

__PACKAGE__->config(
  'default'   => 'application/json',
);

=head1 NAME

DIUT::Controller::AJAX - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched DIUT::Controller::AJAX in AJAX.');
}

sub grupos : Local : ActionClass('REST') {}

sub grupos_GET {
	my ($self, $c) = @_;
    my %datos; 

    $datos{aaData} = [
        [ "profesores",  "Grupo de Profesores" ],
        [ "Estudiantes", "Grupo de estudiantes" ]
    ];

	$self->status_ok($c, entity => \%datos);
}


=head1 AUTHOR

Walter Vargas

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
