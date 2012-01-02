#!/usr/bin/env perl
use strict;
use Test::More;
use Data::Dumper;
{

    package BasicPaxos;
    use Moose;
    with qw(
        Algorithm::Paxos::Role::Proposer
        Algorithm::Paxos::Role::Acceptor
    );
}

my @synod = map { BasicPaxos->new() } ( 1 .. 3 );
$synod[0]->_set_acceptors( [ @synod[ 1, 2 ] ] );
$synod[1]->_set_acceptors( [ @synod[ 0, 2 ] ] );
$synod[1]->_set_acceptors( [ @synod[ 0, 1 ] ] );

ok( !$synod[1]->proposal_count,         'no proposal recorded' );
ok( $synod[0]->prospose('Hello World'), 'made a proposal' );
ok( $synod[1]->proposal_count,          'got a proposal recorded' );
done_testing();
