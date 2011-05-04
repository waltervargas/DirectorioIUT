use strict;
use warnings;
use Test::More;


use Catalyst::Test 'DIUT';
use DIUT::Controller::AJAX;

ok( request('/ajax')->is_success, 'Request should succeed' );
done_testing();
