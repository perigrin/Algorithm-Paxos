package Algorithm::Paxos::Role::Learner;
use Moose::Role;
use namespace::autoclean;

# ABSTRACT: A Learner role for the Paxos algorithm

has proposals => (
    isa     => 'HashRef',
    traits  => ['Hash'],
    default => sub { +{} },
    handles => {
        learn          => 'set',
        proposal_ids   => 'keys',
        proposal_count => 'count',
        proposal       => 'get',
    }
);

sub latest_proposal {
    my $self = shift;
    my ($last) = reverse sort $self->proposal_ids;
    return unless $last;
    $self->get_proposal($last);
}

1;
__END__

=head1 DESCRIPTION

From L<Wikipedia|http://en.wikipedia.org/wiki/Paxos_algorithm>

    Learners act as the replication factor for the protocol. Once a Client
    request has been agreed on by the Acceptors, the Learner may take action
    (i.e.: execute the request and send a response to the client). To improve
    availability of processing, additional Learners can be added.

=head1 SYNOPSIS

    package MyApp::PaxosBasic;
    use Moose;
    
    with qw(Algorithm::Paxos::Role::Learner);
    
    1;
    __END__
    
=method learn ( $id, $value ) 

This is the main interface between Acceptors and Leaners. When a value is
choosen by the cluster, C<learn> is passed the id and value and is recorded in
stable storage. The default implementation stores everything in an in-memory
HashRef.

=method proposal_ids ( ) : @ids

Returns a list of proposal ids.

=method proposal_count ( ) : $count

Returns the number of proposals to date.

=meethod proposal ( $id ) : $value

Returns the value stored for C<$id>.

=method latest_proposal ( ) : $value

Returns the value of the proposal with the greatest id.
