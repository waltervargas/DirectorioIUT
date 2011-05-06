package DIUT::Controller::Login;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller::HTML::FormFu'; }

=head1 NAME

DIUT::Controller::Login - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) :FormConfig {
    my ( $self, $c ) = @_;

    if ( $c->user_exists ){
        #$c->response->redirect($c->uri_for('/personas/lista'));
        #return 0;
    }
    my $form = $c->stash->{form};
	$form->auto_constraint_class( 'constraint_%t' );
    
    $c->log->debug($c->encoding->name);

    if ( $form->submitted_and_valid ) {
	    my $login   = $c->req->param("login");
	    my $passw   = $c->req->param("passw");
        if ( $c->authenticate( { id => $login, password => $passw } ) ) {
            $c->response->redirect($c->uri_for($c->controller('personas')->action_for('lista')));
        } else {
            $c->stash->{error} = 1;
            $c->stash->{mensaje} = "Usuario o password no validos";
        }
	} elsif ($form->has_errors && $form->submitted) {
        my @err_fields = $form->has_errors;
		my $label = $form->get_field($err_fields[0])->label; 

        $c->stash->{error} = 1;
        $c->stash->{mensaje} = "Ha ocurrido un error en el campo <span class='strong'> $label </span> ";

    } 

}


=head1 AUTHOR

Walter Vargas

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
