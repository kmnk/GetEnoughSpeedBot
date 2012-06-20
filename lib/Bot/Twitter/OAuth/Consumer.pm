package Bot::Twitter::OAuth::Consumer;

use base qw/Class::Accessor::Fast/;

use Carp qw/croak/;
use JSON;

__PACKAGE__->mk_ro_accessors(qw/key secret/);

use constant {
    SECRET_PATH => '_secret/key.json'
};

sub new {
    my ($class) = @_;

    my $self = $class->SUPER::new();

    $self->_load_key();

    return $self;
}

sub _load_key {
    my ($self) = @_;

    open my $fh, '<', SECRET_PATH() or croak $!;

    my @lines = <$fh>;

    my $key = JSON->new()->decode( join '', @lines );

    $self->{key}    = $key->{key};
    $self->{secret} = $key->{secret};
}

1;
__END__

=head1 NAME

Bot::Twitter::OAuth::Consumer - consumer


=head1 LICENSE

MIT License


=head1 Author

kmnk <kmnknmk+com-github@gmail.com>


=cut
