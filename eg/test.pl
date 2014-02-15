# -*- perl -*-

# Copyright (c) 2007 by Jeff Weisberg
# Author: Jeff Weisberg <jaw+pause @ tcp4me.com>
# Created: 2007-Feb-05 19:58 (EST)
# Function: for misc testing and Devel::Profile-ing
#
# $Id: test.pl,v 1.5 2007/02/10 22:09:31 jaw Exp $

use lib 'lib';
use Encoding::BER qw(hexdump);
use Encoding::BER::SNMP;
use Math::BigInt;

use strict;


for (0 .. 100){
my $ber = Encoding::BER::SNMP->new( debug => 0 );
# Note: the profiler tells us: debug or fast, not both.

my $data = [ 0,
	     { type => 'counter32', value => 333 },
	     { type => 'integer', value => '77777777666666665555555544444444' },
	     'public',
	     { type  => ['universal', 'primitive', 42],  value => 'gudunk-gudunk' },
	     { type  => ['constructed', 'octet_string'], value => [ 'foo', 'bar', 'baz' ] },
	     { type  => 'unsigned_integer', value => 0xffff0000 },
	     { type  => [ 'context', 'constructed', 5000 ],
	       value => [ -1234, 
			  -3.1,
			  0.25,
			  [
			   [ { type => 'oid', value => '.1.3.6.1.2.3.0'},    undef ],
			   [ { type => 'oid', value => '.1.3.6.1.2.4567.3'}, undef ],
			   ],
			  ] },
	     ];

my $p = $ber->encode( $data );

hexdump($p);

my $x = $ber->decode($p);
} 
