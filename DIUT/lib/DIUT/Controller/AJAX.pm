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

sub personas : Local : ActionClass('REST') {}

sub grupos_GET {
	my ($self, $c) = @_;
    my %datos; 

    $datos{aaData} = [
        map { [ "profesores $_",  "Grupo de Profesores $_" ] } 1..100000, 
    ];

	$self->status_ok($c, entity => \%datos);
}

sub personas_GET {
    my ( $self, $c ) = @_;
    
    my %datos; 
    
    $datos{aaData} = [
        [ "Walter",  "Vargas", "16612574", 'walter@covetel.com.ve' ],
        [ "Luis",  "Da silva", "12123213", 'ldasilva@covetel.com.ve' ],
        [ "Walter",  "Vargas", "16612574", 'walter@covetel.com.ve' ],
        [ "Walter",  "Vargas", "16612574", 'walter@covetel.com.ve' ],
        [ "Walter",  "Vargas", "16612574", 'walter@covetel.com.ve' ],
        [ "Walter",  "Vargas", "16612574", 'walter@covetel.com.ve' ],
        [ "Luis",  "Da silva", "12123213", 'ldasilva@covetel.com.ve' ],
        [ "Luis",  "Da silva", "12123213", 'ldasilva@covetel.com.ve' ],
        [ "Luis",  "Da silva", "12123213", 'ldasilva@covetel.com.ve' ],
        [ "Luis",  "Da silva", "12123213", 'ldasilva@covetel.com.ve' ],
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
