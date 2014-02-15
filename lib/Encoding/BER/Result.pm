# -*- perl -*-

# Copyright (c) 2007 by Jeff Weisberg
# Author: Jeff Weisberg <jaw+pause @ tcp4me.com>
# Created: 2007-Feb-07 20:48 (EST)
# Function: 
#
# $Id: Result.pm,v 1.1 2007/02/09 05:26:37 jaw Exp $

package Encoding::BER::Result;
use strict;

sub new {
    my $c  = shift;
    my $me = shift;
    
    bless $me, $c;
}

sub value {
    my $me = shift;
    $me->{value};
}

# tree of only values
sub values_only {
    my $me = shift;
    my $v  = $me->{value};

    return $v unless ref $v;

    my @v;
    for my $r (@$v){
	push @v, $r->values_only();
    }

    return \@v;
}

sub node_map {
    my $me  = shift;
    my $res = shift;
    my $tpl = shift;

    $me->node_or_value_map($res, $tpl, 0);
}

sub value_map {
    my $me  = shift;
    my $res = shift;
    my $tpl = shift;

    $me->node_or_value_map($res, $tpl, 1);
}

sub node_or_value_map {
    my $me  = shift;
    my $res = shift;
    my $tpl = shift;
    my $vp  = shift;

    unless( ref $tpl ){
	$res->{$tpl} = $me;
	return $res;
    }
    unless( ref $me->{value} ){
	return $res;
    }

    my @v = @{$me->{value}};
    for my $t (@$tpl){
	my $v = shift @v;
	if( ref $t eq 'ARRAY' ){
	    $v->value_map($res, $t);
	}elsif(ref $t){
	    $res->{$$t} = $v;
	}elsif(defined $t){
	    $res->{$t} = $vp ? $v->{value} : $v;
	}else{
	    # skip
	}
    }
    $res;
}


# RSN - XPath?
sub elem_by_path {
    my $me = shift;

    for my $n (@_){
	return unless $me && ref $me->{value};
	$me = $me->{value}[$n];
    }
    $me;
}

################################################################

1;
