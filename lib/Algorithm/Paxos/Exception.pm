package Algorithm::Paxos::Exception;
use Moose;

# ABSTRACT: Simple sugar for Throwable::Error


use Sub::Exporter::Util ();
use Sub::Exporter -setup =>
    { exports => [ throw => Sub::Exporter::Util::curry_method('throw'), ], };

extends qw(Throwable::Error);

sub throw {
    my $class = shift;
    return $class->new(@_);
}

1;
__END__

=head1 DESCRIPTION

This is a very thin sugar wrapper around L<Throwable::Error>.

=head1 SYNOPSIS

    use Algorithm::Paxos::Exception;
    ...
    
    throw "Something failed";

=method throw

Throw a new exception 

=head1 SEE ALSO

=for :list
* L<Throwable>