package DIUT::Controller::AJAX;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller::REST'; }
use utf8;

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

sub groupmembers : Local : ActionClass('REST') {}

sub usuario_exists : Path('usuario/exists') Args(1) ActionClass('REST') {}

sub addMember : Path('grupos/add') Args ActionClass('REST') {}

sub delMember : Path('grupos/del') Args ActionClass('REST') {}

sub delete_groups : Path('delete/groups') Args ActionClass('REST') {}

sub delete_persons : Path('delete/persons') Args ActionClass('REST') {}

sub utf8_decode {
    my ($str) = @_;
    utf8::decode($str);
    return $str;
}

sub grupos_GET {
	my ($self, $c) = @_;
    my %datos; 
    
    my $ldap = Covetel::LDAP->new;
    my @lista = $ldap->group();

    $datos{aaData} = [
        map {
            [

                '<input type="checkbox" name="del" value="'.$_->gidNumber.'">', 
                $_->gidNumber, &utf8_decode($_->nombre), &utf8_decode($_->description), 
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
            '<input type="checkbox" name="del" value="'.$_->uid.'">', 
            &utf8_decode($_->firstname), 
            &utf8_decode($_->lastname), 
            $_->ced, 
            $_->email,  
            $_->uidNumber, 
            $_->uid, 
            '<a href="/personas/detalle/' . $_->uid . '"> Ver detalle </a>', 
            ]
        } grep { !($_->uid eq 'root') } @lista, 
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
            &utf8_decode($_->firstname), 
            &utf8_decode($_->lastname), 
            $_->ced, 
            $_->email,  
            $_->uidNumber, 
            $_->uid, 
            ]
        } grep { !($_->uid eq 'root') } @person, 
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

sub delMember_DELETE {
    my ($self, $c) = @_;
    my $ldap = Covetel::LDAP->new;
    my %datos;
    my $del = $c->req->data->{personas};
    my $gid = $c->req->data->{gid};
    my $g = $ldap->group({gidNumber => $gid});
    my $members = $g->members();
    my $new_members;
    map { push @{$new_members} , $_ unless $_ ~~ @{$del} } @{$members};
    $c->log->debug(Dumper($new_members));
    $g->members($new_members);
    $g->update;
    $self->status_ok($c, entity => \%datos);
}

sub delete_groups_DELETE {
    my ( $self, $c ) = @_;
    my $ldap = Covetel::LDAP->new;
    my %resp;

    my $gids = $c->req->data->{gids};

    my $status = 1;

    foreach (@{$gids}){
        my $g = $ldap->group({gidNumber => $_});
        if ($g){
            unless($g->del()){
                $self->status_bad_request(
                    $c,
                    message => "No fue posible eliminar el registro",
                );
            }
        }
    }

    $resp{estatus} = $status;
    $self->status_ok($c, entity => \%resp);
    
}

sub delete_persons_DELETE {
    my ( $self, $c ) = @_;
    my $ldap = Covetel::LDAP->new;
    my %resp;
    my $uids = $c->req->data->{uids};
    my $status = 1;

    foreach (@{$uids}){
        my $p = $ldap->person({uid => $_});
        if ($p){
            unless($p->del()){
                $self->status_bad_request(
                    $c,
                    message => "No fue posible eliminar el registro",
                );
            }
        }
    }
    
    $resp{estatus} = $status;
    $self->status_ok($c, entity => \%resp);
}

=head1 AUTHOR

Walter Vargas

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
