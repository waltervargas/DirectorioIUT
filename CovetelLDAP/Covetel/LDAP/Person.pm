package Covetel::LDAP::Person;
use Moose; 
use Covetel::LDAP;
use Net::LDAP::Entry;
use Digest::MD5 qw(md5 md5_hex md5_base64);
use Covetel::Email;

extends 'Covetel::Person';

has entry    => (
    is      => "ro",
    isa     => "Net::LDAP::Entry",
    lazy    => 1,
    builder => "_build_entry"
);

has dn 	=> (
	is 		=> 'rw',
	isa 	=> 'Str',
);

has uid 	=> (
	is 		=> 'rw',
	isa 	=> 'Str',
);

has uidNumber => (
	is 		=> 'rw',
	isa 	=> 'Int',
	default => sub { int rand 4000 },
	lazy 	=> 1
);

has ldap => (
	is 		=> "ro",
    isa     => "Covetel::LDAP",
    lazy    => 1,
    builder => "_build_ldap",
);

has passwd => (
	is 		=> 'rw',
	isa 	=> 'Str',
);

sub mail {
	my ($self, $mail) = @_; 
    $self->email($mail);
	$self->entry->add(mail => $mail); 
}

sub password {
	my ($self, $password) = @_; 
	my $p = md5_base64($password);
	$p = "{MD5}".$p."==";
	$self->entry->add(userPassword => $p); 
    $self->passwd($password);
}

sub _build_entry {
	my $self = shift;
	my $base = $self->ldap->config->{'Covetel::LDAP'}->{'base_personas'};
	my $dn = 'uid='.$self->uid.','.$base;
	my $entry = Net::LDAP::Entry->new;
	$self->dn($dn);
	$entry->dn($dn);
	$entry->add(objectClass => ['top', 'inetOrgPerson', 'posixAccount']);
	$entry->add(cn => $self->firstname.' '.$self->lastname);
	$entry->add(uidNumber => $self->uidNumber);
	$entry->add(gidNumber => $self->uidNumber);
	$entry->add(sn => $self->lastname);
	$entry->add(givenName => $self->firstname);
	$entry->add(homeDirectory => '/home/'.$self->uid);
	return $entry;
}

sub _build_ldap {
	my $self = shift;
	my $ldap = Covetel::LDAP->new;
	return $ldap;
}

sub add {
	my $self = shift;
	#my $mesg = $self->entry->update($self->ldap->server);

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

sub notify {
    my $self = shift;
    my $email = Covetel::Email->new();
    
	$email->from('walter@covetel.com.ve');
	$email->to($self->email);
	$email->subject('Ha sido creada una nueva cuenta para usted.');
	$email->body_process(
	    {
	        input  => 'correo.tt2',
	        uid    => $self->uid,
	        passwd => $self->passwd,
	        correo => $self->email, 
	        nombre => $self->firstname.' '.$self->lastname, 
	    } 
	);
    
    $email->send();
}

1;
