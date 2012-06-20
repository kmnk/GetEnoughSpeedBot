package Bot::Twitter::Oauth::Requester;

use base qw/Class::Accessor::Fast/;

use AnyEvent::HTTP;
use AnyEvent::Twitter::Stream;

__PACKAGE__->mk_ro_accessors(qw/consumer access_token/);

sub request_stream {
    my ($self, $param_ref, $callback) = @_;

    my ($method, $endpoint, $arg_ref) = @{ $param_ref }{qw/
        method   endpoint   arg
    /};

    my $cv = AE::cv();
    my $listner = AnyEvent::Twitter::Stream->new(
        consumer_key    => $self->consumer()->consumer_key(),
        consumer_secret => $self->consumer()->consumer_secret(),
        token           => $self->access_token()->token(),
        token_secret    => $self->access_token()->secret(),
        method          => "userstream",
        timeout         => 120,
        on_connect      => sub { warn "on connect\n"; },
        on_tweet => sub {
            my ($content) = @_;
            return unless $content->{text};
            return unless $content->{user};
            $callback->($content);
        },
        on_keepalive    => sub { warn "on keepalive\n"; },
        on_delete       => sub { warn "on delete\n"; },
    );
    $cv->recv();
}

sub request_rest {
    my ($self, $param_ref, $callback) = @_;

    my ($method, $endpoint, $arg_ref) = @{ $param_ref }{qw/
        method   endpoint   arg
    /};

    my $res = $self->consumer()->request(
        method => $method,
        url    => $endpoint,
        token  => $self->access_token(),
        params => $arg_ref,
    );

    return $res unless $res->is_success();

    return $callback->($res->decoded_content());
}

1;
__END__

=head1 NAME

Bot::Twitter::OAuth::Requester - requester


=head1 LICENSE

MIT License


=head1 Author

kmnk <kmnknmk+com-github@gmail.com>


=cut
