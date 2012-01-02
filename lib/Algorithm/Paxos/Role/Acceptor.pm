package Algorithm::Paxos::Role::Acceptor;
use Moose::Role;
use namespace::autoclean;

has [qw(last_prepared_id last_accepted_id)] => (
    isa     => 'Str',
    is      => 'rw',
    default => 0
);

has learners => (
    isa     => 'ArrayRef',
    writer  => '_set_learners',
    traits  => ['Array'],
    default => sub { [] },
    handles => { learners => 'elements', }
);

sub _latest_proposal {
    my $self = shift;
    my ($learner) = $self->learners;
    $learner->latest_proposal;
}

sub prepare {
    my ( $self, $id ) = @_;
    my $last = $self->last_accepted_id;
    confess "Prepared id does not exceed lastest prepared id." if $id < $last;
    $self->last_prepared_id($id);
    return 0 unless $self->proposal_count;
    return $self->last_accepted_id;
}

sub accept {
    my ( $self, $id, $value ) = @_;
    my $last = $self->last_prepared_id;
    confess "Proposal id exceeds lastest prepared id." if $id < $last;
    $_->learn( $id => $value ) for $self->learners;
    return ( $id, $value );
}

1;
__END__
