package Bot::Text::Changer::EnoughSpeed;

use base qw/Class::Accessor::Fast/;

use Encode qw/encode/;

use constant {
    FORMAT => 'RT: @%s %s',
};

sub change {
    my ($self, $param_ref) = @_;

    my ($text, $screen_name, $id) = @{ $param_ref }{qw/
        text   screen_name   id
    /};

    return unless $text =~ qr/たい[。｡．. 　…]*\z/;

    my $encoded_text = encode 'utf-8', $text;
    $encoded_text =~ s{やりたい([。｡．. 　…]*)\z}{やった$2};
    $encoded_text =~ s{作りたい([。｡．. 　…]*)\z}{作った$2};
    $encoded_text =~ s{会いたい([。｡．. 　…]*)\z}{会った$2};
    $encoded_text =~ s{(た)い([。｡．. 　…]*)\z}{$1$2};

    return sprintf FORMAT(), $screen_name, $encoded_text;
}



1;
__END__

=head1 NAME

Bot::Text::Changer::EnoughSpeed - text changer


=head1 LICENSE

MIT License


=head1 Author

kmnk <kmnknmk+com-github@gmail.com>


=cut
