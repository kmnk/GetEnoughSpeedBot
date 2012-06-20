package Bot::Twitter::OAuth::Authenticate;

use base qw/Class::Accessor::Fast/;

use Carp qw/croak/;
use OAuth::Lite::Consumer;

use Bot::Twitter::OAuth::Requester;

__PACKAGE__->mk_ro_accessors(qw/
    consumer
    _consumer
    _request_token
    _access_token
/);

sub new {
    my ($class, $param_ref) = @_;

    my $self = $class->SUPER::new($param_ref);

    $self->_create_oauth_consumer();

    return $self;
}

sub _create_oauth_consumer {
    my ($self) = @_;

    $self->{_consumer} = OAuth::Lite::Consumer->new(
        consumer_key    => $self->consumer()->{key},
        consumer_secret => $self->consumer()->{secret},
        site               => 'https://api.twitter.com/oauth',
        request_token_path => '/request_token',
        access_token_path  => '/access_token',
        authorize_path     => '/authorize',
    );
}

sub obtain_request_token {
    my ($self) = @_;

    my $request_token = $self->_consumer()->get_request_token();
    croak 'can not get request token' unless $request_token;

    $self->{_request_token} = $request_token;
}

sub get_authorize_url {
    my ($self) = @_;

    return $self->_consumer()->url_to_authorize(
        token => $self->_request_token(),
    );
}

sub obtain_access_token {
    my ($self, $param_ref) = @_;

    my ($code) = @{ $param_ref }{qw/
        code
    /};

    my $access_token = $self->_consumer()->get_access_token(
        token    => $self->_request_token(),
        verifier => $code,
    );
    croak 'can not get access token' unless $access_token;

    $self->{_access_token} = $access_token;
}

sub create_requester {
    my ($self) = @_;

    return Bot::Twitter::Oauth::Requester->new({
        consumer     => $self->_consumer(),
        access_token => $self->_access_token(),
    });
}

1;
__END__

=head1 NAME

Bot::Twitter::OAuth::Authenticate - authenticate


=head1 LICENSE

MIT License


=head1 Author

kmnk <kmnknmk+com-github@gmail.com>


=cut
