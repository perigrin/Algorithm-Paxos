package Algorithm::Paxos::Role::Proposer;
use Moose::Role;
use namespace::autoclean;

use Try::Tiny;

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

sub new_proposal_id { time() }

sub prospose {
    my ( $self, $value ) = @_;
    my $n = $self->new_proposal_id;

    my @replies = map {
        try { $self->prepare($n) }
        catch { warn $_; undef }
    } $self->acceptors;

    if ( $self->is_quorum(@replies) ) {
        my $v = $self->highest_proposal_id(@replies);
        $_->accept( $n, $v ) for $self->acceptors;
        return $n;
    }
    confess "Proposal Failed";
}

1;
__END__
