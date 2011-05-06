package DIUT::Controller::AJAX;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller::REST'; }

__PACKAGE__->config(
  'default'   => 'text/javascript',
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

sub groupmembers : Local : ActionClass('REST') {}

sub usuario_exists : Path('usuario/exists') Args(1) ActionClass('REST') {}

sub addMember : Path('grupos/add') Args ActionClass('REST') {}

sub delMember : Path('grupos/del') Args ActionClass('REST') {}

sub grupos_GET {
	my ($self, $c) = @_;
    my %datos; 
    
    my $ldap = Covetel::LDAP->new;
    my @lista = $ldap->group();

    $datos{aaData} = [
        map {
            [
                $_->gidNumber, $_->nombre, $_->description, 
                '<a href="/grupos/detalle/' . $_->gidNumber . '"> Ver detalle </a>', 
            ]
          } @lista,
    ];

	$self->status_ok($c, entity => \%datos);
}

sub personas_GET {
    my ( $self, $c ) = @_;
    
    my $ldap = Covetel::LDAP->new;
    my @lista = $ldap->person();

    my %datos; 
    
    $datos{aaData} = [
        map {
            [ 
            $_->firstname, 
            $_->lastname, 
            $_->ced, 
            $_->email,  
            $_->uidNumber, 
            $_->uid, 
            '<a href="/personas/detalle/' . $_->uid . '"> Ver detalle </a>', 
            ]
        } @lista, 
    ];

	$self->status_ok($c, entity => \%datos);
}

sub usuario_exists_GET {
    my ( $self, $c, $uid ) = @_;
    $c->log->debug($uid);
    my $resp = {};


    my $ldap = Covetel::LDAP->new;
    if ($ldap->person({uid => $uid})){
        $resp->{exists} = 1;
    } else {
        $resp->{exists} = 0;
    }
	
    $self->status_ok($c, entity => $resp);

}

sub groupmembers_GET {
    my ($self, $c, $gid) = @_;
    my %datos; 
    my @person;
    
    my $ldap = Covetel::LDAP->new;
    my $grupo = $ldap->group({gidNumber => $gid});

    if ($grupo) {
        my $members = $grupo->members;
        use Data::Dumper;
        $c->log->debug(Dumper($members));
        foreach (@{$members}) {
            $c->log->debug($_);
            my $p = $ldap->person({uid => $_});
            if ($p) {
                push @person,  $p;
            }
        }
    }
   

    $datos{aaData} = [
        map {
            [ 
            '<input type="checkbox" name="del" value="'.$_->uid.'">', 
            $_->firstname, 
            $_->lastname, 
            $_->ced, 
            $_->email,  
            $_->uidNumber, 
            $_->uid, 
            ]
        } @person, 
    ];

	$self->status_ok($c, entity => \%datos);
}


sub addMember_PUT {
    my ($self, $c) = @_;
    my $ldap = Covetel::LDAP->new;

    my $personas = $c->req->data->{personas};
    my $gid = $c->req->data->{gid};
    my $g = $ldap->group({gidNumber => $gid});
    foreach (@{$personas}){
        s/\s+//g;
        if ($ldap->person({uid => $_})){
            if ($g) {
                $g->add_member($_);
                $g->update;
            }
        }
    }
	my %datos;

    $self->status_ok($c, entity => \%datos);
}

sub delMember_PUT {
    my ($self, $c) = @_;
    my $ldap = Covetel::LDAP->new;

    my %datos;
    
    my $del = $c->req->data->{personas};
    my $gid = $c->req->data->{gid};

    my $g = $ldap->group({gidNumber => $gid});

    my $members = $g->members();

    use Data::Dumper; 

    $c->log->debug(Dumper($members));

    my $new_members;
    map { push @{$new_members} , $_ unless $_ ~~ @{$del} } @{$members};
    
    $c->log->debug(Dumper($new_members));

    $g->members($new_members);

    $g->update;
    
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
