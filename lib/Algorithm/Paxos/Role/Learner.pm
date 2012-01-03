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
