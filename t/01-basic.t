#!/usr/bin/env perl
use strict;
use Test::More;
use DDP;
{

    package BasicPaxos;
    use Moose;
    with qw(
        Algorithm::Paxos::Role::Proposer
        Algorithm::Paxos::Role::Acceptor
        Algorithm::Paxos::Role::Learner
    );
}

my @synod = map { BasicPaxos->new() } ( 0 .. 2 );

# wire up acceptors
$synod[0]->_set_acceptors( [ @synod[ 1, 2 ] ] );
$synod[1]->_set_acceptors( [ @synod[ 0, 2 ] ] );
$synod[1]->_set_acceptors( [ @synod[ 0, 1 ] ] );

# wire learners
$synod[0]->_set_learners( \@synod );
$synod[1]->_set_learners( \@synod );
$synod[1]->_set_learners( \@synod );

ok( !$synod[1]->proposal_count, 'no proposal recorded' );
 my $id = $synod[0]->prospose('Hello World');
 ok(defined $id, 'made a proposal' );
ok( $synod[1]->proposal_count, 'got a proposal recorded' );
ok( $synod[1]->proposal($id) eq $synod[2]->proposal($id),
    'same proposal in two nodes' );


done_testing();
