#!/usr/bin/perl
use strict;
use warnings;

use FindBin::libs;
use IO::Prompt qw/prompt/;

use Bot::Twitter::OAuth::Consumer;
use Bot::Twitter::OAuth::Authenticate;
use Bot::Twitter::OAuth::API::GetUser;
use Bot::Twitter::OAuth::API::UpdateStatuses;
use Bot::Text::Changer::EnoughSpeed;

my $consumer = Bot::Twitter::OAuth::Consumer->new();
my $authenticate = Bot::Twitter::OAuth::Authenticate->new({
    consumer => $consumer,
});

use constant {
    OWNER_ID          => 613407807,
    OWNER_SCREEN_NAME => 'getenoughspeed',
};

$authenticate->obtain_request_token();

println('access to: ' . $authenticate->get_authorize_url());
my $code = prompt('authorization code: ');

$authenticate->obtain_access_token({ code => $code });

my $requester = $authenticate->create_requester();

my $get_user_api = Bot::Twitter::OAuth::API::GetUser->new({
    requester => $requester,
});

my $update_statuses_api = Bot::Twitter::OAuth::API::UpdateStatuses->new({
    requester => $requester,
});

my $changer = Bot::Text::Changer::EnoughSpeed->new();

my $res = $get_user_api->get(sub {
    my ($content) = @_;

    return if $content->{user}{id} == OWNER_ID();
    return if $content->{user}{screen_name} eq OWNER_SCREEN_NAME();

    my $changed = $changer->change({
        text        => $content->{text},
        id          => $content->{user}{id},
        screen_name => $content->{user}{screen_name},
    });

    return unless $changed;

    $update_statuses_api->update($changed);
});

sub println {
    my ($string) = @_;
    print "$string\n";
}


__END__

=head1 NAME

app.pl - application runner


=head1 LICENSE

MIT License


=head1 Author

kmnk <kmnknmk+com-github@gmail.com>


=cut
