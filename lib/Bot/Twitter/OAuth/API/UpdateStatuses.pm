package Bot::Twitter::OAuth::API::UpdateStatuses;

use base qw/Class::Accessor::Fast/;

use constant {
    METHOD    => 'POST',
    ENDTPOINT => 'https://api.twitter.com/1/statuses/update.json',
};

__PACKAGE__->mk_ro_accessors(qw/requester/);

sub update {
    my ($self, $status) = @_;

    return $self->requester()->request_rest({
        method   => METHOD(),
        endpoint => ENDTPOINT(),
        arg      => {
            status => $status,
        },
    }, sub { warn "done\n"; });
}

1;
__END__

=head1 NAME

Bot::Twitter::OAuth::API::UpdateStatuses - api : update statuses


=head1 LICENSE

MIT License


=head1 Author

kmnk <kmnknmk+com-github@gmail.com>


=cut
