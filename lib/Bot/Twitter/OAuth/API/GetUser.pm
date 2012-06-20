package Bot::Twitter::OAuth::API::GetUser;

use base qw/Class::Accessor::Fast/;

use constant {
    METHOD    => 'GET',
    ENDTPOINT => 'https://userstream.twitter.com/2/user.json',
};

__PACKAGE__->mk_ro_accessors(qw/requester/);

sub get {
    my ($self, $callback) = @_;

    return $self->requester()->request_stream({
        method   => METHOD(),
        endpoint => ENDTPOINT(),
        arg      => {
        },
    }, $callback);
}

1;
__END__

=head1 NAME

Bot::Twitter::OAuth::API::GetUser - api : get user stream


=head1 LICENSE

MIT License


=head1 Author

kmnk <kmnknmk+com-github@gmail.com>


=cut
