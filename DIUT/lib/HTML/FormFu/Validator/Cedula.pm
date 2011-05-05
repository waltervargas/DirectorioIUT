package HTML::FormFu::Validator::Cedula;
use strict;
use warnings;
use base 'HTML::FormFu::Validator';
use utf8;
use Covetel::LDAP;

sub validate_value {
    my ( $self, $value, $params ) = @_;

    my $c = $self->form->stash->{context};

    my $ldap = Covetel::LDAP->new;
    unless ($ldap->person({pager => $value})){
         return 1;
    }

    die HTML::FormFu::Exception::Validator->new({
        message => 'La cédula que está intentando ingresar ya existe',
    });
}

1;
