package Covetel::Person;
use Moose;

has firstname => ( is => 'rw', isa => 'Str');
has lastname => ( is => 'rw', isa => 'Str');
has ced   => ( is => 'rw', isa => 'Int' );
has email    => ( is => 'rw', isa => 'Str' );

1;
