use strict;
use warnings;
use Test::More;


use Catalyst::Test 'DIUT';
use DIUT::Controller::Login;

ok( request('/login')->is_success, 'Request should succeed' );
done_testing();
