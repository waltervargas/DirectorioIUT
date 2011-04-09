use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'DIUT' }
BEGIN { use_ok 'DIUT::Controller::Personas' }

ok( request('/personas')->is_success, 'Request should succeed' );
done_testing();
