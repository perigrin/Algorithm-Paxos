package Algorithm::Paxos::Role::Proposer;
use 5.10.0;
use Moose::Role;
use namespace::autoclean;

# ABSTRACT: A Proposer role for the Paxos algorithm

use Try::Tiny;
use Algorithm::Paxos::Exception;

has acceptors => (
    isa     => 'ArrayRef',
    writer  => '_set_acceptors',
    traits  => ['Array'],
    handles => {
        acceptors      => 'elements',
        acceptor_count => 'count',
    }
);

sub is_quorum {
    my ( $self, @replies ) = @_;
    my @successes = grep {defined} @replies;
    return @successes > ( $self->acceptor_count / 2 );
}

sub highest_proposal_id {
    my ( $self, @replies ) = @_;
    my @successes = grep {defined} @replies;
    return ( sort @successes )[0];
}

sub new_proposal_id { state $i++ }

sub prospose {
    my ( $self, $value ) = @_;
    my $n = $self->new_proposal_id;

    my @replies = map {
        try { $self->prepare($n) }
        catch { warn $_; undef }
    } $self->acceptors;

    if ( $self->is_quorum(@replies) ) {
        my $v = $self->highest_proposal_id(@replies);
        $v ||= $value;
        $_->accept( $n, $v ) for $self->acceptors;
        return $n;
    }
    throw("Proposal failed to reach quorum");
}

1;
__END__

=head1 DESCRIPTION

From L<Wikipedia|http://en.wikipedia.org/wiki/Paxos_algorithm>

    A Proposer advocates a client request, attempting to convince the
    Acceptors to agree on it, and acting as a coordinator to move the protocol
    forward when conflicts occur.

=head1 SYNOPSIS

    package MyApp::PaxosBasic;
    use Moose;
    
    with qw(Algorithm::Paxos::Role::Proposer);
    
    1;
    __END__
    
=method acceptors ( ) : @acceptors

Returns a list of the acceptors.

=method acceptor_count ( ) : $count

Returns count of the number of acceptors.

=method is_quorum ( @replies ) : $bool

Takes a list of IDs and sees if they meet a quorum.

=method highest_proposal_id ( @replies ) : $id 

Takes a list of replies and returns the highest proposal id from the list.

=method new_proposal_id ( ) : $id

Generates a new proposal id. The default implementation is an increasing
integer (literally C<$i++>).

=method prospose ( $value ) : $id

Propose is the main interface between clients and the Paxos cluster/node.
Propose takes a single value (the proposal) and returns the ID that is
assigned to that proposal. If the proposal fails an exception is thrown.
