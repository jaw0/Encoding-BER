# -*- perl -*-

# Copyright (c) 2007 by Jeff Weisberg
# Author: Jeff Weisberg <jaw+pause @ tcp4me.com>
# Created: 2007-Feb-10 16:42 (EST)
# Function: dumper test
#
# $Id: t3.t,v 1.2 2007/02/10 22:23:24 jaw Exp $

use lib 'lib';
use Encoding::BER::Dumper;
use strict;

print "1..6\n";
my $tno = 1;

my $b = pl2ber([
		0, 1, 2, 3,
		{ foo => 'a', bar => 'b' },
		undef ]);

my $expect = qq{
    30 20 02 01 00 02 01 01  02 01 02 02 01 03 63 10
    04 03 62 61 72 04 01 62  04 03 66 6F 6F 04 01 61
    05 00                                           
};

$expect =~ s/\s//gs;
$expect = pack('H*', $expect);

test( $expect eq $b);

my $d = ber2pl($b);

test( @$d == 6 );
test( $d->[2] == 2 );
test( $d->[4]{foo} eq 'a');
test( $d->[4]{bar} eq 'b');
test( ! defined $d->[5] );

sub test {
    my $ok = shift;

    print(($ok ? "ok" : "not ok"), " ", $tno++, "\n");
}
