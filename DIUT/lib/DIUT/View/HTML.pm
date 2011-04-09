package DIUT::View::HTML;

use strict;
use warnings;

use base 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    INCLUDE_PATH => [ 
        DIUT->path_to('root', 'lib'),  
        DIUT->path_to('root', 'src') 
    ], 
    render_die => 1,
    WRAPPER => 'header.tt', 
    CATALYST_VAR => 'c', 
);

=head1 NAME

DIUT::View::HTML - TT View for DIUT

=head1 DESCRIPTION

TT View for DIUT.

=head1 SEE ALSO

L<DIUT>

=head1 AUTHOR

ApHu,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
