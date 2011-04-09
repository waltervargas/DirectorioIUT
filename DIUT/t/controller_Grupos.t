use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'DIUT' }
BEGIN { use_ok 'DIUT::Controller::Grupos' }

ok( request('/grupos')->is_success, 'Request should succeed' );
done_testing();
