# /usr/bin/perl
#
# This small script generates an Seeded SHA1 hash of 'secret'
# (using the seed "salt") for use as a userPassword or rootpw value.
#
use Digest::SHA1;
use MIME::Base64;
$ctx = Digest::SHA1->new;
$ctx->add('secret');
$ctx->add('salt');
$hashedPasswd = '{SSHA}' . encode_base64($ctx->digest . 'salt' ,'');
print 'userPassword: ' .  $hashedPasswd . "\n";
