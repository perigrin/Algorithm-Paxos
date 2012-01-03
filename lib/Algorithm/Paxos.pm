package Algorithm::Paxos;

# ABSTRACT: An implementation of the Paxos protocol

1;
__END__

=head1 DESCRIPTION

NOTE: This is Alpha level code. The algorithm works, I'm fairly certain it
works to spec it does not have anything near fully test coverage and it hasn't
been used in anything resembling a production environment yet. I'm releasing
it because I think it'll be useful and I don't want it lost on github.

From L<Wikipedia|http://en.wikipedia.org/wiki/Paxos_algorithm>

    Paxos is a family of protocols for solving consensus in a network of
    unreliable processors. Consensus is the process of agreeing on one result
    among a group of participants. This problem becomes difficult when the
    participants or their communication medium may experience failures.

This package implements a basic version of the Basic Paxos protocol and
provides an API (and hooks) for extending into a more complicated solution as
needed.

=head1 SYNOPSIS

    package BasicPaxos;
    use Moose;
    with qw(
        Algorithm::Paxos::Role::Proposer
        Algorithm::Paxos::Role::Acceptor
        Algorithm::Paxos::Role::Learner
    );
    
    package main;
    
    my @synod = map { BasicPaxos->new() } ( 0 .. 2 );
    $_->_set_acceptors( \@synod ) for @synod;
    $_->_set_learners( \@synod ) for @synod;

=head1 SEE ALSO 

=for :list
* L<Paxos Made Simple [PDF]|http://research.microsoft.com/en-us/um/people/lamport/pubs/paxos-simple.pdf>
* L<Doozer|http://xph.us/2011/04/13/introducing-doozer.html>
* L<Chubby|http://research.google.com/archive/chubby.html>
* L<Wikipedia|http://en.wikipedia.org/wiki/Paxos_algorithm>


