use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'DIUT' }
BEGIN { use_ok 'DIUT::Controller::bpersona' }

ok( request('/bpersona')->is_success, 'Request should succeed' );
done_testing();
