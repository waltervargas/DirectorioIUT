package Covetel::LDAP::Group;
use Moose; 
use Covetel::LDAP;
use Net::LDAP::Entry;
use utf8;

has entry    => (
    is      => "ro",
    isa     => "Net::LDAP::Entry",
    lazy    => 1,
    builder => "_build_entry"
);

has dn 	=> (
    is      => "ro",
	isa 	=> 'Str',
    lazy    => 1,
    builder => "_build_dn"
);

has ldap => (
	is 		=> "ro",
    isa     => "Covetel::LDAP",
    lazy    => 1,
    builder => "_build_ldap",
);

has nombre => (
    is      => "rw", 
    isa     => "Str", 
);

has descripcion => (
    is      => "rw", 
    isa     => "Str", 
);

has gidNumber => (
	is 		=> 'rw',
	isa 	=> 'Int', 
	default => sub { 1000 + int rand 4000 },
	lazy 	=> 1
);

sub _build_dn {
	my $self = shift;
	
    my $base = $self->ldap->config->{'Covetel::LDAP'}->{'base_grupos'};
	my $dn = 'cn='.$self->nombre.','.$base;
}

sub _build_entry {
	my $self = shift;
	my $entry = Net::LDAP::Entry->new;

	$entry->dn($self->dn);

	$entry->add(objectClass => ['top', 'posixGroup']);
	$entry->add(cn => $self->nombre);
	$entry->add(gidNumber => $self->gidNumber);
    $entry->add(description => $self->descripcion);

    return $entry;
}

sub _build_ldap {
	my $self = shift;
	my $ldap = Covetel::LDAP->new;
	return $ldap;
}

sub add {
	my $self = shift;

	my $mesg = $self->ldap->server->add($self->entry);
	$self->ldap->message($mesg);
	if ($mesg->is_error()){
		return 0;
	} else {
		return 1;
	}
}

sub del {
	my $self = shift;
	my $mesg = $self->ldap->server->delete($self->dn);
	$self->ldap->message($mesg);
	if ($mesg->is_error()){
		return 0;
	} else {
		return 1;
	}
}

1;
