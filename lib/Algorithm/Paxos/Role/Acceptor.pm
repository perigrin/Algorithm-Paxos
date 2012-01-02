package Algorithm::Paxos::Role::Acceptor;
use Moose::Role;
use namespace::autoclean;

has last_prepared_id => (
    isa     => 'Str',
    is      => 'rw',
    default => 0
);

has proposals => (
    isa     => 'ArrayRef',
    traits  => ['Array'],
    default => sub { [] },
    handles => {
        add_proposal    => 'push',
        latest_proposal => [ 'get', -1 ],
        proposal_count  => 'count',
    }
);

sub prepare {
    my ( $self, $id ) = @_;
    my $last = $self->last_prepared_id;
    confess "Prepared id does not exceed lastest prepared id." if $id < $last;
    $self->last_prepared_id($id);
    return $self->latest_proposal ? $self->latest_proposal->[0] : 0;
}

sub accept {
    my ( $self, $id, $value ) = @_;
    my $last = $self->last_prepared_id;
    confess "Proposal id exceeds lastest prepared id." if $id < $last;
    $self->add_proposal( [ $id, $value ] );
}

1;
__END__
